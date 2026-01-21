import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eyadflix/presentation/providers/app_providers.dart';
import 'package:eyadflix/services/localization_service.dart';
import 'package:eyadflix/core/constants/app_constants.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final language = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('settingsScreen.title'.tr()),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Language Settings
          ListTile(
            title: Text('settingsScreen.language'.tr()),
            trailing: DropdownButton<String>(
              value: language,
              items: const [
                DropdownMenuItem(
                  value: 'en',
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: 'ar',
                  child: Text('العربية'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(languageProvider.notifier).setLanguage(value);
                  LocalizationService.changeLanguage(context, value);
                }
              },
            ),
          ),
          const Divider(),
          // Theme Settings
          ListTile(
            title: Text('settingsScreen.theme'.tr()),
            trailing: DropdownButton<String>(
              value: themeMode,
              items: [
                DropdownMenuItem(
                  value: 'system',
                  child: Text('settingsScreen.system'.tr()),
                ),
                DropdownMenuItem(
                  value: 'light',
                  child: Text('settingsScreen.lightMode'.tr()),
                ),
                DropdownMenuItem(
                  value: 'dark',
                  child: Text('settingsScreen.darkMode'.tr()),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                }
              },
            ),
          ),
          const Divider(),
          // About Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'settingsScreen.about'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  '${AppConstants.appName} v${AppConstants.appVersion}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'settingsScreen.description'.tr(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                Text(
                  '${AppConstants.developerName}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
