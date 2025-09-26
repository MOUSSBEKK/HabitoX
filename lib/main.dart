import 'dart:math';

import 'constants/app_colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'l10n/app_localizations.dart';
import 'screens/onboarding_screen.dart';
import 'screens/premium_unlock_screen.dart';
import 'screens/settings/app_appearance_screen.dart';
import 'screens/settings/app_updates_screen.dart';
import 'screens/data_analytics_screen.dart';
import 'screens/startup_screen.dart';
import 'services/calendar_service.dart';
import 'services/goal_service.dart';
import 'services/onboarding_service.dart';
import 'services/theme_service.dart';
import 'services/language_service.dart';
import 'services/user_profile_service.dart';
import 'services/notification_service.dart';
import 'screens/settings/language_settings_screen.dart';
import 'screens/settings/notification_settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  final languageService = LanguageService();
  await languageService.load();

  runApp(HabitoXApp(languageService: languageService));
}

class HabitoXApp extends StatelessWidget {
  final LanguageService languageService;
  const HabitoXApp({super.key, required this.languageService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // regarder plus en détail les providers
      providers: [
        ChangeNotifierProvider(create: (context) => GoalService()),
        ChangeNotifierProvider(create: (context) => CalendarService()),
        ChangeNotifierProvider(create: (context) => UserProfileService()),
        ChangeNotifierProvider(create: (context) => ThemeService()),
        ChangeNotifierProvider(create: (context) => OnboardingService()),
        ChangeNotifierProvider<LanguageService>.value(value: languageService),
        ChangeNotifierProvider(
          create: (context) {
            final notificationService = NotificationService();
            // Initialiser de manière asynchrone sans bloquer
            notificationService.initialize();
            debugPrint("NotificationService");
            return notificationService;
          },
        ),
      ],

      child: ToastificationWrapper(
        child: Consumer<ThemeService>(
          builder: (context, themeService, _) => MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            // langue supportées
            supportedLocales: const [
              Locale('en'),
              Locale('fr'),
              Locale('de'),
              Locale('es'),
            ],

            locale: context.watch<LanguageService>().effectiveLocale,
            debugShowCheckedModeBanner: false,
            title: 'HabitoX',
            themeMode: themeService.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              primaryColor: AppColors.primaryColor,
              scaffoldBackgroundColor: Color.fromRGBO(226, 239, 243, 1),
              colorScheme: ColorScheme.dark(
                primary: Colors.white, // blanc
                secondary: Color(0xFFA7C6A5),
                tertiary: Color(0xFF1F4843),

                // text
                tertiaryFixed: Colors.white,
                tertiaryContainer: Colors.black,

                // background card
                surface: AppColors.surfaceColor,

                // bordure
                outline: Color(0xFF282c31),
                outlineVariant: Colors.white,

                // shadow
                shadow: Color(0xFF1F4843).withValues(alpha: 0.08),
              ),

              textTheme: TextTheme(
                titleLarge: TextStyle(color: AppColors.primaryColor),
                bodyLarge: TextStyle(
                  color: const Color.fromARGB(255, 11, 11, 11),
                ),
                bodyMedium: TextStyle(
                  color: const Color.fromARGB(179, 0, 0, 0),
                ),
                bodySmall: TextStyle(color: const Color.fromARGB(153, 0, 0, 0)),
              ),

              appBarTheme: AppBarTheme(
                elevation: 0,
                centerTitle: true,
                backgroundColor: const Color.fromRGBO(226, 239, 243, 1),
                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                titleTextStyle: TextStyle(
                  color: AppColors.darkColor,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Divider
              // dividerTheme: DividerThemeData(
              //   color: AppColors.lightColor.withValues(alpha: 0.5),
              //   thickness: 1,
              // ),

              // Icon
              iconTheme: IconThemeData(color: const Color(0xFF191919)),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              primaryColor: AppColors.primaryColor,
              scaffoldBackgroundColor: AppColors.scaffoldBackgroundColorDark,
              colorScheme: ColorScheme.dark(
                primary: Color(0xFF1f222a),
                secondary: Color(0xFFA7C6A5),
                tertiary: Color.fromARGB(255, 135, 135, 135),

                // text
                tertiaryFixed: Colors.black,
                tertiaryContainer: Colors.white,

                // background
                surface: Color(0xFF181920),

                // bordure
                outline: Color(0xFF282c31),
                outlineVariant: Color(0xFF282c31),

                // shadow
                shadow: Color(0xFF181920),
              ),

              textTheme: TextTheme(
                titleLarge: TextStyle(color: AppColors.darkColor),
                bodyLarge: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.white),
                bodySmall: TextStyle(color: Colors.white60),
              ),

              iconTheme: IconThemeData(
                color: Color.fromARGB(255, 223, 218, 218),
              ),

              appBarTheme: const AppBarTheme(
                elevation: 0,
                centerTitle: true,
                backgroundColor: Color(0xFF181920),
                foregroundColor: Colors.white,
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              dividerTheme: DividerThemeData(
                color: Colors.white.withOpacity(0.12),
                thickness: 1,
              ),

              cardColor: const Color(0xFF1F232B),
            ),
            home: const StartupScreen(),
            routes: {
              '/onboarding': (context) => const OnboardingScreen(),
              '/premium_unlock': (context) => const PremiumUnlockScreen(),
              '/app_appearance': (context) => const AppAppearanceScreen(),
              '/data_analytics': (context) => const DataAnalyticsScreen(),
              '/app_updates': (context) => const AppUpdatesScreen(),
              '/language_settings': (context) => const LanguageSettingsScreen(),
              '/notification_settings': (context) =>
                  const NotificationSettingsScreen(),
            },
          ),
        ),
      ),
    );
  }
}
