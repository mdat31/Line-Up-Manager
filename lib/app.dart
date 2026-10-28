import 'package:flutter/material.dart';

import 'package:marozi/core/theme/app_theme.dart';
import 'package:marozi/features/home/presentation/screens/home_screen.dart';

class MaroziApp extends StatelessWidget {
  const MaroziApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marozi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
