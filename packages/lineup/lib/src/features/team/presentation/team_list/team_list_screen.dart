import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lineup/src/features/team/domain/entities/team.dart';
import 'package:lineup/src/features/team/presentation/team_detail/team_detail_screen.dart';
import 'package:lineup/src/features/team/presentation/team_labels.dart';
import 'package:lineup/src/features/team/presentation/team_list/team_form_dialog.dart';
import 'package:lineup/src/features/team/presentation/team_list/team_list_cubit.dart';
import 'package:lineup/src/features/team/presentation/team_list/team_list_state.dart';
import 'package:lineup/src/lineup_scope.dart';

class TeamListScreen extends StatelessWidget {
  const TeamListScreen({super.key});

  Future<void> _create(BuildContext context) async {
    final cubit = context.read<TeamListCubit>();
    final team = await TeamFormDialog.show(context);
    if (team == null) return;
    final saved = await cubit.save(team);
    if (!context.mounted) return;
    await _open(context, saved);
  }

  Future<void> _open(BuildContext context, Team team) async {
    final cubit = context.read<TeamListCubit>();
    await Navigator.of(context).push(
      LineupScope.route<void>(
        context,
        (_) => TeamDetailScreen(teamId: team.id!),
      ),
    );
    await cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đội của tôi')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _create(context),
        icon: const Icon(Icons.add),
        label: const Text('Tạo đội'),
      ),
      body: BlocBuilder<TeamListCubit, TeamListState>(
        builder: (context, state) => switch (state.status) {
          LoadStatus.loading => const Center(
            child: CircularProgressIndicator(),
          ),
          LoadStatus.failure => const Center(
            child: Text('Không tải được danh sách đội'),
          ),
          LoadStatus.ready when state.teams.isEmpty => const _EmptyTeams(),
          LoadStatus.ready => ListView.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: state.teams.length,
            itemBuilder: (context, i) => _TeamTile(
              team: state.teams[i],
              onTap: () => _open(context, state.teams[i]),
            ),
          ),
        },
      ),
    );
  }
}

class _TeamTile extends StatelessWidget {
  const _TeamTile({required this.team, required this.onTap});

  final Team team;
  final VoidCallback onTap;

  Future<bool> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Xoá ${team.name}?'),
        content: const Text('Toàn bộ cầu thủ và đội hình của đội sẽ bị xoá.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(team.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Icon(Icons.delete_outline),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => context.read<TeamListCubit>().delete(team),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(team.format.playersOnPitch.toString()),
        ),
        title: Text(team.name),
        subtitle: Text(
          [
            team.format.label,
            if (team.coachName.isNotEmpty) team.coachName,
          ].join(' · '),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _EmptyTeams extends StatelessWidget {
  const _EmptyTeams();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sports_soccer,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Chưa có đội nào.\nTạo đội sân 5, sân 7 hoặc sân 11 để bắt đầu.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
