import 'dart:async';

import 'package:hive/hive.dart';

import '../../../core/constants/hive_boxes.dart';
import '../../../core/models/item.dart';
import 'items_local_repository.dart';
import 'items_remote_repository.dart';

class ItemsSyncService {
  final ItemsRemoteRepository remote;
  final ItemsLocalRepository local;
  StreamSubscription<List<Item>>? _sub;

  ItemsSyncService(this.remote, this.local);

  List<Item> loadFromLocal() => local.getAll();

  Future<void> fullDownloadToHive() async {
    final all = await remote.fetchAll();
    await local.replaceAll(all);
    await Hive.box(HiveBoxes.meta).put('lastSyncAt', DateTime.now().toIso8601String());
  }

  void startRealtimeSync(void Function(List<Item>) onData, void Function(Object error) onError) {
    _sub?.cancel();
    _sub = remote.watchItems().listen((items) async {
      await local.replaceAll(items);
      await Hive.box(HiveBoxes.meta).put('lastSyncAt', DateTime.now().toIso8601String());
      onData(items);
    }, onError: onError);
  }

  Future<void> dispose() async {
    await _sub?.cancel();
  }
}
