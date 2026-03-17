import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/app_settings.dart';
import 'settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsControllerProvider);
    final c = ref.read(settingsControllerProvider.notifier);

    Future<void> save(AppSettings next) => c.update(next);

    return Scaffold(
      appBar: AppBar(title: const Text('Налады')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Цёмная тэма'),
            value: s.themeMode == ThemeMode.dark,
            onChanged: (v) => save(s.copyWith(themeMode: v ? ThemeMode.dark : ThemeMode.light)),
          ),
          SwitchListTile(
            title: const Text('Не выключаць экран'),
            value: s.keepScreenOn,
            onChanged: (v) => save(s.copyWith(keepScreenOn: v)),
          ),
          DropdownButtonFormField<String>(
            value: s.fontFamily,
            decoration: const InputDecoration(labelText: 'Шрыфт'),
            items: const ['System', 'Kurale', 'OldStandardTT', 'YesevaOne', 'Comfortaa', 'Pacifico']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => save(s.copyWith(fontFamily: v ?? 'System')),
          ),
          const SizedBox(height: 12),
          ListTile(
            title: const Text('Памер шрыфту'),
            subtitle: Slider(
              value: s.fontSizeMultiplier,
              min: 0.8,
              max: 1.6,
              onChanged: (v) => save(s.copyWith(fontSizeMultiplier: v)),
            ),
          ),
          SegmentedButton<ItemListViewMode>(
            segments: const [
              ButtonSegment(value: ItemListViewMode.card, label: Text('Карткі')),
              ButtonSegment(value: ItemListViewMode.compact, label: Text('Кампактна')),
            ],
            selected: {s.viewMode},
            onSelectionChanged: (v) => save(s.copyWith(viewMode: v.first)),
          ),
          const SizedBox(height: 20),
          Text('Папярэдні прагляд', style: Theme.of(context).textTheme.titleMedium),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Гэта прыклад тэксту для праверкі стылю чытання.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16 * s.fontSizeMultiplier),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
