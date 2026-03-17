import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/export_service.dart';
import '../../../core/widgets/snackbar_helper.dart';
import '../../items/presentation/items_controller.dart';

final exportServiceProvider = Provider((ref) => ExportService());

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemsControllerProvider).value ?? [];
    final controller = ref.read(itemsControllerProvider.notifier);
    final lastSyncAt = controller.lastSyncAt() ?? 'няма';
    final localCount = controller.localCount();

    return Scaffold(
      appBar: AppBar(title: const Text('Адміністраванне')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Лакальна захавана: $localCount'),
            Text('Апошняя сінхранізацыя: $lastSyncAt'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () async {
                try {
                  await ref.read(exportServiceProvider).exportItems(items);
                  if (context.mounted) SnackbarHelper.show(context, 'JSON экспартаваны');
                } catch (e) {
                  if (context.mounted) SnackbarHelper.show(context, 'Памылка экспарту: $e');
                }
              },
              icon: const Icon(Icons.file_download),
              label: const Text('Экспарт у JSON'),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () async {
                try {
                  await controller.refreshOffline();
                  if (context.mounted) SnackbarHelper.show(context, 'База абноўлена і захавана ў Hive');
                } catch (e) {
                  if (context.mounted) SnackbarHelper.show(context, 'Памылка сінхранізацыі: $e');
                }
              },
              icon: const Icon(Icons.sync),
              label: const Text('Спампаваць усю базу ў Hive'),
            ),
          ],
        ),
      ),
    );
  }
}
