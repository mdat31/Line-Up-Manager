import 'package:equatable/equatable.dart';
import 'package:lineup/src/features/lineup/domain/entities/formation.dart';

final class LineupSlot extends Equatable {
  const LineupSlot({required this.position, this.playerId});

  final SlotPosition position;

  /// Null for an empty slot.
  final int? playerId;

  LineupSlot copyWith({
    SlotPosition? position,
    int? playerId,
    bool clear = false,
  }) {
    return LineupSlot(
      position: position ?? this.position,
      playerId: clear ? null : playerId ?? this.playerId,
    );
  }

  @override
  List<Object?> get props => [position, playerId];
}

/// The starting line-up of one team; players not in [slots] are substitutes.
final class Lineup extends Equatable {
  const Lineup({
    required this.teamId,
    required this.formationId,
    required this.slots,
    this.captainId,
  });

  final int teamId;
  final String formationId;
  final List<LineupSlot> slots;
  final int? captainId;

  Set<int> get starterIds => {for (final s in slots) ?s.playerId};

  Lineup copyWith({
    String? formationId,
    List<LineupSlot>? slots,
    int? captainId,
    bool clearCaptain = false,
  }) {
    return Lineup(
      teamId: teamId,
      formationId: formationId ?? this.formationId,
      slots: slots ?? this.slots,
      captainId: clearCaptain ? null : captainId ?? this.captainId,
    );
  }

  @override
  List<Object?> get props => [teamId, formationId, slots, captainId];
}
