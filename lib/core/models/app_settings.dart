import 'package:flutter/material.dart';

enum ItemListViewMode { card, compact }

class AppSettings {
  final ThemeMode themeMode;
  final bool keepScreenOn;
  final String fontFamily;
  final double fontSizeMultiplier;
  final ItemListViewMode viewMode;
  final List<String> pinnedIds;

  const AppSettings({
    required this.themeMode,
    required this.keepScreenOn,
    required this.fontFamily,
    required this.fontSizeMultiplier,
    required this.viewMode,
    required this.pinnedIds,
  });

  factory AppSettings.defaults() => const AppSettings(
        themeMode: ThemeMode.system,
        keepScreenOn: false,
        fontFamily: 'System',
        fontSizeMultiplier: 1,
        viewMode: ItemListViewMode.card,
        pinnedIds: [],
      );

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? keepScreenOn,
    String? fontFamily,
    double? fontSizeMultiplier,
    ItemListViewMode? viewMode,
    List<String>? pinnedIds,
  }) =>
      AppSettings(
        themeMode: themeMode ?? this.themeMode,
        keepScreenOn: keepScreenOn ?? this.keepScreenOn,
        fontFamily: fontFamily ?? this.fontFamily,
        fontSizeMultiplier: fontSizeMultiplier ?? this.fontSizeMultiplier,
        viewMode: viewMode ?? this.viewMode,
        pinnedIds: pinnedIds ?? this.pinnedIds,
      );
}
