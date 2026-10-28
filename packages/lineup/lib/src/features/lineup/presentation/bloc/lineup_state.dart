import 'package:equatable/equatable.dart';
import 'package:lineup/src/features/export/domain/entities/lineup_card.dart';
import 'package:lineup/src/features/lineup/domain/entities/formation.dart';
import 'package:lineup/src/features/lineup/domain/entities/formations.dart';
import 'package:lineup/src/features/lineup/domain/entities/lineup.dart';
import 'package:lineup/src/features/team/domain/entities/player.dart';
import 'package:lineup/src/features/team/domain/entities/team.dart';

sealed class LineupState extends Equatable {
  const LineupState();

  @override
  List<Object?> get props => [];
}

final class LineupLoading extends LineupState {
  const LineupLoading();
}

final class LineupFailure extends LineupState {
  const LineupFailure();
}

final class LineupReady extends LineupState {
  const LineupReady({
    required this.team,
    required this.players,
    required this.lineup,
  });

  final Team team;
  final List<Player> players;
  final Lineup lineup;

  List<Formation> get formations => Formations.forFormat(team.format);

  Player? playerById(int? id) {
    if (id == null) return null;
    for (final p in players) {
      if (p.id == id) return p;
    }
    return null;
  }

  Player? playerAt(int slot) => playerById(lineup.slots[slot].playerId);

  /// Roster order, minus whoever is starting.
  List<Player> get bench {
    final starters = lineup.starterIds;
    return [
      for (final p in players)
        if (!starters.contains(p.id)) p,
    ];
  }

  LineupCard toCard() {
    return LineupCard(
      teamName: team.name,
      coachName: team.coachName,
      formationId: lineup.formationId,
      starters: [
        for (final slot in lineup.slots)
          if (playerById(slot.playerId) case final player?)
            CardPlayer(
              name: player.shortName,
              number: player.number,
              x: slot.position.x,
              y: slot.position.y,
              isCaptain: player.id == lineup.captainId,
            ),
      ],
      substitutes: [for (final p in bench) p.shortName],
    );
  }

  LineupReady withLineup(Lineup lineup) =>
      LineupReady(team: team, players: players, lineup: lineup);

  @override
  List<Object?> get props => [team, players, lineup];
}
