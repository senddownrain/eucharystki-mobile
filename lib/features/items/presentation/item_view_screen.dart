import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/empty_state.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../settings/presentation/settings_controller.dart';
import 'items_controller.dart';
import 'widgets/text_settings_sheet.dart';

class ItemViewScreen extends ConsumerWidget {
  final String id;
  const ItemViewScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemsControllerProvider).value ?? [];
    final item = items.where((e) => e.id == id).firstOrNull;
    final settings = ref.watch(settingsControllerProvider);
    final isAdmin = ref.watch(authStateProvider).valueOrNull != null;

    if (item == null) {
      return const Scaffold(body: EmptyState(message: 'Нататка не знойдзена'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        actions: [
          IconButton(
            onPressed: () => Share.share('${item.title}\n${AppConstants.defaultShareBaseUrl}${item.id}'),
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () => ref.read(settingsControllerProvider.notifier).togglePin(item.id),
            icon: Icon(
              settings.pinnedIds.contains(item.id) ? Icons.push_pin : Icons.push_pin_outlined,
            ),
          ),
          IconButton(
            onPressed: () async {
              final updated = await showTextSettingsSheet(context, settings.fontSizeMultiplier);
              if (updated == null) return;
              await ref.read(settingsControllerProvider.notifier).update(
                    settings.copyWith(fontSizeMultiplier: updated),
                  );
            },
            icon: const Icon(Icons.text_fields),
          ),
          if (isAdmin)
            IconButton(
              onPressed: () => context.push('/item/${item.id}/edit'),
              icon: const Icon(Icons.edit),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Html(
              data: item.text,
              style: {
                'body': Style(
                  fontSize: FontSize(16 * settings.fontSizeMultiplier),
                  lineHeight: const LineHeight(1.5),
                ),
              },
            ),
            const SizedBox(height: 16),
            const Center(child: Icon(Icons.auto_stories, size: 18)),
          ],
        ),
      ),
    );
  }
}
