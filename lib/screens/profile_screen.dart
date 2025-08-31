import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';
import '../constants/app_colors.dart';
import '../models/user_profile.dart' as models;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
    _loadDarkModePreference();
  }

  Future<void> _loadDarkModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
    });
  }

  Future<void> _toggleDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await prefs.setBool('dark_mode', _isDarkMode);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final padding = isTablet ? 32.0 : 20.0;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Account',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: _isDarkMode
                    ? AppColors.primaryColor
                    : AppColors.darkColor,
                fontSize: isTablet ? 28.0 : 24.0,
              ),
            ),
            elevation: 0,
            centerTitle: true,
            backgroundColor: _isDarkMode
                ? AppColors.darkColor
                : AppColors.lightColor,
            foregroundColor: _isDarkMode
                ? AppColors.primaryColor
                : Colors.white,
          ),
          backgroundColor: _isDarkMode
              ? AppColors.darkColor
              : AppColors.scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: FadeTransition(
                opacity: _fadeController,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildUpgradeCard(isTablet),
                      const SizedBox(height: 16),
                      _buildLevelCard(isTablet),
                      const SizedBox(height: 16),
                      _buildSettingsGroup(isTablet),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

extension on _ProfileScreenState {
  Widget _buildUpgradeCard(bool isTablet) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Premium required to upgrade')),
      ),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upgrade Plan Now!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Enjoy all the benefits and explore more possibilities',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.95),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard(bool isTablet) {
    return Consumer<UserProfileService>(
      builder: (context, profileService, child) {
        final level = profileService.userProfile?.level ?? 1;
        final unlockedBadges = profileService.userProfile?.unlockedBadges ?? [];

        // Get the highest level badge
        models.Badge? highestBadge;
        if (unlockedBadges.isNotEmpty) {
          highestBadge = unlockedBadges.reduce(
            (a, b) => a.level > b.level ? a : b,
          );
        }

        final emoji = highestBadge?.emoji ?? '💎';
        final color = highestBadge?.color ?? AppColors.primaryColor;

        return Container(
          padding: EdgeInsets.all(isTablet ? 18 : 16),
          decoration: BoxDecoration(
            color: _isDarkMode ? AppColors.darkColor : Colors.white,
            borderRadius: BorderRadius.circular(isTablet ? 18 : 16),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkColor.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level $level',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _isDarkMode
                            ? AppColors.primaryColor
                            : AppColors.darkColor,
                      ),
                    ),
                    Text(
                      highestBadge?.name ??
                          'You are a rising star! Keep going!',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            (_isDarkMode
                                    ? AppColors.primaryColor
                                    : AppColors.darkColor)
                                .withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: _isDarkMode
                    ? AppColors.primaryColor
                    : AppColors.darkColor,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsGroup(bool isTablet) {
    final items = <_SettingItem>[
      _SettingItem(Icons.tune, 'Preferences'),
      _SettingItem(Icons.credit_card, 'Payment Methods'),
      _SettingItem(Icons.subscriptions, 'Billing & Subscriptions'),
      _SettingItem(Icons.security, 'Terms of Service & Privacy Policy'),
      _SettingItem(Icons.file_download, 'Import', locked: true),
      _SettingItem(Icons.file_upload, 'Export', locked: true),
      _SettingItem(Icons.color_lens, 'App Appearance', isToggle: true),
      _SettingItem(Icons.insights, 'Data & Analytics'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _isDarkMode ? AppColors.darkColor : Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _buildSettingTile(items[i], isTablet),
            if (i != items.length - 1)
              Divider(
                height: 1,
                color: AppColors.lightColor.withValues(alpha: 0.2),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingTile(_SettingItem item, bool isTablet) {
    final titleStyle = TextStyle(
      fontSize: isTablet ? 16 : 14,
      fontWeight: FontWeight.w600,
      color: item.locked
          ? (_isDarkMode ? AppColors.primaryColor : AppColors.darkColor)
                .withValues(alpha: 0.4)
          : (_isDarkMode ? AppColors.primaryColor : AppColors.darkColor),
    );

    Widget tile = ListTile(
      leading: Icon(
        item.icon,
        color: item.locked
            ? Colors.grey
            : (_isDarkMode ? AppColors.primaryColor : AppColors.darkColor),
      ),
      title: Text(item.title, style: titleStyle),
      trailing: item.isToggle
          ? Switch(
              value: _isDarkMode,
              onChanged: (value) => _toggleDarkMode(),
              activeThumbColor: AppColors.primaryColor,
            )
          : item.locked
          ? const Icon(Icons.lock, color: Colors.grey)
          : Icon(
              Icons.chevron_right,
              color: _isDarkMode ? AppColors.primaryColor : AppColors.darkColor,
            ),
      onTap: item.isToggle
          ? null
          : item.locked
          ? () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Premium required to access this feature'),
              ),
            )
          : () {},
      enabled: !item.locked && !item.isToggle,
      contentPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 18 : 14,
        vertical: isTablet ? 6 : 2,
      ),
    );

    // Add tooltip for locked items
    if (item.locked) {
      return Tooltip(
        message: 'Premium required to access this feature',
        child: tile,
      );
    }

    return tile;
  }
}

class _SettingItem {
  final IconData icon;
  final String title;
  final bool locked;
  final bool isToggle;
  _SettingItem(
    this.icon,
    this.title, {
    this.locked = false,
    this.isToggle = false,
  });
}
