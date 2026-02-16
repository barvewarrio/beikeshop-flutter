import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beikeshop_flutter/l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            children: [
              const SizedBox(height: 16),
              // 偏好设置
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(l10n.settings, style: AppTextStyles.subheading),
              ),

              // 语言选择
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(l10n.language),
                subtitle: Text(
                  settings.languageCode == 'en' ? 'English' : '简体中文',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showLanguageDialog(context, settings);
                },
              ),
              const Divider(),

              // 货币选择
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: Text(l10n.currency),
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
    final l10n = AppLocalizations.of(context)!;
    // 语言选择弹窗
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.selectLanguage),
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
            child: const Text('简体中文'),
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, SettingsProvider settings) {
    final l10n = AppLocalizations.of(context)!;
    // 货币选择弹窗
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.selectCurrency),
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
