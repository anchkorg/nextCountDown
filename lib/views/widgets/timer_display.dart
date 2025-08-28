import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextcountdown/models/timer_model.dart';
import 'package:nextcountdown/viewmodels/timer_viewmodel.dart';
import 'package:nextcountdown/views/widgets/responsive_layout.dart';
import 'package:nextcountdown/themes/app_theme.dart';

class TimerDisplay extends ConsumerWidget {
  const TimerDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerViewModelProvider);

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: EdgeInsets.all(context.isMobile ? 24 : 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTimerText(context, timerState),
            const SizedBox(height: 16),
            _buildProgressIndicator(context, timerState),
            const SizedBox(height: 8),
            _buildStatusText(context, timerState),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerText(BuildContext context, TimerModel timer) {
    final parts = timer.displayTime.split(':');
    final minutes = parts[0];
    final seconds = parts[1];

    final textStyle = TextStyle(
      fontSize: context.isMobile
          ? 72
          : context.isTablet
          ? 96
          : 120,
      fontWeight: FontWeight.bold,
      color: _getTimerColor(timer),
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(minutes, style: textStyle),
        Text(
          ':',
          style: textStyle.copyWith(
            color: timer.status == TimerStatus.running
                ? AppColors.timerActive.withValues(
                    alpha: 0.6,
                  ) //withOpacity(0.6)
                : AppColors.timerDisplay.withValues(
                    alpha: 0.6,
                  ), //withOpacity(0.6),
          ),
        ),
        Text(seconds, style: textStyle),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context, TimerModel timer) {
    return Container(
      width: context.isMobile ? 200 : 300,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey.shade300,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: (context.isMobile ? 200 : 300) * (1 - timer.progress),
        height: 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: _getProgressColor(timer),
        ),
        alignment: Alignment.centerLeft,
        child: Container(
          width: (context.isMobile ? 200 : 300) * (1 - timer.progress),
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _getProgressColor(timer),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusText(BuildContext context, TimerModel timer) {
    String statusText;
    switch (timer.status) {
      case TimerStatus.initial:
        statusText = '準備開始';
        break;
      case TimerStatus.running:
        statusText = '進行中...';
        break;
      case TimerStatus.paused:
        statusText = '已暫停';
        break;
      case TimerStatus.completed:
        statusText = '時間到！';
        break;
    }

    return Text(
      statusText,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: _getTimerColor(timer).withValues(alpha: 0.8), //withOpacity(0.8),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Color _getTimerColor(TimerModel timer) {
    switch (timer.status) {
      case TimerStatus.running:
        return timer.remainingTimeInSeconds <= 10
            ? AppColors.timerWarning
            : AppColors.timerActive;
      case TimerStatus.completed:
        return AppColors.error;
      default:
        return AppColors.timerDisplay;
    }
  }

  Color _getProgressColor(TimerModel timer) {
    switch (timer.status) {
      case TimerStatus.running:
        return timer.remainingTimeInSeconds <= 10
            ? AppColors.timerWarning
            : AppColors.timerActive;
      case TimerStatus.completed:
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }
}
