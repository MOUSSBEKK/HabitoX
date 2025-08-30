import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'services/goal_service.dart';
import 'services/calendar_service.dart';
import 'services/user_profile_service.dart';
import 'screens/home_screen.dart';
import 'constants/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
