import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'services/goal_service.dart';
import 'services/calendar_service.dart';
import 'services/user_profile_service.dart';
import 'screens/home_screen.dart';
import 'screens/settings/payment_methods_screen.dart';
import 'screens/settings/billing_subscriptions_screen.dart';
import 'screens/settings/account_security_screen.dart';
import 'screens/settings/app_appearance_screen.dart';
import 'screens/settings/data_analytics_screen.dart';
import 'screens/settings/rate_app_screen.dart';
// import 'screens/settings/follow_instagram_screen.dart';
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
      ],
      child: ToastificationWrapper(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'HabitoX',
          theme: ThemeData(
          useMaterial3: true,
          primaryColor: AppColors.primaryColor,
          scaffoldBackgroundColor: AppColors.lightColor.withValues(alpha: 0.15),

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
          iconTheme: IconThemeData(color: AppColors.primaryColor, size: 24),
        ),
        home: const HomeScreen(),
        routes: {
          '/payment_methods': (context) => const PaymentMethodsScreen(),
          '/billing_subscriptions': (context) =>
              const BillingSubscriptionsScreen(),
          '/account_security': (context) => const AccountSecurityScreen(),
          '/app_appearance': (context) => const AppAppearanceScreen(),
          '/data_analytics': (context) => const DataAnalyticsScreen(),
          '/rate_app': (context) => const RateAppScreen(),
          // '/follow_instagram': (context) => const FollowInstagramScreen(),
          '/app_updates': (context) => const AppUpdatesScreen(),
        },
        ),
      ),
    );
  }
}
