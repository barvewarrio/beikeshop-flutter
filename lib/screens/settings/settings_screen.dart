import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            children: [
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Preferences', style: AppTextStyles.subheading),
              ),
              
              // Language Selection
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                subtitle: Text(settings.languageCode == 'en' ? 'English' : 'Chinese'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showLanguageDialog(context, settings);
                },
              ),
              const Divider(),
              
              // Currency Selection
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Currency'),
                subtitle: Text(settings.currencyCode),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showCurrencyDialog(context, settings);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Language'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              settings.setLanguage('en');
              Navigator.pop(context);
            },
            child: const Text('English'),
          ),
          SimpleDialogOption(
            onPressed: () {
              settings.setLanguage('zh');
              Navigator.pop(context);
            },
            child: const Text('Chinese (简体中文)'),
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Currency'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              settings.setCurrency('USD');
              Navigator.pop(context);
            },
            child: const Text('USD (\$)'),
          ),
          SimpleDialogOption(
            onPressed: () {
              settings.setCurrency('CNY');
              Navigator.pop(context);
            },
            child: const Text('CNY (¥)'),
          ),
          SimpleDialogOption(
            onPressed: () {
              settings.setCurrency('EUR');
              Navigator.pop(context);
            },
            child: const Text('EUR (€)'),
          ),
        ],
      ),
    );
  }
}
