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
    
    final currencies = [
      {'code': 'USD', 'name': 'USD (\$)'},
      {'code': 'CNY', 'name': 'CNY (¥)'},
      {'code': 'EUR', 'name': 'EUR (€)'},
      {'code': 'VND', 'name': 'VND (₫)'},
      {'code': 'CAD', 'name': 'CAD (CA\$)'},
      {'code': 'NGN', 'name': 'NGN (₦)'},
      {'code': 'KES', 'name': 'KES (KSh)'},
      {'code': 'THB', 'name': 'THB (฿)'},
      {'code': 'MYR', 'name': 'MYR (RM)'},
      {'code': 'PHP', 'name': 'PHP (₱)'},
      {'code': 'IDR', 'name': 'IDR (Rp)'},
      {'code': 'SGD', 'name': 'SGD (S\$)'},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectCurrency),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: currencies.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final currency = currencies[index];
              final isSelected = settings.currencyCode == currency['code'];
              
              return ListTile(
                title: Text(
                  currency['name']!,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
                trailing: isSelected 
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  settings.setCurrency(currency['code']!);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
