import 'package:lineup/src/features/export/domain/repositories/image_exporter.dart';
import 'package:lineup/src/features/lineup/domain/repositories/lineup_repository.dart';
import 'package:lineup/src/features/team/domain/repositories/team_repository.dart';

/// Everything the module needs from its host. Use
/// `LocalLineupDependencies.open()` for the built-in on-device storage, or
/// pass host implementations (e.g. a roster synced with a backend).
final class LineupDependencies {
  const LineupDependencies({
    required this.teams,
    required this.lineups,
    required this.exporter,
  });

  final TeamRepository teams;
  final LineupRepository lineups;
  final ImageExporter exporter;
}
