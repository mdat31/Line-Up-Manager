import 'dart:typed_data';

import 'package:lineup/lineup.dart';
import 'package:mocktail/mocktail.dart';

class InMemoryTeamRepository implements TeamRepository {
  final Map<int, Team> teams = {};
  final Map<int, Player> players = {};
  int _nextId = 1;

  @override
  Future<List<Team>> getTeams() async => teams.values.toList();

  @override
  Future<Team?> getTeam(int id) async => teams[id];

  @override
  Future<Team> saveTeam(Team team) async {
    final saved = team.id == null ? team.copyWith(id: _nextId++) : team;
    teams[saved.id!] = saved;
    return saved;
  }

  @override
  Future<void> deleteTeam(int id) async {
    teams.remove(id);
    players.removeWhere((_, p) => p.teamId == id);
  }

  @override
  Future<List<Player>> getPlayers(int teamId) async =>
      players.values.where((p) => p.teamId == teamId).toList();

  @override
  Future<Player> savePlayer(Player player) async {
    final saved = player.id == null ? player.copyWith(id: _nextId++) : player;
    players[saved.id!] = saved;
    return saved;
  }

  @override
  Future<void> deletePlayer(int id) async => players.remove(id);
}

class InMemoryLineupRepository implements LineupRepository {
  final Map<int, Lineup> lineups = {};
  int saves = 0;

  @override
  Future<Lineup?> getLineup(int teamId) async => lineups[teamId];

  @override
  Future<void> saveLineup(Lineup lineup) async {
    saves++;
    lineups[lineup.teamId] = lineup;
  }
}

class MockImageExporter extends Mock implements ImageExporter {}

void registerFallbacks() => registerFallbackValue(Uint8List(0));

/// A 5-a-side team with one player per role plus two subs.
Future<(Team, List<Player>)> seedFiveASide(InMemoryTeamRepository repo) async {
  final team = await repo.saveTeam(
    const Team(name: 'FC Phủi', format: TeamFormat.fiveASide),
  );
  final specs = [
    ('Nguyễn Văn An', 1, PlayerPosition.goalkeeper),
    ('Trần Bình', 4, PlayerPosition.defender),
    ('Lê Cường', 8, PlayerPosition.midfielder),
    ('Phạm Dũng', 6, PlayerPosition.midfielder),
    ('Hoàng Em', 9, PlayerPosition.forward),
    ('Vũ Phong', 10, PlayerPosition.forward),
    ('Đỗ Giang', 12, PlayerPosition.defender),
  ];
  final players = [
    for (final (name, number, position) in specs)
      await repo.savePlayer(
        Player(
          teamId: team.id!,
          name: name,
          number: number,
          position: position,
        ),
      ),
  ];
  return (team, players);
}
