import 'package:equatable/equatable.dart';

/// How many players each side fields; drives the available formations.
enum TeamFormat {
  fiveASide(5),
  sevenASide(7),
  elevenASide(11);

  const TeamFormat(this.playersOnPitch);

  final int playersOnPitch;
}

final class Team extends Equatable {
  const Team({
    this.id,
    required this.name,
    required this.format,
    this.coachName = '',
  });

  /// Null until the team is persisted.
  final int? id;
  final String name;
  final TeamFormat format;
  final String coachName;

  Team copyWith({
    int? id,
    String? name,
    TeamFormat? format,
    String? coachName,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      format: format ?? this.format,
      coachName: coachName ?? this.coachName,
    );
  }

  @override
  List<Object?> get props => [id, name, format, coachName];
}
