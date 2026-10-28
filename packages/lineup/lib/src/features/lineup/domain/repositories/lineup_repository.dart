import 'package:lineup/src/features/lineup/domain/entities/lineup.dart';

abstract interface class LineupRepository {
  /// Null when the team has no saved line-up yet.
  Future<Lineup?> getLineup(int teamId);

  Future<void> saveLineup(Lineup lineup);
}
