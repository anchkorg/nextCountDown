import 'dart:async';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nextcountdown/models/timer_model.dart';
import 'package:nextcountdown/services/audio_service.dart';
import 'package:nextcountdown/viewmodels/settings_viewmodel.dart';

part 'timer_viewmodel.g.dart';

@riverpod
class TimerViewModel extends _$TimerViewModel {
  Timer? _timer;

  @override
  TimerModel build() {
    ref.onDispose(() {
      _timer?.cancel();
    });

    final settings = ref.watch(settingsViewModelProvider);
    return TimerModel.initial(
      minutes: settings.defaultMinutes,
      handoverTime: settings.defaultHandoverTime,
    );
  }

  void startTimer() {
    if (state.status == TimerStatus.running) return;
    final audioService = ref.read(audioServiceProvider);
    final settings = ref.read(settingsViewModelProvider);
    if (settings.soundEnabled) {
      audioService.playAlert();
    }
    audioService.speak('開始');
    state = state.copyWith(status: TimerStatus.running);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (state.remainingTimeInSeconds > 0) {
        final newRemainingTime = state.remainingTimeInSeconds - 1;
        int newHandoverTime = state.handoverTime;
        // Handle voice announcements
        _handleVoiceAnnouncements(newRemainingTime);

        state = state.copyWith(remainingTimeInSeconds: newRemainingTime);

        if (newRemainingTime == 0) {
          _handleTimerComplete();

          stopTimer();
          await Future.delayed(Duration(seconds: newHandoverTime));
          // 3 秒後繼續執行這裡的程式碼
          handleTimerStart();

          startTimer();
        }
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }

  void stopTimer() {
    _timer?.cancel();
    state = state.copyWith(
      remainingTimeInSeconds: state.totalTimeInSeconds,
      status: TimerStatus.initial,
    );
  }

  void nextTimer() {
    _timer?.cancel();
    final settings = ref.read(settingsViewModelProvider);
    state = TimerModel.initial(minutes: settings.defaultMinutes);
    handleTimerStart();
    startTimer();
  }

  void setTotalTime(int minutes) {
    if (state.status == TimerStatus.running) return;

    final totalSeconds = minutes * 60;
    state = state.copyWith(
      totalTimeInSeconds: totalSeconds,
      remainingTimeInSeconds: totalSeconds,
      status: TimerStatus.initial,
    );
  }

  void _handleVoiceAnnouncements(int remainingSeconds) {
    final audioService = ref.read(audioServiceProvider);
    final settings = ref.read(settingsViewModelProvider);

    if (!settings.voiceEnabled) return;

    switch (remainingSeconds) {
      case 20:
        audioService.speak('二十秒');
        break;
      case 10:
        audioService.speak('十秒');
        break;
      case 5:
        audioService.speak('五');
        break;
      case 4:
        audioService.speak('四');
        break;
      case 3:
        audioService.speak('三');
        break;
      case 2:
        audioService.speak('二');
        break;
      case 1:
        audioService.speak('一');
        break;
    }
  }

  void handleTimerStart() {
    final audioService = ref.read(audioServiceProvider);
    final settings = ref.read(settingsViewModelProvider);
    if (settings.soundEnabled) {
      audioService.playAlert();
    }
    audioService.speak('開始');
  }

  void _handleTimerComplete() {
    _timer?.cancel();
    state = state.copyWith(status: TimerStatus.completed);

    final audioService = ref.read(audioServiceProvider);
    final settings = ref.read(settingsViewModelProvider);
    audioService.speak('時間到，下一個');

    if (settings.soundEnabled) {
      audioService.playAlert();
    }
  }
}
