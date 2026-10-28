import 'package:lineup/src/features/team/domain/entities/team.dart';

/// Row shape of the `teams` table.
final class TeamModel {
  const TeamModel({
    this.id,
    required this.name,
    required this.format,
    required this.coachName,
  });

  factory TeamModel.fromMap(Map<String, Object?> map) => TeamModel(
    id: map['id'] as int?,
    name: map['name'] as String,
    format: map['format'] as String,
    coachName: (map['coach_name'] as String?) ?? '',
  );

  factory TeamModel.fromEntity(Team team) => TeamModel(
    id: team.id,
    name: team.name,
    format: team.format.name,
    coachName: team.coachName,
  );

  final int? id;
  final String name;
  final String format;
  final String coachName;

  Map<String, Object?> toMap() => {
    'id': ?id,
    'name': name,
    'format': format,
    'coach_name': coachName,
  };

  Team toEntity() => Team(
    id: id,
    name: name,
    format: TeamFormat.values.asNameMap()[format] ?? TeamFormat.sevenASide,
    coachName: coachName,
  );
}
