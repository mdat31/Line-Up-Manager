import 'package:equatable/equatable.dart';
import 'package:lineup/src/features/team/domain/entities/player.dart';
import 'package:lineup/src/features/team/domain/entities/team.dart';

/// A point on the pitch, normalised to 0..1 so it is independent of the
/// rendered size. y = 0 is the attacking end, y = 1 the own goal line.
final class SlotPosition extends Equatable {
  const SlotPosition(this.x, this.y);

  final double x;
  final double y;

  SlotPosition clamped() => SlotPosition(x.clamp(0.0, 1.0), y.clamp(0.0, 1.0));

  double distanceSquaredTo(SlotPosition other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return dx * dx + dy * dy;
  }

  @override
  List<Object?> get props => [x, y];
}

final class Formation extends Equatable {
  const Formation({
    required this.id,
    required this.format,
    required this.positions,
    required this.roles,
  });

  /// Builds a formation from outfield lines listed defence first, e.g.
  /// `[4, 2, 3, 1]`. Slot 0 is always the goalkeeper.
  factory Formation.fromLines(TeamFormat format, List<int> lines) {
    const goalkeeperY = 0.9;
    const backLineY = 0.72;
    const frontLineY = 0.16;
    final positions = <SlotPosition>[const SlotPosition(0.5, goalkeeperY)];
    final roles = <PlayerPosition>[PlayerPosition.goalkeeper];
    for (var i = 0; i < lines.length; i++) {
      final y = lines.length == 1
          ? (backLineY + frontLineY) / 2
          : backLineY - i * (backLineY - frontLineY) / (lines.length - 1);
      final count = lines[i];
      for (var j = 0; j < count; j++) {
        final x = count == 1 ? 0.5 : 0.14 + 0.72 * j / (count - 1);
        positions.add(SlotPosition(x, y));
        roles.add(_roleOfLine(i, lines.length));
      }
    }
    return Formation(
      id: lines.join('-'),
      format: format,
      positions: positions,
      roles: roles,
    );
  }

  /// Back line defends, front line attacks, everything between is midfield.
  static PlayerPosition _roleOfLine(int line, int lineCount) {
    if (line == 0 && lineCount > 1) return PlayerPosition.defender;
    if (line == lineCount - 1) return PlayerPosition.forward;
    return PlayerPosition.midfielder;
  }

  /// Display name such as `4-2-3-1`.
  final String id;
  final TeamFormat format;
  final List<SlotPosition> positions;

  /// Intended role per slot, parallel to [positions].
  final List<PlayerPosition> roles;

  @override
  List<Object?> get props => [id, format, positions, roles];
}
