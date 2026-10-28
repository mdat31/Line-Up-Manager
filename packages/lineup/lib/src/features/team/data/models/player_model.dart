import 'package:lineup/src/features/team/domain/entities/player.dart';

/// Row shape of the `players` table.
final class PlayerModel {
  const PlayerModel({
    this.id,
    required this.teamId,
    required this.name,
    this.number,
    required this.position,
  });

  factory PlayerModel.fromMap(Map<String, Object?> map) => PlayerModel(
    id: map['id'] as int?,
    teamId: map['team_id'] as int,
    name: map['name'] as String,
    number: map['number'] as int?,
    position: map['position'] as String,
  );

  factory PlayerModel.fromEntity(Player player) => PlayerModel(
    id: player.id,
    teamId: player.teamId,
    name: player.name,
    number: player.number,
    position: player.position.name,
  );

  final int? id;
  final int teamId;
  final String name;
  final int? number;
  final String position;

  Map<String, Object?> toMap() => {
    'id': ?id,
    'team_id': teamId,
    'name': name,
    'number': number,
    'position': position,
  };

  Player toEntity() => Player(
    id: id,
    teamId: teamId,
    name: name,
    number: number,
    position:
        PlayerPosition.values.asNameMap()[position] ??
        PlayerPosition.midfielder,
  );
}
