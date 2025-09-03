import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../constants/app_colors.dart';

/// Widget for cycling through light, dark, and automatic themes
class ThemeToggleWidget extends StatelessWidget {
  final bool showLabel;
  final bool isCompact;
  final bool useCycling;

  const ThemeToggleWidget({
    super.key,
    this.showLabel = true,
    this.isCompact = false,
    this.useCycling = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        if (isCompact) {
          return _buildCompactToggle(context, themeService);
        } else {
          return _buildFullToggle(context, themeService);
        }
      },
    );
  }

  Widget _buildCompactToggle(BuildContext context, ThemeService themeService) {
    return IconButton(
      onPressed: () =>
          useCycling ? themeService.cycleTheme() : themeService.toggleTheme(),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          themeService.themeModeIcon,
          key: ValueKey(themeService.themeMode),
          color: Theme.of(context).iconTheme.color,
        ),
      ),
      tooltip: _getTooltipText(themeService),
    );
  }

  Widget _buildFullToggle(BuildContext context, ThemeService themeService) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLabel) ...[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                themeService.themeModeIcon,
                key: ValueKey(themeService.themeMode),
                color: theme.iconTheme.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              themeService.themeModeString,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
          ],
          if (useCycling)
            _buildCyclingButton(context, themeService)
          else
            _buildSwitch(context, themeService),
        ],
      ),
    );
  }

  Widget _buildCyclingButton(BuildContext context, ThemeService themeService) {
    return GestureDetector(
      onTap: () => themeService.cycleTheme(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.accentPrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.accentPrimary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Next',
              style: TextStyle(
                color: AppColors.accentPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.accentPrimary,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(BuildContext context, ThemeService themeService) {
    final theme = Theme.of(context);
    return Switch(
      value: themeService.isDarkMode,
      onChanged: (value) => themeService.setDarkMode(value),
      activeColor: AppColors.accentPrimary,
      activeTrackColor: AppColors.accentPrimary.withOpacity(0.3),
      inactiveThumbColor: theme.textTheme.bodySmall?.color,
      inactiveTrackColor: theme.cardColor,
    );
  }

  String _getTooltipText(ThemeService themeService) {
    if (useCycling) {
      switch (themeService.themeMode) {
        case ThemeMode.light:
          return 'Switch to Dark Mode';
        case ThemeMode.dark:
          return 'Switch to Automatic Mode';
        case ThemeMode.system:
          return 'Switch to Light Mode';
      }
    } else {
      return themeService.isDarkMode
          ? 'Switch to Light Mode'
          : 'Switch to Dark Mode';
    }
  }
}

/// Theme selection dialog
class ThemeSelectionDialog extends StatelessWidget {
  const ThemeSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return AlertDialog(
          backgroundColor: theme.dialogBackgroundColor,
          title: Text('Choose Theme', style: theme.dialogTheme.titleTextStyle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: themeService.availableThemeModes.map((option) {
              final isSelected = themeService.themeMode == option.mode;

              return ListTile(
                leading: Icon(
                  option.icon,
                  color: isSelected
                      ? AppColors.accentPrimary
                      : theme.iconTheme.color,
                ),
                title: Text(
                  option.name,
                  style: TextStyle(
                    color: isSelected
                        ? theme.textTheme.headlineSmall?.color
                        : theme.textTheme.bodyLarge?.color,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  option.description,
                  style: TextStyle(
                    color: theme.textTheme.bodySmall?.color,
                    fontSize: 12,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: AppColors.accentPrimary)
                    : null,
                onTap: () {
                  themeService.setThemeMode(option.mode);
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor: isSelected
                    ? AppColors.accentPrimary.withOpacity(0.1)
                    : null,
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: theme.textTheme.bodySmall?.color),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Floating theme toggle button
class FloatingThemeToggle extends StatelessWidget {
  const FloatingThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return FloatingActionButton(
          onPressed: () => themeService.toggleTheme(),
          backgroundColor: AppColors.accentPrimary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              key: ValueKey(themeService.isDarkMode),
            ),
          ),
        );
      },
    );
  }
}

/// Theme toggle with animation
class AnimatedThemeToggle extends StatefulWidget {
  final bool showLabel;
  final bool useCycling;

  const AnimatedThemeToggle({
    super.key,
    this.showLabel = true,
    this.useCycling = true,
  });

  @override
  State<AnimatedThemeToggle> createState() => _AnimatedThemeToggleState();
}

class _AnimatedThemeToggleState extends State<AnimatedThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return GestureDetector(
          onTap: () {
            _animationController.forward().then((_) {
              if (widget.useCycling) {
                themeService.cycleTheme();
              } else {
                themeService.toggleTheme();
              }
              _animationController.reverse();
            });
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor, width: 1),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value * 3.14159,
                      child: Icon(
                        themeService.themeModeIcon,
                        color: theme.iconTheme.color,
                        size: 24,
                      ),
                    );
                  },
                ),
                if (widget.showLabel) ...[
                  const SizedBox(width: 8),
                  Text(
                    themeService.themeModeString,
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// System brightness detection wrapper
class SystemBrightnessWrapper extends StatefulWidget {
  final Widget child;

  const SystemBrightnessWrapper({super.key, required this.child});

  @override
  State<SystemBrightnessWrapper> createState() =>
      _SystemBrightnessWrapperState();
}

class _SystemBrightnessWrapperState extends State<SystemBrightnessWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final themeService = Provider.of<ThemeService>(context, listen: false);
    themeService.updateSystemBrightness(brightness);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Quick theme toggle button for app bars
class QuickThemeToggle extends StatelessWidget {
  final bool useCycling;

  const QuickThemeToggle({super.key, this.useCycling = true});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return IconButton(
          onPressed: () => useCycling
              ? themeService.cycleTheme()
              : themeService.toggleTheme(),
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              themeService.themeModeIcon,
              key: ValueKey(themeService.themeMode),
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          tooltip: _getTooltipText(themeService),
        );
      },
    );
  }

  String _getTooltipText(ThemeService themeService) {
    if (useCycling) {
      switch (themeService.themeMode) {
        case ThemeMode.light:
          return 'Switch to Dark Mode';
        case ThemeMode.dark:
          return 'Switch to Automatic Mode';
        case ThemeMode.system:
          return 'Switch to Light Mode';
      }
    } else {
      return themeService.isDarkMode
          ? 'Switch to Light Mode'
          : 'Switch to Dark Mode';
    }
  }
}
