import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/settings_provider.dart';
import '../generated/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(s.settings),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return ListView(
            children: [
              // Секция Внешний вид
              _buildSectionHeader(s.theme),
              _buildThemeSelector(context, settingsProvider, s),
              _buildLanguageSelector(context, settingsProvider, s),
              
              const Divider(),
              
              // Секция Чтение
              _buildSectionHeader('Чтение'),
              _buildSliderTile(
                context,
                title: s.fontSize,
                value: settingsProvider.fontSize,
                min: 12.0,
                max: 24.0,
                divisions: 12,
                onChanged: (value) => settingsProvider.setFontSize(value),
                suffix: 'px',
              ),
              _buildSliderTile(
                context,
                title: s.brightness,
                value: settingsProvider.brightness,
                min: 0.3,
                max: 1.0,
                divisions: 7,
                onChanged: (value) => settingsProvider.setBrightness(value),
                suffix: '%',
                valueFormatter: (value) => '${(value * 100).round()}%',
              ),
              _buildSwitchTile(
                title: 'Не выключать экран',
                subtitle: 'Экран не будет гаснуть во время чтения',
                value: settingsProvider.keepScreenOn,
                onChanged: (value) => settingsProvider.setKeepScreenOn(value),
              ),
              
              const Divider(),
              
              // Секция О программе
              _buildSectionHeader(s.about),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.red[400]!, Colors.red[600]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'PDF Reader Pro',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Version 1.0.0',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const Text(
                                'by HruhruStudio',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              ListTile(
                leading: Icon(Icons.language, color: Theme.of(context).primaryColor),
                title: const Text('Website'),
                subtitle: const Text('hruhrustudio.site'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => _launchWebsite(context),
              ),
              ListTile(
                leading: Icon(Icons.code, color: Theme.of(context).primaryColor),
                title: const Text('GitHub'),
                subtitle: const Text('github.com/krutoychel24/pdf-book-reader'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => _launchGitHub(context),
              ),
              ListTile(
                leading: Icon(Icons.person, color: Theme.of(context).primaryColor),
                title: const Text('Developer'),
                subtitle: const Text('HruhruStudio'),
                trailing: const Icon(Icons.chevron_right),
              ),
              ListTile(
                leading: const Icon(Icons.star, color: Colors.orange),
                title: const Text('Rate App'),
                subtitle: const Text('Help us improve'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thank you for your support!')),
                  );
                },
              ),
              
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, SettingsProvider provider, S s) {
    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: Text(s.theme),
      subtitle: Text(_getThemeName(provider.themeMode, s)),
      onTap: () => _showThemeDialog(context, provider, s),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, SettingsProvider provider, S s) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(s.language),
      subtitle: Text(SettingsProvider.languageNames[provider.locale?.languageCode] ?? 'English'),
      onTap: () => _showLanguageDialog(context, provider),
    );
  }

  Widget _buildSliderTile(
    BuildContext context, {
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required Function(double) onChanged,
    String? suffix,
    String Function(double)? valueFormatter,
  }) {
    final clampedValue = value.clamp(min, max);
    
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(valueFormatter?.call(clampedValue) ?? '${clampedValue.toStringAsFixed(1)}${suffix ?? ''}'),
          Slider(
            value: clampedValue,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      value: value,
      onChanged: onChanged,
    );
  }

  String _getThemeName(ThemeMode themeMode, S s) {
    switch (themeMode) {
      case ThemeMode.system:
        return s.systemTheme;
      case ThemeMode.light:
        return s.lightTheme;
      case ThemeMode.dark:
        return s.darkTheme;
    }
  }

  void _showThemeDialog(BuildContext context, SettingsProvider provider, S s) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((themeMode) {
            return RadioListTile<ThemeMode>(
              title: Text(_getThemeName(themeMode, s)),
              value: themeMode,
              groupValue: provider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  provider.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(s.cancel),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Language / Язык'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: SettingsProvider.supportedLocales.map((locale) {
            final isSelected = provider.locale?.languageCode == locale.languageCode;
            return ListTile(
              title: Text(SettingsProvider.languageNames[locale.languageCode] ?? locale.languageCode),
              trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
              onTap: () {
                provider.setLocale(locale);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _launchWebsite(BuildContext context) async {
    const url = 'https://hruhrustudio.site';
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open website')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error opening website')),
      );
    }
  }

  void _launchGitHub(BuildContext context) async {
    const url = 'https://github.com/krutoychel24/pdf-book-reader';
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open GitHub')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error opening GitHub')),
      );
    }
  }
}