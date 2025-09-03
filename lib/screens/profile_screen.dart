import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../services/user_profile_service.dart';
import '../constants/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final padding = isTablet ? 32.0 : 20.0;

        return Scaffold(
          appBar: AppBar(title: Text('Account')),
          backgroundColor: const Color.fromRGBO(226, 239, 243, 1),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(padding),
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
        );
      },
    );
  }
}

extension on _ProfileScreenState {
  Widget _buildUpgradeCard(bool isTablet) {
    return GestureDetector(
      // Ouvre la page de souscription premium
      onTap: () => Navigator.pushNamed(context, '/premium_unlock'),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          gradient: const LinearGradient(
            colors: [Color(0xFF6db399), Color(0xFFa9c4a5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6db399).withOpacity(0.25),
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
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard(bool isTablet) {
    return Consumer<UserProfileService>(
      builder: (context, profileService, child) {
        final stats = profileService.getXpStats();
        final level = stats['currentLevel'] as int? ?? 1;
        final levelName = stats['levelName'] as String? ?? 'Beginner';
        final levelColor = stats['levelColor'] as Color? ?? Color(0xFF6db399);
        final experiencePoints = stats['experiencePoints'] as int? ?? 0;
        final xpInCurrentLevel = stats['xpInCurrentLevel'] as int? ?? 0;
        final xpRequiredForCurrentLevel =
            stats['xpRequiredForCurrentLevel'] as int? ?? 10;
        final xpProgressToNext = stats['xpProgressToNext'] as double? ?? 0.0;

        return Container(
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: levelColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.workspace_premium,
                      color: levelColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Niveau $level',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: levelColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                levelName,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: levelColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$experiencePoints XP Total',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.darkColor.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Barre de progression XP
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progression XP',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkColor.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        '$xpInCurrentLevel / $xpRequiredForCurrentLevel XP',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: levelColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      // Fond de la barre
                      Container(
                        height: 8,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      // Progression
                      Container(
                        height: 8,
                        width:
                            MediaQuery.of(context).size.width *
                            xpProgressToNext *
                            0.8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [levelColor, levelColor.withOpacity(0.7)],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Prochain niveau: ${level + 1}',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.darkColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsGroup(bool isTablet) {
    final items = <_SettingItem>[
      // _SettingItem(Icons.credit_card, 'Payment Methods'),
      // _SettingItem(FaIcon(FontAwesomeIcons.chessQueen), 'Billing & Subscriptions'),
      _SettingItem(FaIcon(FontAwesomeIcons.eye), 'App Appearance'),
      _SettingItem(FaIcon(FontAwesomeIcons.chartLine), 'Data & Analytics'),
      _SettingItem(FaIcon(FontAwesomeIcons.fileImport), 'Import', locked: true),
      _SettingItem(FaIcon(FontAwesomeIcons.fileExport), 'Export', locked: true),
      _SettingItem(
        FaIcon(FontAwesomeIcons.lock),
        'Politique de confidentialité',
      ),
      _SettingItem(FaIcon(FontAwesomeIcons.instagram), 'Suivre sur Insta'),
      _SettingItem(
        FaIcon(FontAwesomeIcons.circleArrowUp),
        'Les Mise à jour de l\'app',
      ),
      _SettingItem(FaIcon(FontAwesomeIcons.star), 'Noter l\'app'),
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
      leading: item.icon,
      // color: item.locked ? Colors.grey : AppColors.darkColor,
      title: Text(item.title, style: titleStyle),
      trailing: item.locked
          ? const Icon(Icons.lock, color: Colors.grey)
          : const Icon(Icons.chevron_right),
      onTap: item.locked
          ? () => toastification.show(
              context: context,
              title: const Text('Premium requis'),
              type: ToastificationType.warning,
              style: ToastificationStyle.flatColored,
              autoCloseDuration: const Duration(seconds: 3),
            )
          : () => _navigateToSetting(item.title),
      enabled: !item.locked,
      contentPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 18 : 14,
        vertical: isTablet ? 6 : 2,
      ),
    );
  }

  // KIWI changer pour remplacer un id par un nom de page
  void _navigateToSetting(String settingTitle) {
    switch (settingTitle) {
      case 'Payment Methods':
        Navigator.pushNamed(context, '/payment_methods');
        break;
      case 'Billing & Subscriptions':
        Navigator.pushNamed(context, '/billing_subscriptions');
        break;
      case 'Account & Security':
        Navigator.pushNamed(context, '/account_security');
        break;
      case 'App Appearance':
        Navigator.pushNamed(context, '/app_appearance');
        break;
      case 'Data & Analytics':
        Navigator.pushNamed(context, '/data_analytics');
        break;
      case 'Politique de confidentialité':
        _openPrivacyPolicy();
        break;
      case 'Suivre sur Insta':
        _openInstagram();
        break;
      case 'Noter l\'app':
        Navigator.pushNamed(context, '/rate_app');
        break;
      // case 'Suivre sur Insta':
      //   Navigator.pushNamed(context, '/follow_instagram');
      //   break;
      case 'Les Mise à jour de l\'app':
        Navigator.pushNamed(context, '/app_updates');
        break;
      default:
        toastification.show(
          context: context,
          title: Text('Page "$settingTitle" en cours de développement'),
          type: ToastificationType.info,
          style: ToastificationStyle.flatColored,
          autoCloseDuration: const Duration(seconds: 3),
        );
    }
  }

  Future<void> _openPrivacyPolicy() async {
    final Uri termsUri = Uri.parse('https://habitox.app/terms');
    try {
      final bool didLaunch = await launchUrl(
        termsUri,
        mode: LaunchMode.externalApplication,
      );
      if (!didLaunch) {
        await launchUrl(termsUri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      // Dernier recours: affichage d'un toast
      toastification.show(
        context: context,
        title: const Text(
          'Impossible d\'ouvrir la politique de confidentialité',
        ),
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> _openInstagram() async {
    // Hypothèse: identifiant Instagram de HabitoX. Modifiez si besoin.
    const String instagramHandle = 'habitoxts';
    final Uri appUri = Uri.parse('instagram://user?username=$instagramHandle');
    final Uri webUri = Uri.parse('https://instagram.com/$instagramHandle');

    try {
      // Essaye l'app Instagram si installée
      bool opened = await launchUrl(
        appUri,
        mode: LaunchMode.externalApplication,
      );
      if (!opened) {
        // Fallback vers le site web (ouvre l'app si Android le gère, sinon navigateur)
        opened = await launchUrl(webUri, mode: LaunchMode.externalApplication);
        if (!opened) {
          await launchUrl(webUri, mode: LaunchMode.platformDefault);
        }
      }
    } catch (_) {
      // Dernier recours: navigateur par défaut
      try {
        await launchUrl(webUri, mode: LaunchMode.platformDefault);
      } catch (e) {
        toastification.show(
          context: context,
          title: const Text('Impossible d\'ouvrir Instagram'),
          type: ToastificationType.error,
          style: ToastificationStyle.flatColored,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }
  }
}

class _SettingItem {
  final FaIcon icon;
  final String title;
  final bool locked;
  _SettingItem(this.icon, this.title, {this.locked = false});
}
