import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Settings {
  final double fontSize;
  final int fontColorValue;
  final int bgColorValue;

  const Settings({
    required this.fontSize,
    required this.fontColorValue,
    required this.bgColorValue,
  });

  Settings copyWith({double? fontSize, int? fontColorValue, int? bgColorValue}) {
    return Settings(
      fontSize: fontSize ?? this.fontSize,
      fontColorValue: fontColorValue ?? this.fontColorValue,
      bgColorValue: bgColorValue ?? this.bgColorValue,
    );
  }
}

class SettingsNotifier extends StateNotifier<Settings> {
  final Box box = Hive.box('settings');

  SettingsNotifier()
      : super(const Settings(
          fontSize: 16.0,
          fontColorValue: 0xFF000000, // black
          bgColorValue: 0xFFFFFFFF, // white
        )) {
    _load();
  }

  Future<void> _load() async {
    final f = box.get('fontSize', defaultValue: 16.0);
    final fc = box.get('fontColor', defaultValue: 0xFF000000);
    final bg = box.get('bgColor', defaultValue: 0xFFFFFFFF);
    state = state.copyWith(
      fontSize: (f is double) ? f : (f is int ? f.toDouble() : 16.0),
      fontColorValue: fc is int ? fc : 0xFF000000,
      bgColorValue: bg is int ? bg : 0xFFFFFFFF,
    );
  }

  Future<void> setFontSize(double s) async {
    state = state.copyWith(fontSize: s);
    await box.put('fontSize', s);
  }

  Future<void> setFontColor(Color c) async {
    state = state.copyWith(fontColorValue: c.toARGB32());
    await box.put('fontColor', c.toARGB32());
  }

  Future<void> setBgColor(Color c) async {
    state = state.copyWith(bgColorValue: c.toARGB32());
    await box.put('bgColor', c.toARGB32());
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, Settings>((ref) => SettingsNotifier());
