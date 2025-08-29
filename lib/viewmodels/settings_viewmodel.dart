//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nextcountdown/models/timer_settings_model.dart';
import 'package:nextcountdown/services/storage_service.dart';

part 'settings_viewmodel.g.dart';

@riverpod
class SettingsViewModel extends _$SettingsViewModel {
  @override
  TimerSettingsModel build() {
    _loadSettings();
    return TimerSettingsModel.defaultSettings();
  }

  Future<void> _loadSettings() async {
    final storageService = ref.read(storageServiceProvider);
    final settings = await storageService.getSettings();
    state = settings;
  }

  Future<void> updateDefaultMinutes(int minutes) async {
    if (minutes < 1 || minutes > 60) return;

    final newSettings = state.copyWith(defaultMinutes: minutes);
    state = newSettings;

    final storageService = ref.read(storageServiceProvider);
    await storageService.saveSettings(newSettings);
  }

  Future<void> updateDefaultHandoverTime(int seconds) async {
    final newSettings = state.copyWith(defaultHandoverTime: seconds);
    state = newSettings;

    final storageService = ref.read(storageServiceProvider);
    await storageService.saveSettings(newSettings);
  }

  Future<void> updateSoundEnabled(bool enabled) async {
    final newSettings = state.copyWith(soundEnabled: enabled);
    state = newSettings;

    final storageService = ref.read(storageServiceProvider);
    await storageService.saveSettings(newSettings);
  }

  Future<void> updateVoiceEnabled(bool enabled) async {
    final newSettings = state.copyWith(voiceEnabled: enabled);
    state = newSettings;

    final storageService = ref.read(storageServiceProvider);
    await storageService.saveSettings(newSettings);
  }

  Future<void> updateVolume(double volume) async {
    if (volume < 0.0 || volume > 1.0) return;

    final newSettings = state.copyWith(volume: volume);
    state = newSettings;

    final storageService = ref.read(storageServiceProvider);
    await storageService.saveSettings(newSettings);
  }
}
