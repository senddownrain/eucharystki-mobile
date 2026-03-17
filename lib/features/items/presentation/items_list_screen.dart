import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/app_settings.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/snackbar_helper.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../settings/presentation/settings_controller.dart';
import 'items_controller.dart';
import 'widgets/compact_item_row.dart';
import 'widgets/item_card.dart';
import 'widgets/tag_filter_sheet.dart';

class ItemsListScreen extends ConsumerStatefulWidget {
  const ItemsListScreen({super.key});

  @override
  ConsumerState<ItemsListScreen> createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends ConsumerState<ItemsListScreen> {
  String _query = '';
  Set<String> _tags = {};

  @override
  Widget build(BuildContext context) {
    final itemsState = ref.watch(itemsControllerProvider);
    final settings = ref.watch(settingsControllerProvider);
    final isAdmin = ref.watch(authStateProvider).valueOrNull != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Малітвы і нататкі'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final c = TextEditingController(text: _query);
              await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Пошук'),
                  content: TextField(controller: c),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                  ],
                ),
              );
              setState(() => _query = c.text);
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () async {
              final allTags = (itemsState.value ?? [])
                  .expand((e) => e.tags)
                  .toSet()
                  .toList()
                ..sort();
              final selected = await showTagFilterSheet(context, allTags: allTags, selected: _tags);
              if (selected != null) setState(() => _tags = selected);
            },
          ),
          PopupMenuButton<String>(
            onSelected: (v) async {
              if (v == 'settings') context.push('/settings');
              if (v == 'about') context.push('/about');
              if (v == 'admin') context.push('/admin');
              if (v == 'login') context.push('/login');
              if (v == 'logout') await ref.read(authRepositoryProvider).signOut();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'settings', child: Text('Налады')),
              const PopupMenuItem(value: 'about', child: Text('Пра праграму')),
              if (isAdmin) const PopupMenuItem(value: 'admin', child: Text('Адміністраванне')),
              PopupMenuItem(value: isAdmin ? 'logout' : 'login', child: Text(isAdmin ? 'Выйсці' : 'Уваход')),
            ],
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () => context.push('/item/new'),
              child: const Icon(Icons.add),
            )
          : null,
      body: itemsState.when(
        loading: () => const AppLoading(),
        error: (e, _) => EmptyState(message: 'Памылка загрузкі: $e'),
        data: (_) {
          final filtered = ref.read(itemsControllerProvider.notifier).filtered(query: _query, tags: _tags);
          if (filtered.isEmpty) return const EmptyState(message: 'Пакуль няма нататак.');

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final item = filtered[i];
              final pinned = settings.pinnedIds.contains(item.id);
              final onDelete = isAdmin
                  ? () async {
                      final ok = await showConfirmationDialog(
                        context,
                        title: 'Выдаліць нататку?',
                        content: 'Гэта дзеянне немагчыма адмяніць.',
                      );
                      if (!ok) return;
                      await ref.read(itemsControllerProvider.notifier).delete(item.id);
                      if (mounted) SnackbarHelper.show(context, 'Нататка выдалена');
                    }
                  : null;

              if (settings.viewMode == ItemListViewMode.compact) {
                return CompactItemRow(
                  item: item,
                  pinned: pinned,
                  onOpen: () => context.push('/item/${item.id}'),
                  onPin: () => ref.read(settingsControllerProvider.notifier).togglePin(item.id),
                  onEdit: isAdmin ? () => context.push('/item/${item.id}/edit') : null,
                  onDelete: onDelete,
                );
              }

              return ItemCard(
                item: item,
                pinned: pinned,
                onOpen: () => context.push('/item/${item.id}'),
                onPin: () => ref.read(settingsControllerProvider.notifier).togglePin(item.id),
                onEdit: isAdmin ? () => context.push('/item/${item.id}/edit') : null,
                onDelete: onDelete,
              );
            },
          );
        },
      ),
    );
  }
}
