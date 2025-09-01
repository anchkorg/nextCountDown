import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
//import 'package:nextcountdown/models/timer_model.dart';
//import 'package:nextcountdown/viewmodels/timer_viewmodel.dart';
import 'package:nextcountdown/views/widgets/timer_display.dart';
import 'package:nextcountdown/views/widgets/control_buttons.dart';
import 'package:nextcountdown/views/widgets/responsive_layout.dart';
import 'package:nextcountdown/themes/app_theme.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/generated_image.png'),
            /**            NetworkImage(
              'https://user-gen-media-assets.s3.amazonaws.com/gpt4o_images/add6bf84-a961-40c7-859b-f0f19d750fda.png',
            ), */
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: ResponsiveLayout(
            mobile: _buildMobileLayout(context, ref),
            tablet: _buildTabletLayout(context, ref),
            desktop: _buildDesktopLayout(context, ref),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildAppBar(context, ref, compact: true),
          const Expanded(flex: 2, child: Center(child: TimerDisplay())),
          const Expanded(flex: 1, child: Center(child: ControlButtons())),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _buildAppBar(context, ref),
          const SizedBox(height: 32),
          const Expanded(flex: 3, child: Center(child: TimerDisplay())),
          const SizedBox(height: 24),
          const Expanded(flex: 1, child: Center(child: ControlButtons())),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          _buildAppBar(context, ref),
          const SizedBox(height: 48),
          const Expanded(flex: 4, child: Center(child: TimerDisplay())),
          const SizedBox(height: 32),
          const Expanded(flex: 1, child: Center(child: ControlButtons())),
        ],
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    WidgetRef ref, {
    bool compact = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            color: (Theme.of(context).brightness == Brightness.dark)
                ? AppColors.timerDisplayDark.withValues(alpha: 0.6)
                : AppColors.timerDisplayLight.withValues(alpha: 0.6),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '倒數計時器',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: (Theme.of(context).brightness == Brightness.dark)
                    ? AppColors.timerDisplayDark
                    : AppColors.timerDisplayLight,
              ),
            ),
          ),
        ),
        IconButton.filled(
          onPressed: () => context.push('/settings'),
          icon: const Icon(Icons.settings),
          tooltip: '設定',
        ),
      ],
    );
  }
}
