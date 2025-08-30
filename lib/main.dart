import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'services/goal_service.dart';
import 'services/calendar_service.dart';
import 'services/user_profile_service.dart';
import 'screens/home_screen.dart';
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
      providers: [
        ChangeNotifierProvider(create: (context) => GoalService()),
        ChangeNotifierProvider(create: (context) => CalendarService()),
        ChangeNotifierProvider(create: (context) => UserProfileService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HabitoX',
        theme: ThemeData(
          useMaterial3: true,

          // Couleurs principales
          primaryColor: AppColors.primaryColor,
          // primarySwatch:
          //     MaterialColor(AppColors.primaryColor.value, <int, Color>{
          //       50: AppColors.primaryColor.withValues(alpha: 0.1),
          //       100: AppColors.primaryColor.withValues(alpha: 0.2),
          //       200: AppColors.primaryColor.withValues(alpha: 0.3),
          //       300: AppColors.primaryColor.withValues(alpha: 0.4),
          //       400: AppColors.primaryColor.withValues(alpha: 0.5),
          //       500: AppColors.primaryColor,
          //       600: AppColors.primaryDark,
          //       700: AppColors.primaryDark,
          //       800: AppColors.primaryDark,
          //       900: AppColors.primaryDark,
          //     }),

          // Couleurs de surface
          scaffoldBackgroundColor: AppColors.lightColor.withValues(alpha: 0.15),
          cardColor: Colors.white,

          // AppBar
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            foregroundColor: AppColors.darkColor,
            titleTextStyle: TextStyle(
              color: AppColors.darkColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          // Boutons
          // elevatedButtonTheme: ElevatedButtonThemeData(
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: AppColors.primaryColor,
          //     foregroundColor: Colors.white,
          //     elevation: 0,
          //     shadowColor: AppColors.primaryColor.withValues(alpha: 0.3),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(16),
          //     ),
          //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          //     textStyle: const TextStyle(
          //       fontSize: 16,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          // ),

          // outlinedButtonTheme: OutlinedButtonThemeData(
          //   style: OutlinedButton.styleFrom(
          //     foregroundColor: AppColors.darkColor,
          //     side: BorderSide(
          //       color: AppColors.darkColor.withValues(alpha: 0.3),
          //       width: 1.5,
          //     ),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(16),
          //     ),
          //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          //     textStyle: const TextStyle(
          //       fontSize: 16,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          // ),
          // textButtonTheme: TextButtonThemeData(
          //   style: TextButton.styleFrom(
          //     foregroundColor: AppColors.primaryColor,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          //     textStyle: const TextStyle(
          //       fontSize: 16,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          // ),

          // // Cartes
          // cardTheme: CardThemeData(
          //   color: Colors.white,
          //   elevation: 0,
          //   shadowColor: AppColors.darkColor.withValues(alpha: 0.1),
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(20),
          //     side: BorderSide(
          //       color: AppColors.lightColor.withValues(alpha: 0.3),
          //       width: 1,
          //     ),
          //   ),
          // ),

          // // Input
          // inputDecorationTheme: InputDecorationTheme(
          //   filled: true,
          //   fillColor: AppColors.lightColor.withValues(alpha: 0.2),
          //   border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(16),
          //     borderSide: BorderSide(
          //       color: AppColors.lightColor.withValues(alpha: 0.5),
          //     ),
          //   ),
          //   enabledBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(16),
          //     borderSide: BorderSide(
          //       color: AppColors.lightColor.withValues(alpha: 0.5),
          //     ),
          //   ),
          //   focusedBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(16),
          //     borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          //   ),
          //   labelStyle: TextStyle(color: AppColors.darkColor.withValues(alpha: 0.7)),
          //   hintStyle: TextStyle(color: AppColors.darkColor.withValues(alpha: 0.5)),
          // ),

          // Textes
          // textTheme: const TextTheme(
          //   displayLarge: TextStyle(color: AppColors.darkColor),
          //   displayMedium: TextStyle(color: AppColors.darkColor),
          //   displaySmall: TextStyle(color: AppColors.darkColor),
          //   headlineLarge: TextStyle(color: AppColors.darkColor),
          //   headlineMedium: TextStyle(color: AppColors.darkColor),
          //   headlineSmall: TextStyle(color: AppColors.darkColor),
          //   titleLarge: TextStyle(color: AppColors.darkColor),
          //   titleMedium: TextStyle(color: AppColors.darkColor),
          //   titleSmall: TextStyle(color: AppColors.darkColor),
          //   bodyLarge: TextStyle(color: AppColors.darkColor),
          //   bodyMedium: TextStyle(color: AppColors.darkColor),
          //   bodySmall: TextStyle(color: AppColors.darkColor),
          //   labelLarge: TextStyle(color: AppColors.darkColor),
          //   labelMedium: TextStyle(color: AppColors.darkColor),
          //   labelSmall: TextStyle(color: AppColors.darkColor),
          // ),

          // Divider
          dividerTheme: DividerThemeData(
            color: AppColors.lightColor.withValues(alpha: 0.5),
            thickness: 1,
          ),

          // Icon
          iconTheme: IconThemeData(color: AppColors.primaryColor, size: 24),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
