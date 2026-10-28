import 'package:equatable/equatable.dart';

/// Everything an export template needs, decoupled from roster storage.
final class CardPlayer extends Equatable {
  const CardPlayer({
    required this.name,
    required this.x,
    required this.y,
    this.number,
    this.isCaptain = false,
  });

  final String name;
  final int? number;

  /// Normalised pitch coordinates, same convention as the line-up editor.
  final double x;
  final double y;
  final bool isCaptain;

  @override
  List<Object?> get props => [name, number, x, y, isCaptain];
}

final class LineupCard extends Equatable {
  const LineupCard({
    required this.teamName,
    required this.formationId,
    required this.starters,
    this.coachName = '',
    this.substitutes = const [],
  });

  final String teamName;
  final String coachName;
  final String formationId;
  final List<CardPlayer> starters;
  final List<String> substitutes;

  @override
  List<Object?> get props => [
    teamName,
    coachName,
    formationId,
    starters,
    substitutes,
  ];
}
