import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_theme.dart';

/// Theme service to manage app theme state and persistence with three-mode cycling
class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';

  ThemeMode _themeMode = ThemeMode.system;
  bool _isDarkMode = false;
  Brightness? _systemBrightness;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _isDarkMode;
  Brightness? get systemBrightness => _systemBrightness;

  /// Initialize theme service and load saved theme preference
  Future<void> initialize() async {
    await _loadThemePreference();
    _updateSystemBrightness();
  }

  /// Load theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 2; // Default to system mode

      _themeMode = ThemeMode.values[themeIndex];
      _updateThemeState();

      notifyListeners();
    } catch (e) {
      // If loading fails, use default system theme
      _themeMode = ThemeMode.system;
      _updateThemeState();
    }
  }

  /// Save theme preference to SharedPreferences
  Future<void> _saveThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, _themeMode.index);
    } catch (e) {
      // Handle error silently
      debugPrint('Failed to save theme preference: $e');
    }
  }

  /// Update system brightness detection
  void _updateSystemBrightness() {
    // This would typically use MediaQuery.of(context).platformBrightness
    // For now, we'll simulate system brightness detection
    _systemBrightness = Brightness.dark; // Default assumption
  }

  /// Update theme state based on current mode
  void _updateThemeState() {
    switch (_themeMode) {
      case ThemeMode.light:
        _isDarkMode = false;
        break;
      case ThemeMode.dark:
        _isDarkMode = true;
        break;
      case ThemeMode.system:
        _isDarkMode = _systemBrightness == Brightness.dark;
        break;
    }
  }

  /// Cycle through theme modes: Light → Dark → Automatic → Light...
  Future<void> cycleTheme() async {
    switch (_themeMode) {
      case ThemeMode.light:
        await setThemeMode(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        await setThemeMode(ThemeMode.system);
        break;
      case ThemeMode.system:
        await setThemeMode(ThemeMode.light);
        break;
    }
  }

  /// Toggle between light and dark theme (legacy method)
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }

  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      _updateThemeState();

      await _saveThemePreference();
      notifyListeners();
    }
  }

  /// Set dark mode
  Future<void> setDarkMode(bool isDark) async {
    final newMode = isDark ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }

  /// Update system brightness (call this when system brightness changes)
  void updateSystemBrightness(Brightness brightness) {
    if (_systemBrightness != brightness) {
      _systemBrightness = brightness;
      if (_themeMode == ThemeMode.system) {
        _updateThemeState();
        notifyListeners();
      }
    }
  }

  /// Get current theme data
  ThemeData get currentTheme {
    switch (_themeMode) {
      case ThemeMode.dark:
        return AppTheme.darkTheme;
      case ThemeMode.light:
        return AppTheme.lightTheme;
      case ThemeMode.system:
        return _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    }
  }

  /// Get theme brightness
  Brightness get brightness {
    return _isDarkMode ? Brightness.dark : Brightness.light;
  }

  /// Check if current theme is dark
  bool get isDark {
    return _isDarkMode;
  }

  /// Check if current theme is light
  bool get isLight {
    return !_isDarkMode;
  }

  /// Get theme mode as string for display
  String get themeModeString {
    switch (_themeMode) {
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.system:
        return 'Automatic';
    }
  }

  /// Get theme mode description
  String get themeModeDescription {
    switch (_themeMode) {
      case ThemeMode.dark:
        return 'Always use dark theme';
      case ThemeMode.light:
        return 'Always use light theme';
      case ThemeMode.system:
        return 'Follow system preference';
    }
  }

  /// Get theme mode icon
  IconData get themeModeIcon {
    switch (_themeMode) {
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.system:
        return Icons.settings_system_daydream;
    }
  }

  /// Get available theme modes
  List<ThemeModeOption> get availableThemeModes => [
    ThemeModeOption(
      mode: ThemeMode.light,
      name: 'Light',
      description: 'Always use light theme',
      icon: Icons.light_mode,
    ),
    ThemeModeOption(
      mode: ThemeMode.dark,
      name: 'Dark',
      description: 'Always use dark theme',
      icon: Icons.dark_mode,
    ),
    ThemeModeOption(
      mode: ThemeMode.system,
      name: 'Automatic',
      description: 'Follow system setting',
      icon: Icons.settings_system_daydream,
    ),
  ];
}

/// Theme mode option for UI display
class ThemeModeOption {
  final ThemeMode mode;
  final String name;
  final String description;
  final IconData icon;

  const ThemeModeOption({
    required this.mode,
    required this.name,
    required this.description,
    required this.icon,
  });
}

/// Theme service provider widget
class ThemeServiceProvider extends InheritedWidget {
  final ThemeService themeService;

  const ThemeServiceProvider({
    super.key,
    required this.themeService,
    required super.child,
  });

  static ThemeService of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<ThemeServiceProvider>();
    assert(provider != null, 'ThemeServiceProvider not found in widget tree');
    return provider!.themeService;
  }

  @override
  bool updateShouldNotify(ThemeServiceProvider oldWidget) {
    return themeService != oldWidget.themeService;
  }
}
