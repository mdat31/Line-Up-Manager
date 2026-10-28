import 'package:equatable/equatable.dart';
import 'package:lineup/src/features/team/domain/entities/player.dart';
import 'package:lineup/src/features/team/domain/entities/team.dart';
import 'package:lineup/src/features/team/presentation/team_list/team_list_state.dart';

final class TeamDetailState extends Equatable {
  const TeamDetailState({
    this.status = LoadStatus.loading,
    this.team,
    this.players = const [],
  });

  final LoadStatus status;
  final Team? team;
  final List<Player> players;

  TeamDetailState copyWith({
    LoadStatus? status,
    Team? team,
    List<Player>? players,
  }) {
    return TeamDetailState(
      status: status ?? this.status,
      team: team ?? this.team,
      players: players ?? this.players,
    );
  }

  @override
  List<Object?> get props => [status, team, players];
}
