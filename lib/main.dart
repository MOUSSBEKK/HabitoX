import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/goal_service.dart';
import 'services/calendar_service.dart';
import 'screens/home_screen.dart';

void main() {
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HabitoX',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            foregroundColor: Colors.indigo,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
