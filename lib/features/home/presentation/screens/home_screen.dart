import 'package:flutter/material.dart';

/// Placeholder entry screen until the line-up features are ported.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marozi')),
      body: Center(child: Image.asset('assets/images/logo.png', width: 160)),
    );
  }
}
