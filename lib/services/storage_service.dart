import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nextcountdown/models/timer_settings_model.dart';
import 'dart:convert';

part 'storage_service.g.dart';

@riverpod
StorageService storageService(Ref ref) {
  return StorageService(ref);
}

class StorageService {
  StorageService(this.ref);
  final Ref ref;
  static const String _settingsKey = 'timer_settings';

  Future<TimerSettingsModel> getSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);

      if (settingsJson != null) {
        final Map<String, dynamic> json = jsonDecode(settingsJson);
        return TimerSettingsModel.fromJson(json);
      }
    } catch (e) {
      debugPrint('Error loading settings: \$e');
    }

    return TimerSettingsModel.defaultSettings();
  }

  Future<void> saveSettings(TimerSettingsModel settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = jsonEncode(settings.toJson());
      await prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      debugPrint('Error saving settings: \$e');
    }
  }

  Future<void> clearSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_settingsKey);
    } catch (e) {
      debugPrint('Error clearing settings: \$e');
    }
  }
}
