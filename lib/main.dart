import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'services/goal_service.dart';
import 'services/calendar_service.dart';
import 'services/user_profile_service.dart';
import 'services/theme_service.dart';
import 'screens/home_screen.dart';
import 'screens/premium_unlock_screen.dart';
import 'screens/settings/payment_methods_screen.dart';
import 'screens/settings/app_appearance_screen.dart';
import 'screens/settings/data_analytics_screen.dart';
import 'screens/settings/app_updates_screen.dart';
import 'constants/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp(const HabitoXApp());
}

class HabitoXApp extends StatelessWidget {
  const HabitoXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // regarder plus en détail les providers
      providers: [
        ChangeNotifierProvider(create: (context) => GoalService()),
        ChangeNotifierProvider(create: (context) => CalendarService()),
        ChangeNotifierProvider(create: (context) => UserProfileService()),
        ChangeNotifierProvider(create: (context) => ThemeService()),
      ],
      child: ToastificationWrapper(
        child: Consumer<ThemeService>(
          builder: (context, themeService, _) => MaterialApp(
            // regarder la dépendance adaptive_dialog
            // localizationsDelegates: const [
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate,
            //   GlobalCupertinoLocalizations.delegate, // This is required
            // ],
            debugShowCheckedModeBanner: false,
            title: 'HabitoX',
            themeMode: themeService.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              primaryColor: AppColors.primaryColor,
              // scaffoldBackgroundColor: AppColors.lightColor.withValues(
              //   alpha: 0.15,
              // ),
              colorScheme: ColorScheme.dark(
                primary: Colors.white, // blanc
                secondary: Color(0xFFA7C6A5),
                tertiary: Color(0xFF1F4843),

                // text
                tertiaryFixed: Colors.white,
                tertiaryContainer: Colors.black,

                // background
                surface: const Color.fromRGBO(226, 239, 243, 1),

                // bordure
                outline: Colors.white,

                // shadow
                shadow: Color(0xFF1F4843).withValues(alpha: 0.08),
              ),
              textTheme: TextTheme(
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
                foregroundColor: Colors.white,
                titleTextStyle: TextStyle(
                  color: AppColors.darkColor,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Divider
              dividerTheme: DividerThemeData(
                color: AppColors.lightColor.withValues(alpha: 0.5),
                thickness: 1,
              ),

              // Icon
              iconTheme: IconThemeData(color: Colors.black),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              primaryColor: AppColors.primaryColor,
              scaffoldBackgroundColor: const Color(0xFF181920),
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

                // shadow
                shadow: Color(0xFF181920),
              ),

              textTheme: TextTheme(
                bodyLarge: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.white70),
                bodySmall: TextStyle(color: Colors.white60),
              ),

              iconTheme: IconThemeData(
                color: const Color.fromARGB(255, 223, 218, 218),
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
            home: const HomeScreen(),
            routes: {
              '/premium_unlock': (context) => const PremiumUnlockScreen(),
              '/payment_methods': (context) => const PaymentMethodsScreen(),

              '/app_appearance': (context) => const AppAppearanceScreen(),
              '/data_analytics': (context) => const DataAnalyticsScreen(),
              // '/rate_app': (context) => const RateAppScreen(),
              '/app_updates': (context) => const AppUpdatesScreen(),
            },
          ),
        ),
      ),
    );
  }
}
