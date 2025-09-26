import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/onboarding_service.dart';
import '../services/notification_service.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';

/// Écran de démarrage qui détermine s'il faut afficher l'onboarding ou l'accueil
/// Gère la logique de première ouverture de l'application et les initialisations
class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  bool _servicesInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      debugPrint('🔄 StartupScreen: Début initialisation des services');

      // Récupérer le service de notification et s'assurer qu'il est initialisé
      final notificationService = context.read<NotificationService>();
      debugPrint('🔄 StartupScreen: NotificationService récupéré');

      // Attendre un délai minimal pour laisser l'UI se charger
      await Future.delayed(const Duration(milliseconds: 500));
      debugPrint('🔄 StartupScreen: Délai initial terminé');

      // Vérifier si le service de notification est initialisé
      if (!notificationService.isInitialized &&
          !notificationService.isInitializing) {
        debugPrint(
          '🔄 StartupScreen: Initialisation du NotificationService...',
        );
        await notificationService.initialize();
        debugPrint('✅ StartupScreen: NotificationService initialisé');
      } else {
        debugPrint('✅ StartupScreen: NotificationService déjà initialisé');
      }

      // Marquer les services comme initialisés
      if (mounted) {
        debugPrint('🔄 StartupScreen: Marquage des services comme initialisés');
        setState(() {
          _servicesInitialized = true;
        });
        debugPrint('✅ StartupScreen: Services marqués comme initialisés');
      }
    } catch (e) {
      debugPrint('❌ StartupScreen: Erreur lors de l\'initialisation: $e');
      // En cas d'erreur, continuer quand même
      if (mounted) {
        setState(() {
          _servicesInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingService>(
      builder: (context, onboardingService, child) {
        debugPrint(
          '🔄 StartupScreen build: isLoading=${onboardingService.isLoading}, servicesInitialized=$_servicesInitialized',
        );

        // Affiche un loader pendant le chargement des services ou de l'onboarding
        if (onboardingService.isLoading || !_servicesInitialized) {
          debugPrint('📱 StartupScreen: Affichage LoadingScreen');
          return const _LoadingScreen();
        }

        // Affiche l'onboarding si c'est la première fois
        if (onboardingService.isFirstTimeUser) {
          debugPrint('📱 StartupScreen: Affichage OnboardingScreen');
          return const OnboardingScreen();
        }

        // Sinon affiche l'écran d'accueil
        debugPrint('📱 StartupScreen: Affichage HomeScreen');
        return MaterialApp(
          home: _SimpleHomeScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

/// Écran de chargement avec le logo HabitoX
class _LoadingScreen extends StatefulWidget {
  const _LoadingScreen();

  @override
  State<_LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<_LoadingScreen>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  // late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(
    //   duration: const Duration(milliseconds: 1500),
    //   vsync: this,
    // );
    // _animation = Tween<double>(
    //   begin: 0.8,
    //   end: 1.1,
    // ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // // Animation en boucle
    // _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo animé
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6db399), Color(0xFFa9c4a5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6db399).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'H',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Nom de l'app
            const Text(
              'HabitoX',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
              ),
            ),

            // const SizedBox(height: 32),

            // Indicateur de chargement
            // SizedBox(
            //   width: 40,
            //   height: 40,
            //   child: CircularProgressIndicator(
            //     strokeWidth: 3,
            //     valueColor: AlwaysStoppedAnimation<Color>(
            //       const Color(0xFF6db399),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

/// Écran d'accueil simplifié temporaire pour tester
class _SimpleHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('📱 SimpleHomeScreen: Construction de l\'écran');
    debugPrint(
      '📱 SimpleHomeScreen: MediaQuery size = ${MediaQuery.of(context).size}',
    );
    debugPrint(
      '📱 SimpleHomeScreen: Theme brightness = ${Theme.of(context).brightness}',
    );

    return Scaffold(
      backgroundColor: Colors.red, // Couleur de fond très visible pour debug
      appBar: AppBar(
        title: Text('HabitoX - Test', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 8,
      ),
      body: Container(
        color: Colors.yellow, // Arrière-plan jaune très visible
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Container(
            color: Colors.green,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 80, color: Colors.purple),
                SizedBox(height: 20),
                Text(
                  'APPLICATION DÉMARRÉE !',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Écran noir résolu ✅',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    debugPrint('📱 SimpleHomeScreen: Bouton pressé');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Text(
                    'ÉCRAN PRINCIPAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    elevation: 8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
