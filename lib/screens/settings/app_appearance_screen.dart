import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../services/theme_service.dart';
import '../../constants/app_colors.dart';


class AppAppearanceScreen extends StatefulWidget {
  const AppAppearanceScreen({super.key});

  @override
  State<AppAppearanceScreen> createState() => _AppAppearanceScreenState();
}

class _AppAppearanceScreenState extends State<AppAppearanceScreen> {
  String _selectedTheme = 'system';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final themeService = Provider.of<ThemeService>(context);
    final mode = themeService.themeMode;
    setState(() {
      _selectedTheme = _themeModeToValue(mode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme')),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [const SizedBox(height: 16), _buildThemeSection()],
        ),
      ),
    );
  }

  Widget _buildThemeSection() {
    return _buildSection(
      children: [
        _buildThemeOption('Automatic', 'system', Icons.brightness_auto),
        _buildThemeOption('Light', 'light', Icons.light_mode),
        _buildThemeOption('Dark', 'dark', Icons.dark_mode),
      ],
    );
  }

  Widget _buildSection({required List<Widget> children}) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
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
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOption(String title, String value, IconData icon) {
    final isSelected = _selectedTheme == value;
    final theme = Theme.of(context);
    final selectedColor = AppColors.primaryColor;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withOpacity(0.2)
              : theme.colorScheme.surface.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: FaIcon(
          icon,
          color: isSelected ? selectedColor : theme.iconTheme.color,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: isSelected ? selectedColor : theme.textTheme.bodyLarge?.color,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: selectedColor)
          : null,
      onTap: () {
        setState(() {
          _selectedTheme = value;
        });
        final themeService = Provider.of<ThemeService>(context, listen: false);
        themeService.setThemeMode(_valueToThemeMode(value));
      },
    );
  }

  static String _themeModeToValue(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  static ThemeMode _valueToThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
    }
    return ThemeMode.system;
  }
}
