import 'dart:convert';

import 'package:lineup/src/features/lineup/domain/entities/formation.dart';
import 'package:lineup/src/features/lineup/domain/entities/lineup.dart';

/// Row shape of the `lineups` table; slots are stored as a JSON array
/// because they are always read and written as a whole.
final class LineupModel {
  const LineupModel({
    required this.teamId,
    required this.formationId,
    required this.slotsJson,
    this.captainId,
  });

  factory LineupModel.fromMap(Map<String, Object?> map) => LineupModel(
    teamId: map['team_id'] as int,
    formationId: map['formation_id'] as String,
    slotsJson: map['slots'] as String,
    captainId: map['captain_id'] as int?,
  );

  factory LineupModel.fromEntity(Lineup lineup) => LineupModel(
    teamId: lineup.teamId,
    formationId: lineup.formationId,
    captainId: lineup.captainId,
    slotsJson: jsonEncode([
      for (final s in lineup.slots)
        {'x': s.position.x, 'y': s.position.y, 'p': s.playerId},
    ]),
  );

  final int teamId;
  final String formationId;
  final String slotsJson;
  final int? captainId;

  Map<String, Object?> toMap() => {
    'team_id': teamId,
    'formation_id': formationId,
    'slots': slotsJson,
    'captain_id': captainId,
  };

  Lineup toEntity() {
    final raw = jsonDecode(slotsJson) as List<Object?>;
    return Lineup(
      teamId: teamId,
      formationId: formationId,
      captainId: captainId,
      slots: [
        for (final item in raw.cast<Map<String, Object?>>())
          LineupSlot(
            position: SlotPosition(
              (item['x'] as num).toDouble(),
              (item['y'] as num).toDouble(),
            ),
            playerId: item['p'] as int?,
          ),
      ],
    );
  }
}
