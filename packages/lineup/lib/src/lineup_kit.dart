import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lineup/src/features/team/presentation/team_list/team_list_cubit.dart';
import 'package:lineup/src/features/team/presentation/team_list/team_list_screen.dart';
import 'package:lineup/src/lineup_dependencies.dart';
import 'package:lineup/src/lineup_scope.dart';

/// Entry point of the module: the team list. Push it from any host route,
/// or use it as `home` in a standalone app.
class LineupKit extends StatelessWidget {
  const LineupKit({super.key, required this.dependencies});

  final LineupDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return LineupScope(
      dependencies: dependencies,
      child: BlocProvider(
        create: (_) => TeamListCubit(dependencies.teams)..load(),
        child: const TeamListScreen(),
      ),
    );
  }
}
