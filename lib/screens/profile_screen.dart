import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';
import '../constants/app_colors.dart';

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
                color: Colors.greenAccent,
                fontSize: isTablet ? 28.0 : 24.0,
              ),
            ),
            elevation: 0,
            centerTitle: true,
            backgroundColor: const Color.fromRGBO(226, 239, 243, 1),
            foregroundColor: Colors.white,
          ),
          backgroundColor: const Color(0xFFF8FAFC),
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
        const SnackBar(content: Text('Premium requis pour upgrader')),
      ),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          gradient: const LinearGradient(
            colors: [Color(0xFF7C4DFF), Color(0xFF9B72FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.25),
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
                color: Colors.white.withOpacity(0.2),
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
                      color: Colors.white.withOpacity(0.95),
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
        final level = profileService.userProfile?.auraLevel ?? 1;
        final emoji = profileService.userProfile?.auraEmoji ?? '💎';
        final color =
            profileService.userProfile?.auraColor ?? AppColors.primaryColor;

        return Container(
          padding: EdgeInsets.all(isTablet ? 18 : 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isTablet ? 18 : 16),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkColor.withOpacity(0.06),
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
                  color: color.withOpacity(0.15),
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
                        color: AppColors.darkColor,
                      ),
                    ),
                    Text(
                      'You are a rising star! Keep going!',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.darkColor.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
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
      _SettingItem(Icons.security, 'Account & Security'),
      _SettingItem(Icons.file_download, 'Import', locked: true),
      _SettingItem(Icons.file_upload, 'Export', locked: true),
      _SettingItem(Icons.color_lens, 'App Appearance'),
      _SettingItem(Icons.insights, 'Data & Analytics'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
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
            _buildSettingTile(items[i], isTablet),
            if (i != items.length - 1)
              Divider(height: 1, color: AppColors.lightColor.withOpacity(0.2)),
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
          ? AppColors.darkColor.withOpacity(0.4)
          : AppColors.darkColor,
    );

    return ListTile(
      leading: Icon(
        item.icon,
        color: item.locked ? Colors.grey : AppColors.darkColor,
      ),
      title: Text(item.title, style: titleStyle),
      trailing: item.locked
          ? const Icon(Icons.lock, color: Colors.grey)
          : const Icon(Icons.chevron_right),
      onTap: item.locked
          ? () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Premium requis')))
          : () {},
      enabled: !item.locked,
      contentPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 18 : 14,
        vertical: isTablet ? 6 : 2,
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String title;
  final bool locked;
  _SettingItem(this.icon, this.title, {this.locked = false});
}
