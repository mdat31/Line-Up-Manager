import 'package:equatable/equatable.dart';
import 'package:lineup/src/features/team/domain/entities/team.dart';

enum LoadStatus { loading, ready, failure }

final class TeamListState extends Equatable {
  const TeamListState({
    this.status = LoadStatus.loading,
    this.teams = const [],
  });

  final LoadStatus status;
  final List<Team> teams;

  TeamListState copyWith({LoadStatus? status, List<Team>? teams}) {
    return TeamListState(
      status: status ?? this.status,
      teams: teams ?? this.teams,
    );
  }

  @override
  List<Object?> get props => [status, teams];
}
