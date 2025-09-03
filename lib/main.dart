import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'services/goal_service.dart';
import 'services/calendar_service.dart';
import 'services/user_profile_service.dart';
import 'services/theme_service.dart';
import 'widgets/theme_toggle_widget.dart';
import 'screens/home_screen.dart';
import 'screens/settings/payment_methods_screen.dart';
import 'screens/settings/billing_subscriptions_screen.dart';
import 'screens/settings/account_security_screen.dart';
import 'screens/settings/app_appearance_screen.dart';
import 'screens/settings/data_analytics_screen.dart';
import 'screens/settings/rate_app_screen.dart';
// import 'screens/settings/follow_instagram_screen.dart';
import 'screens/settings/app_updates_screen.dart';
import 'constants/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

  // Initialize theme service
  final themeService = ThemeService();
  await themeService.initialize();

  runApp(HabitoXApp(themeService: themeService));
}

class HabitoXApp extends StatelessWidget {
  final ThemeService themeService;

  const HabitoXApp({super.key, required this.themeService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>.value(value: themeService),
        ChangeNotifierProvider(create: (context) => GoalService()),
        ChangeNotifierProvider(create: (context) => CalendarService()),
        ChangeNotifierProvider(create: (context) => UserProfileService()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return SystemBrightnessWrapper(
            child: AnimatedTheme(
              duration: const Duration(milliseconds: 300),
              data: themeService.currentTheme,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'HabitoX',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeService.themeMode,
                home: const HomeScreen(),
                routes: {
                  '/payment_methods': (context) => const PaymentMethodsScreen(),
                  '/billing_subscriptions': (context) =>
                      const BillingSubscriptionsScreen(),
                  '/account_security': (context) =>
                      const AccountSecurityScreen(),
                  '/app_appearance': (context) => const AppAppearanceScreen(),
                  '/data_analytics': (context) => const DataAnalyticsScreen(),
                  '/rate_app': (context) => const RateAppScreen(),
                  // '/follow_instagram': (context) => const FollowInstagramScreen(),
                  '/app_updates': (context) => const AppUpdatesScreen(),
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
