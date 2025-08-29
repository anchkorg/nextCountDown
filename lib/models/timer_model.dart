import 'package:equatable/equatable.dart';

enum TimerStatus { initial, running, paused, completed }

class TimerModel extends Equatable {
  final int totalTimeInSeconds;
  final int remainingTimeInSeconds;
  final int handoverTime;
  final TimerStatus status;

  const TimerModel({
    required this.totalTimeInSeconds,
    required this.remainingTimeInSeconds,
    required this.handoverTime,
    required this.status,
  });

  factory TimerModel.initial({int minutes = 1, int handoverTime = 3}) {
    final totalSeconds = minutes * 60;
    return TimerModel(
      totalTimeInSeconds: totalSeconds,
      remainingTimeInSeconds: totalSeconds,
      handoverTime: handoverTime,
      status: TimerStatus.initial,
    );
  }

  TimerModel copyWith({
    int? totalTimeInSeconds,
    int? remainingTimeInSeconds,
    int? handoverTime,
    TimerStatus? status,
  }) {
    return TimerModel(
      totalTimeInSeconds: totalTimeInSeconds ?? this.totalTimeInSeconds,
      remainingTimeInSeconds:
          remainingTimeInSeconds ?? this.remainingTimeInSeconds,
      handoverTime: handoverTime ?? this.handoverTime,
      status: status ?? this.status,
    );
  }

  String get displayTime {
    final minutes = remainingTimeInSeconds ~/ 60;
    final seconds = remainingTimeInSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress => totalTimeInSeconds > 0
      ? (totalTimeInSeconds - remainingTimeInSeconds) / totalTimeInSeconds
      : 0.0;

  bool get isTimeUp => remainingTimeInSeconds <= 0;
  bool get shouldAnnounceTime =>
      remainingTimeInSeconds == 20 ||
      remainingTimeInSeconds == 10 ||
      (remainingTimeInSeconds <= 5 && remainingTimeInSeconds > 0);

  @override
  List<Object> get props => [
    totalTimeInSeconds,
    remainingTimeInSeconds,
    status,
  ];
}
