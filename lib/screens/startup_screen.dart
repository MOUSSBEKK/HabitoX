import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/onboarding_service.dart';
import 'onboarding_screen.dart';
import '../services/notification_service.dart';
import 'home_screen.dart';

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
      final notificationService = context.read<NotificationService>();

      await Future.delayed(const Duration(milliseconds: 500));

      if (!notificationService.isInitialized &&
          !notificationService.isInitializing) {
        await notificationService.initialize();
      } else {}

      // Marquer les services comme initialisés
      if (mounted) {
        setState(() {
          _servicesInitialized = true;
        });
      }
    } catch (e) {
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
        // Affiche un loader pendant le chargement
        if (onboardingService.isLoading) {
          return const _LoadingScreen();
        }

        if (onboardingService.isFirstTimeUser) {
          return const OnboardingScreen();
        }

        return const HomeScreen();
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'HabitoX',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFF6db399),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
