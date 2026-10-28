import 'package:equatable/equatable.dart';

/// Declared from back to front: auto-fill measures how close two roles are
/// by their distance in this order.
enum PlayerPosition { goalkeeper, defender, midfielder, forward }

final class Player extends Equatable {
  const Player({
    this.id,
    required this.teamId,
    required this.name,
    this.number,
    this.position = PlayerPosition.midfielder,
  });

  /// Null until the player is persisted.
  final int? id;
  final int teamId;
  final String name;
  final int? number;
  final PlayerPosition position;

  /// Short label for crowded places such as pitch tokens: the last word,
  /// since Vietnamese and most European names put the given name there.
  String get shortName {
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? name : parts.last;
  }

  Player copyWith({
    int? id,
    String? name,
    int? number,
    bool clearNumber = false,
    PlayerPosition? position,
  }) {
    return Player(
      id: id ?? this.id,
      teamId: teamId,
      name: name ?? this.name,
      number: clearNumber ? null : number ?? this.number,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [id, teamId, name, number, position];
}
