import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/onboarding_service.dart';
import '../services/notification_service.dart';
import '../l10n/app_localizations.dart';
import 'package:hugeicons_pro/hugeicons.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Contrôleurs d'animation
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Démarre les animations
    _fadeController.forward();
    _slideController.forward();

    // Afficher la modal de permission après un délai si les notifications ne sont pas encore configurées
    Future.delayed(const Duration(milliseconds: 1500), () async {
      if (mounted) {
        // Vérifier si l'utilisateur n'a pas encore fait de choix
        final prefs = await SharedPreferences.getInstance();
        final hasAskedForPermission =
            prefs.getBool('has_asked_notification_permission') ?? false;

        if (!hasAskedForPermission) {
          final notificationService = Provider.of<NotificationService>(
            context,
            listen: false,
          );
          // Demander directement la permission native du système
          final permissionGranted = await notificationService
              .requestPermissions();

          // Si l'utilisateur accepte, activer les notifications
          if (permissionGranted) {
            await notificationService.setNotificationsEnabled(true);
          }

          // Marquer qu'on a demandé la permission
          await prefs.setBool('has_asked_notification_permission', true);
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    final onboardingService = Provider.of<OnboardingService>(
      context,
      listen: false,
    );
    onboardingService.completeOnboarding();
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Utiliser MediaQuery.sizeOf pour de meilleures performances
        final screenWidth = MediaQuery.sizeOf(context).width;
        final screenHeight = MediaQuery.sizeOf(context).height;

        // Déterminer le type d'écran
        final isTablet = screenWidth > 600;
        final isSmallScreen = screenWidth < 360;
        final isVerySmallScreen = screenHeight < 600;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                      _fadeController.reset();
                      _slideController.reset();
                      _fadeController.forward();
                      _slideController.forward();
                    },
                    children: [
                      _buildWelcomePage(
                        isTablet,
                        isSmallScreen,
                        isVerySmallScreen,
                      ),
                      _buildHowItWorksPage(
                        isTablet,
                        isSmallScreen,
                        isVerySmallScreen,
                      ),
                    ],
                  ),
                ),

                // Indicateurs de page et boutons
                _buildBottomSection(isTablet, isSmallScreen),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomePage(
    bool isTablet,
    bool isSmallScreen,
    bool isVerySmallScreen,
  ) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 20.0 : (isTablet ? 48.0 : 32.0),
              vertical: isVerySmallScreen ? 16.0 : (isTablet ? 32.0 : 24.0),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.sizeOf(context).height -
                    kToolbarHeight -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    (isVerySmallScreen
                        ? 120
                        : 160), // Espace pour le bottom section
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icon_launcher/logo_launcher_habitox.png',
                    width: isSmallScreen ? 120 : (isTablet ? 200 : 180),
                    height: isSmallScreen ? 120 : (isTablet ? 200 : 180),
                  ),
                  SizedBox(height: isSmallScreen ? 24 : (isTablet ? 48 : 40)),

                  // Titre principal
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 20 : (isTablet ? 28 : 24),
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: isSmallScreen ? 8 : (isTablet ? 12 : 8)),

                  // Logo/Nom de l'app avec style
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 16 : (isTablet ? 24 : 20),
                      vertical: isSmallScreen ? 8 : (isTablet ? 12 : 10),
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6db399), Color(0xFFa9c4a5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6db399).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      'HabitoX',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 24 : (isTablet ? 36 : 32),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 20 : (isTablet ? 32 : 24)),

                  // Message principal
                  Text(
                    AppLocalizations.of(context)!.onboarding_title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : (isTablet ? 22 : 18),
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: isSmallScreen ? 16 : (isTablet ? 24 : 20)),

                  // Message rassurant
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12 : (isTablet ? 20 : 16),
                      vertical: isSmallScreen ? 10 : (isTablet ? 16 : 12),
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                          size: isSmallScreen ? 18 : (isTablet ? 24 : 20),
                        ),
                        SizedBox(
                          width: isSmallScreen ? 6 : (isTablet ? 12 : 8),
                        ),
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context)!.onboarding_popup,
                            style: TextStyle(
                              fontSize: isSmallScreen
                                  ? 12
                                  : (isTablet ? 16 : 14),
                              fontWeight: FontWeight.w500,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHowItWorksPage(
    bool isTablet,
    bool isSmallScreen,
    bool isVerySmallScreen,
  ) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 20.0 : (isTablet ? 48.0 : 32.0),
              vertical: isVerySmallScreen ? 16.0 : (isTablet ? 32.0 : 24.0),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.sizeOf(context).height -
                    kToolbarHeight -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    (isVerySmallScreen
                        ? 120
                        : 160), // Espace pour le bottom section
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Titre
                  Text(
                    AppLocalizations.of(context)!.onboarding2_title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 24 : (isTablet ? 32 : 28),
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: isSmallScreen ? 24 : (isTablet ? 48 : 40)),

                  // Étapes
                  _buildStep(
                    isTablet,
                    isSmallScreen,
                    HugeIconsStroke.eye,
                    AppLocalizations.of(context)!.onboarding_title_card1,
                    AppLocalizations.of(context)!.onboarding_subtitles_card1,
                    const Color(0xFF6db399),
                  ),

                  SizedBox(height: isSmallScreen ? 16 : (isTablet ? 32 : 24)),

                  _buildStep(
                    isTablet,
                    isSmallScreen,
                    HugeIconsStroke.analytics01,
                    AppLocalizations.of(context)!.onboarding_title_card2,
                    AppLocalizations.of(context)!.onboarding_subtitles_card2,
                    const Color(0xFFa9c4a5),
                  ),

                  SizedBox(height: isSmallScreen ? 16 : (isTablet ? 32 : 24)),

                  _buildStep(
                    isTablet,
                    isSmallScreen,
                    HugeIconsStroke.champion,
                    AppLocalizations.of(context)!.onboarding_title_card3,
                    AppLocalizations.of(context)!.onboarding_subtitles_card3,
                    const Color(0xFF85b8cb),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(
    bool isTablet,
    bool isSmallScreen,
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : (isTablet ? 20 : 16)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icône
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 8 : (isTablet ? 16 : 12)),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: isSmallScreen ? 20 : (isTablet ? 28 : 24),
              color: color,
            ),
          ),

          SizedBox(width: isSmallScreen ? 12 : (isTablet ? 20 : 16)),

          // Texte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : (isTablet ? 18 : 16),
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isSmallScreen ? 4 : (isTablet ? 8 : 4)),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : (isTablet ? 14 : 12),
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(bool isTablet, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 16.0 : (isTablet ? 32.0 : 24.0)),
      child: Column(
        children: [
          // Indicateurs de page
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 2; i++)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i
                      ? (isSmallScreen ? 20 : 24)
                      : (isSmallScreen ? 6 : 8),
                  height: isSmallScreen ? 6 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? const Color(0xFF6db399)
                        : Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),

          SizedBox(height: isSmallScreen ? 20 : (isTablet ? 32 : 24)),

          // Bouton principal
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6db399),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 14 : (isTablet ? 18 : 16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 6,
                shadowColor: const Color(0xFF6db399).withOpacity(0.3),
              ),
              child: Text(
                _currentPage == 1
                    ? AppLocalizations.of(context)!.onboarding2_btn
                    : AppLocalizations.of(context)!.onboarding_btn,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : (isTablet ? 18 : 16),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
