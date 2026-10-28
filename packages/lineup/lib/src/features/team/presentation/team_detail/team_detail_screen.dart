import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lineup/src/features/lineup/presentation/screens/lineup_screen.dart';
import 'package:lineup/src/features/team/domain/entities/player.dart';
import 'package:lineup/src/features/team/presentation/team_detail/player_form_dialog.dart';
import 'package:lineup/src/features/team/presentation/team_detail/team_detail_cubit.dart';
import 'package:lineup/src/features/team/presentation/team_detail/team_detail_state.dart';
import 'package:lineup/src/features/team/presentation/team_labels.dart';
import 'package:lineup/src/features/team/presentation/team_list/team_form_dialog.dart';
import 'package:lineup/src/features/team/presentation/team_list/team_list_state.dart';
import 'package:lineup/src/lineup_scope.dart';

class TeamDetailScreen extends StatelessWidget {
  const TeamDetailScreen({super.key, required this.teamId});

  final int teamId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TeamDetailCubit(LineupScope.of(context).teams, teamId)..load(),
      child: const _TeamDetailView(),
    );
  }
}

class _TeamDetailView extends StatelessWidget {
  const _TeamDetailView();

  Future<void> _editPlayer(BuildContext context, Player player) async {
    final cubit = context.read<TeamDetailCubit>();
    final edited = await PlayerFormDialog.show(context, player);
    if (edited != null) await cubit.savePlayer(edited);
  }

  Future<void> _editTeam(BuildContext context, TeamDetailState state) async {
    final cubit = context.read<TeamDetailCubit>();
    final edited = await TeamFormDialog.show(context, initial: state.team);
    if (edited != null) await cubit.saveTeam(edited);
  }

  Future<void> _openLineup(BuildContext context) async {
    final cubit = context.read<TeamDetailCubit>();
    await Navigator.of(context).push(
      LineupScope.route<void>(
        context,
        (_) => LineupScreen(teamId: cubit.teamId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamDetailCubit, TeamDetailState>(
      builder: (context, state) {
        final team = state.team;
        return Scaffold(
          appBar: AppBar(
            title: Text(team?.name ?? ''),
            actions: [
              if (team != null)
                IconButton(
                  tooltip: 'Sửa đội',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _editTeam(context, state),
                ),
            ],
          ),
          floatingActionButton: team == null
              ? null
              : FloatingActionButton(
                  tooltip: 'Thêm cầu thủ',
                  onPressed: () =>
                      _editPlayer(context, Player(teamId: team.id!, name: '')),
                  child: const Icon(Icons.person_add_alt_1),
                ),
          bottomNavigationBar: team == null
              ? null
              : SafeArea(
                  minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: FilledButton.icon(
                    onPressed: () => _openLineup(context),
                    icon: const Icon(Icons.sports_soccer),
                    label: Text('Xếp đội hình ${team.format.label}'),
                  ),
                ),
          body: switch (state.status) {
            LoadStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            LoadStatus.failure => const Center(
              child: Text('Không tìm thấy đội'),
            ),
            LoadStatus.ready => _Roster(
              players: state.players,
              onEdit: (p) => _editPlayer(context, p),
            ),
          },
        );
      },
    );
  }
}

class _Roster extends StatelessWidget {
  const _Roster({required this.players, required this.onEdit});

  final List<Player> players;
  final ValueChanged<Player> onEdit;

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) {
      return const Center(child: Text('Chưa có cầu thủ. Bấm + để thêm.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: players.length,
      itemBuilder: (context, i) {
        final player = players[i];
        return ListTile(
          leading: CircleAvatar(child: Text(player.number?.toString() ?? '-')),
          title: Text(player.name),
          subtitle: Text(player.position.label),
          onTap: () => onEdit(player),
          trailing: IconButton(
            tooltip: 'Xoá',
            icon: const Icon(Icons.delete_outline),
            onPressed: () =>
                context.read<TeamDetailCubit>().deletePlayer(player),
          ),
        );
      },
    );
  }
}
