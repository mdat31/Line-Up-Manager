import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lineup/src/features/export/presentation/screens/export_screen.dart';
import 'package:lineup/src/features/lineup/presentation/bloc/lineup_cubit.dart';
import 'package:lineup/src/features/lineup/presentation/bloc/lineup_state.dart';
import 'package:lineup/src/features/lineup/presentation/widgets/bench_bar.dart';
import 'package:lineup/src/features/lineup/presentation/widgets/pitch_board.dart';
import 'package:lineup/src/features/lineup/presentation/widgets/slot_actions_sheet.dart';
import 'package:lineup/src/lineup_scope.dart';

class LineupScreen extends StatelessWidget {
  const LineupScreen({super.key, required this.teamId});

  final int teamId;

  @override
  Widget build(BuildContext context) {
    final deps = LineupScope.of(context);
    return BlocProvider(
      create: (_) => LineupCubit(deps.teams, deps.lineups, teamId)..load(),
      child: const _LineupView(),
    );
  }
}

class _LineupView extends StatelessWidget {
  const _LineupView();

  /// Real pitches are roughly 68 x 105 m; keeping that ratio stops
  /// formations looking squashed on tall phones.
  static const _pitchAspect = 0.68;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LineupCubit, LineupState>(
      builder: (context, state) => switch (state) {
        LineupLoading() => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        LineupFailure() => Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text('Không tải được đội hình')),
        ),
        LineupReady() => Scaffold(
          appBar: _appBar(context, state),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: _pitchAspect,
                      child: PitchBoard(
                        state: state,
                        onTapSlot: (slot) => showSlotActions(
                          context,
                          cubit: context.read<LineupCubit>(),
                          state: state,
                          slot: slot,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(top: false, child: BenchBar(bench: state.bench)),
            ],
          ),
        ),
      },
    );
  }

  PreferredSizeWidget _appBar(BuildContext context, LineupReady state) {
    final cubit = context.read<LineupCubit>();
    return AppBar(
      title: Text(state.team.name),
      actions: [
        PopupMenuButton<String>(
          tooltip: 'Sơ đồ',
          initialValue: state.lineup.formationId,
          onSelected: (id) => cubit.changeFormation(
            state.formations.firstWhere((f) => f.id == id),
          ),
          itemBuilder: (_) => [
            for (final f in state.formations)
              PopupMenuItem(value: f.id, child: Text(f.id)),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Text(state.lineup.formationId),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        IconButton(
          tooltip: 'Xếp lại tự động',
          icon: const Icon(Icons.restart_alt),
          onPressed: cubit.reset,
        ),
        IconButton(
          tooltip: 'Xuất ảnh',
          icon: const Icon(Icons.ios_share),
          onPressed: () => Navigator.of(context).push(
            LineupScope.route<void>(
              context,
              (_) => ExportScreen(card: state.toCard()),
            ),
          ),
        ),
      ],
    );
  }
}
