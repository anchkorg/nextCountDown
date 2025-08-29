//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nextcountdown/viewmodels/settings_viewmodel.dart';

part 'audio_service.g.dart';

@riverpod
AudioService audioService(Ref ref) {
  return AudioService(ref);
}

class AudioService {
  final Ref ref;
  late FlutterTts _flutterTts;
  late AudioPlayer _audioPlayer;

  AudioService(this.ref) {
    _initializeTts();
    _initializeAudioPlayer();
  }

  void _initializeTts() {
    _flutterTts = FlutterTts();
    _configureTts();
  }

  void _initializeAudioPlayer() {
    _audioPlayer = AudioPlayer();
  }

  Future<void> _configureTts() async {
    // Configure for Cantonese if available
    //await _flutterTts.setLanguage('zh-HK');
    await _flutterTts.setLanguage('zh-CN');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.9);

    // Fallback to Mandarin Chinese if Cantonese not available
    final languages = await _flutterTts.getLanguages;
    if (languages != null && !languages.contains('zh-HK')) {
      await _flutterTts.setLanguage('zh-CN');
    }
  }

  Future<void> speak(String text) async {
    try {
      final settings = ref.read(settingsViewModelProvider);
      if (!settings.voiceEnabled) return;

      await _flutterTts.setVolume(settings.volume);
      await _flutterTts.speak(text);
    } catch (e) {
      // Handle TTS errors gracefully
      debugPrint('TTS Error: \$e');
    }
  }

  Future<void> playAlert() async {
    try {
      final settings = ref.read(settingsViewModelProvider);
      if (!settings.soundEnabled) return;

      // Generate a simple beep sound programmatically
      // In a real app, you'd load an audio file from assets
      await _audioPlayer.setVolume(settings.volume);

      // For web, we'll use a simple tone
      // This is a placeholder - in production, use actual audio files
      _playSystemAlert();
    } catch (e) {
      // Handle audio errors gracefully
      debugPrint('Audio Error: \$e');
    }
  }

  void _playSystemAlert() {
    // For web compatibility, use the system beep
    // In a real implementation, you'd load an audio file
    debugPrint('BEEP!'); // Placeholder
  }

  void dispose() {
    _flutterTts.stop();
    _audioPlayer.dispose();
  }
}
