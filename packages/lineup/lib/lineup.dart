/// Line-up manager module: teams, drag-and-drop pitch and image export.
///
/// ```dart
/// final deps = await LocalLineupDependencies.open();
/// Navigator.of(context).push(
///   MaterialPageRoute(builder: (_) => LineupKit(dependencies: deps)),
/// );
/// ```
library;

export 'src/features/export/domain/repositories/image_exporter.dart';
export 'src/features/lineup/domain/entities/lineup.dart';
export 'src/features/lineup/domain/repositories/lineup_repository.dart';
export 'src/features/team/domain/entities/player.dart';
export 'src/features/team/domain/entities/team.dart';
export 'src/features/team/domain/repositories/team_repository.dart';
export 'src/lineup_dependencies.dart';
export 'src/lineup_kit.dart';
export 'src/local_lineup_dependencies.dart';
