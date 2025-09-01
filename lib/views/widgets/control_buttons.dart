import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextcountdown/Shared/app_constants.dart';
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
      height: context.isMobile ? 72 : 84,
      child: ElevatedButton.icon(
        onPressed: () {
          timerNotifier.handleTimerStart();
          timerNotifier.startTimer();
        },
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
        ControlButtonWidget(
          label: '下一個',
          onTap: () => timerNotifier.nextTimer(),
          buttonStyle: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        ControlButtonWidget(
          label: '停止',
          onTap: () => timerNotifier.stopTimer(),
          buttonStyle: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.isMobile ? 8 : 12),
            ),
          ),
        ),
      ],
    );
  }
}

class ControlButtonWidget extends StatelessWidget {
  const ControlButtonWidget({
    super.key,
    required this.label,
    required this.onTap,
    required this.buttonStyle,
  });
  final String label;
  final VoidCallback onTap;
  final ButtonStyle buttonStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.isMobile
          ? AppConstants.mobileControlButtonWidth
          : AppConstants.desktopControlButtonWidth,
      height: context.isMobile
          ? AppConstants.mobileButtonHeight
          : AppConstants.desktopButtonHeight,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.skip_next, size: 20),
        label: Text(
          label,
          style: TextStyle(
            fontSize: context.isMobile
                ? AppConstants.mobileControlButtonFontSize
                : AppConstants.desktopControlButtonFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: buttonStyle,
      ),
    );
  }
}
