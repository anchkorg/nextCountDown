import 'package:equatable/equatable.dart';

class TimerSettingsModel extends Equatable {
  final int defaultMinutes;
  final int defaultHandoverTime;
  final bool soundEnabled;
  final bool voiceEnabled;
  final double volume;

  const TimerSettingsModel({
    required this.defaultMinutes,
    required this.defaultHandoverTime,
    required this.soundEnabled,
    required this.voiceEnabled,
    required this.volume,
  });

  factory TimerSettingsModel.defaultSettings() {
    return const TimerSettingsModel(
      defaultMinutes: 1,
      defaultHandoverTime: 3,
      soundEnabled: true,
      voiceEnabled: true,
      volume: 1.0,
    );
  }

  TimerSettingsModel copyWith({
    int? defaultMinutes,
    int? defaultHandoverTime,
    bool? soundEnabled,
    bool? voiceEnabled,
    double? volume,
  }) {
    return TimerSettingsModel(
      defaultMinutes: defaultMinutes ?? this.defaultMinutes,
      defaultHandoverTime: defaultHandoverTime ?? this.defaultHandoverTime,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      voiceEnabled: voiceEnabled ?? this.voiceEnabled,
      volume: volume ?? this.volume,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'defaultMinutes': defaultMinutes,
      'soundEnabled': soundEnabled,
      'voiceEnabled': voiceEnabled,
      'volume': volume,
    };
  }

  factory TimerSettingsModel.fromJson(Map<String, dynamic> json) {
    return TimerSettingsModel(
      defaultMinutes: json['defaultMinutes'] ?? 1,
      defaultHandoverTime: json['defaultHandoverTime'] ?? 3,
      soundEnabled: json['soundEnabled'] ?? true,
      voiceEnabled: json['voiceEnabled'] ?? true,
      volume: json['volume'] ?? 1.0,
    );
  }

  @override
  List<Object> get props => [
    defaultMinutes,
    soundEnabled,
    voiceEnabled,
    volume,
  ];
}
