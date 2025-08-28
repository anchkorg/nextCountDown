import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcountdown/viewmodels/settings_viewmodel.dart';
import 'package:nextcountdown/views/widgets/responsive_layout.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late TextEditingController _minutesController;

  @override
  void initState() {
    super.initState();
    _minutesController = TextEditingController();
  }

  @override
  void dispose() {
    _minutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsViewModelProvider);

    // Update controller when settings change
    if (_minutesController.text != settings.defaultMinutes.toString()) {
      _minutesController.text = settings.defaultMinutes.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(context, settings),
        tablet: _buildTabletLayout(context, settings),
        desktop: _buildDesktopLayout(context, settings),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _buildSettingsContent(context, settings),
    );
  }

  Widget _buildTabletLayout(BuildContext context, settings) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(24),
        child: _buildSettingsContent(context, settings),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, settings) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(32),
        child: _buildSettingsContent(context, settings),
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context, settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('計時器設定', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),

                // Default Minutes Setting
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _minutesController,
                        decoration: const InputDecoration(
                          labelText: '預設倒數時間 (分鐘)',
                          helperText: '請輸入 1-60 分鐘',
                        ),
                        keyboardType: TextInputType.number,
                        onSubmitted: (value) {
                          final minutes = int.tryParse(value);
                          if (minutes != null &&
                              minutes >= 1 &&
                              minutes <= 60) {
                            ref
                                .read(settingsViewModelProvider.notifier)
                                .updateDefaultMinutes(minutes);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        final minutes = int.tryParse(_minutesController.text);
                        if (minutes != null && minutes >= 1 && minutes <= 60) {
                          ref
                              .read(settingsViewModelProvider.notifier)
                              .updateDefaultMinutes(minutes);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('設定已保存')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('請輸入有效的分鐘數 (1-60)')),
                          );
                        }
                      },
                      child: const Text('保存'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('音頻設定', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),

                // Sound Enable Switch
                SwitchListTile(
                  title: const Text('聲音提醒'),
                  subtitle: const Text('時間結束時播放提醒音'),
                  value: settings.soundEnabled,
                  onChanged: (value) {
                    ref
                        .read(settingsViewModelProvider.notifier)
                        .updateSoundEnabled(value);
                  },
                ),

                // Voice Enable Switch
                SwitchListTile(
                  title: const Text('語音提醒'),
                  subtitle: const Text('倒數時語音播報'),
                  value: settings.voiceEnabled,
                  onChanged: (value) {
                    ref
                        .read(settingsViewModelProvider.notifier)
                        .updateVoiceEnabled(value);
                  },
                ),

                // Volume Slider
                const Text('音量'),
                Slider(
                  value: settings.volume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: '\${(settings.volume * 100).round()}%',
                  onChanged: (value) {
                    ref
                        .read(settingsViewModelProvider.notifier)
                        .updateVolume(value);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
