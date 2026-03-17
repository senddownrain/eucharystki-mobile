import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/app_settings.dart';
import '../data/settings_storage_service.dart';

final settingsStorageProvider = Provider((ref) => SettingsStorageService());

final settingsControllerProvider = StateNotifierProvider<SettingsController, AppSettings>((ref) {
  final storage = ref.watch(settingsStorageProvider);
  return SettingsController(storage)..load();
});

class SettingsController extends StateNotifier<AppSettings> {
  final SettingsStorageService storage;

  SettingsController(this.storage) : super(AppSettings.defaults());

  void load() => state = storage.load();

  Future<void> update(AppSettings settings) async {
    state = settings;
    await storage.save(settings);
  }

  Future<void> togglePin(String itemId) async {
    final ids = [...state.pinnedIds];
    ids.contains(itemId) ? ids.remove(itemId) : ids.add(itemId);
    await update(state.copyWith(pinnedIds: ids));
  }
}
