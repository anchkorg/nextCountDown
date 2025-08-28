import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextcountdown/models/timer_model.dart';
import 'package:nextcountdown/viewmodels/timer_viewmodel.dart';
import 'package:nextcountdown/views/widgets/responsive_layout.dart';

class ControlButtons extends ConsumerWidget {
  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerViewModelProvider);
    final timerNotifier = ref.read(timerViewModelProvider.notifier);

    if (timerState.status == TimerStatus.initial ||
        timerState.status == TimerStatus.completed) {
      return _buildStartButton(context, timerNotifier);
    } else {
      return _buildRunningControls(context, timerNotifier);
    }
  }

  Widget _buildStartButton(BuildContext context, TimerViewModel timerNotifier) {
    return SizedBox(
      width: context.isMobile ? double.infinity : 200,
      height: context.isMobile ? 56 : 64,
      child: ElevatedButton.icon(
        onPressed: () => timerNotifier.startTimer(),
        icon: const Icon(Icons.play_arrow, size: 24),
        label: Text(
          '開始',
          style: TextStyle(
            fontSize: context.isMobile ? 18 : 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.isMobile ? 12 : 16),
          ),
        ),
      ),
    );
  }

  Widget _buildRunningControls(
    BuildContext context,
    TimerViewModel timerNotifier,
  ) {
    return Wrap(
      spacing: context.isMobile ? 12 : 16,
      runSpacing: 12,
      children: [
        SizedBox(
          width: context.isMobile ? 140 : 160,
          height: context.isMobile ? 48 : 56,
          child: ElevatedButton.icon(
            onPressed: () => timerNotifier.nextTimer(),
            icon: const Icon(Icons.skip_next, size: 20),
            label: Text(
              '下一個',
              style: TextStyle(
                fontSize: context.isMobile ? 16 : 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.isMobile ? 10 : 12),
              ),
            ),
          ),
        ),
        SizedBox(
          width: context.isMobile ? 140 : 160,
          height: context.isMobile ? 48 : 56,
          child: ElevatedButton.icon(
            onPressed: () => timerNotifier.stopTimer(),
            icon: const Icon(Icons.stop, size: 20),
            label: Text(
              '停止',
              style: TextStyle(
                fontSize: context.isMobile ? 16 : 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.isMobile ? 10 : 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
