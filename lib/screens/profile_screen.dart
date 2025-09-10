import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../services/user_profile_service.dart';
import '../services/onboarding_service.dart';
import '../constants/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
          backgroundColor: Theme.of(context).colorScheme.surface,
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
  // Fonction helper pour obtenir le bon badge selon le niveau
  String _getBadgeAssetForLevel(int level) {
    final List<String> assetFiles = [
      'BADGE1.png',
      'BADGE2.png',
      'BADGE3.png',
      'BADGE4.png',
      'BADGE5.png',
      'BADGE6.png',
      'BADGE8.png',
      'BADGE9.png',
      'BADGE10.png',
    ];

    // Mapping des niveaux de badges vers les indices des assets
    final badgeLevels = [1, 5, 10, 15, 20, 25, 30, 35, 40];
    int badgeIndex = 0;

    for (int i = 0; i < badgeLevels.length; i++) {
      if (level >= badgeLevels[i]) {
        badgeIndex = i;
      } else {
        break;
      }
    }

    badgeIndex = badgeIndex.clamp(0, assetFiles.length - 1);
    return 'assets/badges/${assetFiles[badgeIndex]}';
  }

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
              // ! changer pour Theme.of(context).colorScheme.shadow
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
                  Text(
                    AppLocalizations.of(context)!.upgrade_card_title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.upgrade_card_subtitle,
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
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: levelColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      _getBadgeAssetForLevel(level),
                      width: 32,
                      height: 32,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.workspace_premium,
                        color: levelColor,
                        size: 24,
                      ),
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
                              'Level $level',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.color,
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
                          '$experiencePoints Total XP',
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
                        'XP progression',
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
                    'Next level: ${level + 1}',
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
      _SettingItem(
        key: SettingKey.appAppearance,
        icon: FaIcon(
          FontAwesomeIcons.eye,
          size: 20,
          color: Theme.of(context).iconTheme.color,
        ),
        title: AppLocalizations.of(context)!.settings_appearance,
      ),
      _SettingItem(
        key: SettingKey.dataAnalytics,
        icon: FaIcon(
          FontAwesomeIcons.chartLine,
          size: 20,
          color: Theme.of(context).iconTheme.color,
        ),
        title: AppLocalizations.of(context)!.settings_data_analytics,
      ),
      _SettingItem(
        key: SettingKey.language,
        icon: FaIcon(
          FontAwesomeIcons.language,
          size: 20,
          color: Theme.of(context).iconTheme.color,
        ),
        title: AppLocalizations.of(context)!.settings_language,
      ),
      _SettingItem(
        key: SettingKey.importData,
        icon: FaIcon(
          FontAwesomeIcons.fileImport,
          size: 20,
          color: Theme.of(context).iconTheme.color,
        ),
        title: AppLocalizations.of(context)!.settings_import,
        locked: true,
      ),
      _SettingItem(
        key: SettingKey.exportData,
        icon: FaIcon(
          FontAwesomeIcons.fileExport,
          size: 20,
          color: Theme.of(context).iconTheme.color,
        ),
        title: AppLocalizations.of(context)!.settings_export,
        locked: true,
      ),
      _SettingItem(
        key: SettingKey.privacyPolicy,
        icon: FaIcon(
          FontAwesomeIcons.lock,
          size: 20,
          color: Theme.of(context).iconTheme.color,
        ),
        title: AppLocalizations.of(context)!.settings_privacy_policy,
      ),
      _SettingItem(
        key: SettingKey.appUpdates,
        icon: FaIcon(
          FontAwesomeIcons.circleArrowUp,
          size: 20,
          color: Theme.of(context).iconTheme.color,
        ),
        title: AppLocalizations.of(context)!.settings_app_updates,
      ),
      _SettingItem(
        key: SettingKey.rateApp,
        icon: FaIcon(
          FontAwesomeIcons.star,
          size: 20,
          color: Theme.of(context).iconTheme.color,
        ),
        title: AppLocalizations.of(context)!.settings_rate_app,
      ),
      _SettingItem(
        key: SettingKey.followInstagram,
        icon: FaIcon(
          FontAwesomeIcons.instagram,
          size: 20,
          color: Theme.of(context).iconTheme.color,
        ),
        title: AppLocalizations.of(context)!.settings_follow_instagram,
      ),
      // Bouton de reset onboarding uniquement en mode debug
      if (kDebugMode)
        _SettingItem(
          key: SettingKey.resetOnboarding,
          icon: FaIcon(
            FontAwesomeIcons.rotateLeft,
            size: 20,
            color: Theme.of(context).iconTheme.color,
          ),
          title: 'Reset Onboarding (Debug)',
        ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
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
          ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.4)
          : Theme.of(context).textTheme.bodyLarge?.color,
    );

    return ListTile(
      key: Key(item.key.name),
      leading: item.icon,
      // color: item.locked ? Colors.grey : AppColors.darkColor,
      title: Text(item.title, style: titleStyle),
      trailing: item.locked
          ? Icon(Icons.lock, color: Theme.of(context).iconTheme.color)
          : Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color),
      onTap: item.locked
          ? () => toastification.show(
              context: context,
              title: const Text('Premium required'),
              type: ToastificationType.warning,
              style: ToastificationStyle.flatColored,
              autoCloseDuration: const Duration(seconds: 3),
            )
          : () => _navigateToSetting(item.key),
      enabled: !item.locked,
      contentPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 18 : 14,
        vertical: isTablet ? 6 : 2,
      ),
    );
  }

  // Navigation basée sur une clé stable (indépendante de la localisation)
  void _navigateToSetting(SettingKey setting) {
    switch (setting) {
      case SettingKey.appAppearance:
        Navigator.pushNamed(context, '/app_appearance');
        break;
      case SettingKey.dataAnalytics:
        Navigator.pushNamed(context, '/data_analytics');
        break;
      case SettingKey.language:
        Navigator.pushNamed(context, '/language_settings');
        break;
      case SettingKey.privacyPolicy:
        _openPrivacyPolicy();
        break;
      case SettingKey.followInstagram:
        _openInstagram();
        break;
      case SettingKey.rateApp:
        _rateApp();
        break;
      case SettingKey.appUpdates:
        Navigator.pushNamed(context, '/app_updates');
        break;
      case SettingKey.resetOnboarding:
        _resetOnboarding();
        break;
      case SettingKey.importData:
      case SettingKey.exportData:
        toastification.show(
          context: context,
          title: const Text('Fonctionnalité à venir'),
          type: ToastificationType.info,
          style: ToastificationStyle.flatColored,
          autoCloseDuration: const Duration(seconds: 3),
        );
        break;
    }
  }

  Future<void> _resetOnboarding() async {
    if (kDebugMode) {
      final onboardingService = Provider.of<OnboardingService>(
        context,
        listen: false,
      );
      await onboardingService.resetOnboarding();

      toastification.show(
        context: context,
        title: const Text('Onboarding réinitialisé'),
        description: const Text('Redémarrez l\'app pour voir l\'onboarding'),
        type: ToastificationType.success,
        style: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 4),
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
    const String instagramHandle = 'habitoxts';
    final Uri appUri = Uri.parse('instagram://user?username=$instagramHandle');
    final Uri webUri = Uri.parse('https://instagram.com/$instagramHandle');

    try {
      bool opened = await launchUrl(
        appUri,
        mode: LaunchMode.externalApplication,
      );
      if (!opened) {
        opened = await launchUrl(webUri, mode: LaunchMode.externalApplication);
        if (!opened) {
          await launchUrl(webUri, mode: LaunchMode.platformDefault);
        }
      }
    } catch (_) {
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

  Future<void> _rateApp() async {
    final InAppReview inAppReview = InAppReview.instance;

    try {
      // Vérifier si la fonctionnalité de notation est disponible
      if (await inAppReview.isAvailable()) {
        // Demander la notation in-app
        await inAppReview.requestReview();

        // Afficher un message de remerciement
        toastification.show(
          context: context,
          title: const Text('Merci pour votre retour !'),
          description: const Text(
            'Votre avis nous aide à améliorer l\'application',
          ),
          type: ToastificationType.success,
          style: ToastificationStyle.flatColored,
          autoCloseDuration: const Duration(seconds: 3),
        );
      } else {
        // Si la notation in-app n'est pas disponible, ouvrir le store
        await inAppReview.openStoreListing();
      }
    } catch (e) {
      // En cas d'erreur, proposer d'ouvrir le store directement
      toastification.show(
        context: context,
        title: const Text('Erreur'),
        description: const Text(
          'Impossible d\'ouvrir la notation. Redirection vers le store...',
        ),
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 3),
      );

      try {
        await inAppReview.openStoreListing();
      } catch (storeError) {
        toastification.show(
          context: context,
          title: const Text('Erreur'),
          description: const Text(
            'Impossible d\'ouvrir le store. Veuillez noter l\'app manuellement.',
          ),
          type: ToastificationType.error,
          style: ToastificationStyle.flatColored,
          autoCloseDuration: const Duration(seconds: 4),
        );
      }
    }
  }
}

enum SettingKey {
  appAppearance,
  dataAnalytics,
  language,
  importData,
  exportData,
  privacyPolicy,
  appUpdates,
  rateApp,
  followInstagram,
  resetOnboarding,
}

class _SettingItem {
  final SettingKey key;
  final FaIcon icon;
  final String title;
  final bool locked;

  _SettingItem({
    required this.key,
    required this.icon,
    required this.title,
    this.locked = false,
  });
}
