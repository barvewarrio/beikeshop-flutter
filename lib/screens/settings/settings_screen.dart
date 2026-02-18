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
      backgroundColor: const Color(0xFFF7F7F7),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                title: Text(
                  l10n.settings,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: const IconThemeData(color: AppColors.textPrimary),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1.0),
                  child: Container(
                    color: Colors.grey[200],
                    height: 1.0,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(l10n.settings), // Reusing "Settings" as "Preferences" title if needed, or just "General"
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildSettingsTile(
                              icon: Icons.language,
                              title: l10n.language,
                              value: settings.languageCode == 'en' ? 'English' : '简体中文',
                              onTap: () => _showLanguageDialog(context, settings),
                              isFirst: true,
                            ),
                            const Divider(height: 1, indent: 56),
                            _buildSettingsTile(
                              icon: Icons.attach_money,
                              title: l10n.currency,
                              value: settings.currencyCode,
                              onTap: () => _showCurrencyDialog(context, settings),
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                      
                      // Add more sections here if needed (e.g., Notifications, About, etc.)
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(12) : Radius.zero,
          bottom: isLast ? const Radius.circular(12) : Radius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textSecondary, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsProvider settings) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.selectLanguage),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        children: [
          SimpleDialogOption(
            onPressed: () {
              settings.setLanguage('en');
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'English',
                style: TextStyle(
                  color: settings.languageCode == 'en' ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: settings.languageCode == 'en' ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              settings.setLanguage('zh');
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '简体中文',
                style: TextStyle(
                  color: settings.languageCode == 'zh' ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: settings.languageCode == 'zh' ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
