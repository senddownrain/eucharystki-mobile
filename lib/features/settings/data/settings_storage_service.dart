import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../core/constants/hive_boxes.dart';
import '../../../core/models/app_settings.dart';

class SettingsStorageService {
  Box get _box => Hive.box(HiveBoxes.settings);

  AppSettings load() {
    final mode = ThemeMode.values[_box.get('themeMode', defaultValue: 0) as int];
    final viewMode = ItemListViewMode
        .values[_box.get('viewMode', defaultValue: ItemListViewMode.card.index) as int];
    return AppSettings(
      themeMode: mode,
      keepScreenOn: _box.get('keepScreenOn', defaultValue: false) as bool,
      fontFamily: _box.get('fontFamily', defaultValue: 'System') as String,
      fontSizeMultiplier: (_box.get('fontSizeMultiplier', defaultValue: 1.0) as num).toDouble(),
      viewMode: viewMode,
      pinnedIds: (_box.get('pinnedIds', defaultValue: <String>[]) as List).cast<String>(),
    );
  }

  Future<void> save(AppSettings settings) async {
    await Future.wait([
      _box.put('themeMode', settings.themeMode.index),
      _box.put('keepScreenOn', settings.keepScreenOn),
      _box.put('fontFamily', settings.fontFamily),
      _box.put('fontSizeMultiplier', settings.fontSizeMultiplier),
      _box.put('viewMode', settings.viewMode.index),
      _box.put('pinnedIds', settings.pinnedIds),
    ]);
  }
}
