import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../services/language_service.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = context.watch<LanguageService>();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final items = <_LanguageItem>[
      _LanguageItem(code: 'system', label: l10n!.language_system),
      _LanguageItem(code: 'fr', label: l10n.language_french),
      _LanguageItem(code: 'en', label: l10n.language_english),
      _LanguageItem(code: 'de', label: l10n.language_german),
      _LanguageItem(code: 'es', label: l10n.language_spanish),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.language_title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  _LanguageTile(
                    item: items[i],
                    selectedCode: languageService.selectedLocaleCode,
                    onSelected: (code) {
                      context.read<LanguageService>().setLanguage(code);
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageItem {
  final String code;
  final String label;
  _LanguageItem({required this.code, required this.label});
}

class _LanguageTile extends StatelessWidget {
  final _LanguageItem item;
  final String selectedCode;
  final ValueChanged<String> onSelected;

  const _LanguageTile({
    required this.item,
    required this.selectedCode,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = selectedCode == item.code;
    final selectedColor = Theme.of(context).colorScheme.secondary;
    return ListTile(
      title: Text(
        item.label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: isSelected ? selectedColor : theme.textTheme.bodyLarge?.color,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: selectedColor)
          : null,
      onTap: () => onSelected(item.code),
    );
  }
}
