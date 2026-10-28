import 'package:flutter/material.dart';
import 'package:lineup/lineup.dart';

import 'package:marozi/core/theme/app_theme.dart';

/// Standalone shell around the line-up module; a super app would push
/// [LineupKit] from its own navigation instead.
class MaroziApp extends StatelessWidget {
  const MaroziApp({super.key, required this.lineup});

  final LineupDependencies lineup;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marozi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: LineupKit(dependencies: lineup),
    );
  }
}
