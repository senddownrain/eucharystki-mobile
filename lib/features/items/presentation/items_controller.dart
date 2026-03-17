import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../core/constants/hive_boxes.dart';
import '../../../core/models/item.dart';
import '../../settings/presentation/settings_controller.dart';
import '../data/items_local_repository.dart';
import '../data/items_remote_repository.dart';
import '../data/items_sync_service.dart';

final itemsRemoteRepositoryProvider = Provider((ref) => ItemsRemoteRepository(FirebaseFirestore.instance));
final itemsLocalRepositoryProvider = Provider((ref) => ItemsLocalRepository());
final itemsSyncServiceProvider = Provider((ref) {
  final sync = ItemsSyncService(ref.watch(itemsRemoteRepositoryProvider), ref.watch(itemsLocalRepositoryProvider));
  ref.onDispose(sync.dispose);
  return sync;
});

final itemsControllerProvider = StateNotifierProvider<ItemsController, AsyncValue<List<Item>>>((ref) {
  final c = ItemsController(
    ref.watch(itemsSyncServiceProvider),
    ref.watch(itemsRemoteRepositoryProvider),
    ref,
  );
  c.initialize();
  return c;
});

class ItemsController extends StateNotifier<AsyncValue<List<Item>>> {
  final ItemsSyncService sync;
  final ItemsRemoteRepository remote;
  final Ref ref;
  ItemsController(this.sync, this.remote, this.ref) : super(const AsyncLoading());

  void initialize() {
    final local = sync.loadFromLocal();
    state = AsyncData(local);
    sync.startRealtimeSync((items) => state = AsyncData(items), (e) => state = AsyncData(local));
  }

  Future<void> refreshOffline() => sync.fullDownloadToHive();

  Future<void> save(Item item) async {
    await remote.save(item);
  }

  Future<void> delete(String id) async {
    await remote.delete(id);
    await ref.read(itemsLocalRepositoryProvider).deleteById(id);
  }

  List<Item> filtered({String query = '', Set<String> tags = const {}}) {
    final raw = state.value ?? [];
    final q = query.trim().toLowerCase();
    final settings = ref.read(settingsControllerProvider);
    final filtered = raw.where((item) {
      final text = '${item.title} ${item.text}'.toLowerCase();
      final byQuery = q.isEmpty || text.contains(q);
      final byTags = tags.isEmpty || tags.every(item.tags.contains);
      return byQuery && byTags;
    }).toList();

    filtered.sort((a, b) {
      final ap = settings.pinnedIds.contains(a.id);
      final bp = settings.pinnedIds.contains(b.id);
      if (ap != bp) return ap ? -1 : 1;
      return (b.createdAt ?? DateTime(1970)).compareTo(a.createdAt ?? DateTime(1970));
    });
    return filtered;
  }

  int localCount() => ref.read(itemsLocalRepositoryProvider).count();
  String? lastSyncAt() => Hive.box(HiveBoxes.meta).get('lastSyncAt') as String?;
}
