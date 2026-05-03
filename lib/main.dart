import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/screens/splash_screen.dart';
import 'package:habit_tracker/logic/mood_logic.dart';
import 'package:habit_tracker/logic/sleep_logic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoodLogic()),
        ChangeNotifierProvider(create: (_) => SleepLogic()),
      ],
      child: MaterialApp(
        title: 'RutinKu',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}