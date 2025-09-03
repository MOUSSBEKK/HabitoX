import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/theme_service.dart';
import '../../widgets/theme_toggle_widget.dart';
import '../../constants/app_colors.dart';

class AppAppearanceScreen extends StatelessWidget {
  const AppAppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance'),
        actions: [const QuickThemeToggle(), const SizedBox(width: 8)],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildThemeSection(context),
              const SizedBox(height: 24),
              _buildPreviewSection(context),
              const SizedBox(height: 24),
              _buildQuickActionsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme Mode',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                ...themeService.availableThemeModes.map((option) {
                  final isSelected = themeService.themeMode == option.mode;
                  return ListTile(
                    leading: Icon(
                      option.icon,
                      color: isSelected
                          ? AppColors.accentPrimary
                          : Theme.of(context).iconTheme.color,
                    ),
                    title: Text(
                      option.name,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.accentPrimary
                            : Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      option.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: AppColors.accentPrimary,
                          )
                        : null,
                    onTap: () => themeService.setThemeMode(option.mode),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tileColor: isSelected
                        ? AppColors.accentPrimary.withOpacity(0.1)
                        : null,
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPreviewSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Preview',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPreviewCard(
                    context,
                    'Light Theme',
                    Icons.light_mode,
                    AppColors.lightBackgroundPrimary,
                    AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPreviewCard(
                    context,
                    'Dark Theme',
                    Icons.dark_mode,
                    AppColors.darkBackgroundPrimary,
                    AppColors.darkTextPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard(
    BuildContext context,
    String title,
    IconData icon,
    Color backgroundColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: textColor, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    context,
                    'Cycle Theme',
                    Icons.refresh,
                    () => _showThemeSelectionDialog(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionButton(
                    context,
                    'Animated Toggle',
                    Icons.animation,
                    () => _showAnimatedToggle(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor, width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.accentPrimary, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ThemeSelectionDialog(),
    );
  }

  void _showAnimatedToggle(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Animated Theme Toggle'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedThemeToggle(showLabel: true),
            SizedBox(height: 16),
            Text('Tap the toggle to see the animation!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
