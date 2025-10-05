import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:insulin/config/firebase_options.dart';

import 'package:insulin/providers/insulin_provider.dart';
import 'package:insulin/providers/preset_bolus_provider.dart';
import 'package:insulin/providers/theme_provider.dart';
import 'package:insulin/providers/timer_provider.dart';

import 'package:insulin/ui/pages/landing_page.dart';
import 'package:insulin/ui/theme/theme.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => InsulinProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TimerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PresetBolusProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder:  (context, themeProvider, child) {
        return MaterialApp(
          title: 'Insulin',
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData(
            colorScheme: MaterialTheme.darkScheme(),
            useMaterial3: true,
          ),
          theme: ThemeData(
            colorScheme: MaterialTheme.lightScheme(),
            useMaterial3: true,
          ),
          themeMode: themeProvider.isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
          home: const LandingPage(),
        );
      }
    );
  }
}
