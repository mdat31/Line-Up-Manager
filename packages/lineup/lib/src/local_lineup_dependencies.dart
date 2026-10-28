import 'package:lineup/src/core/database/lineup_database.dart';
import 'package:lineup/src/features/export/data/device_image_exporter.dart';
import 'package:lineup/src/features/lineup/data/datasources/lineup_local_data_source.dart';
import 'package:lineup/src/features/lineup/data/repositories/lineup_repository_impl.dart';
import 'package:lineup/src/features/team/data/datasources/team_local_data_source.dart';
import 'package:lineup/src/features/team/data/repositories/team_repository_impl.dart';
import 'package:lineup/src/lineup_dependencies.dart';

/// Composition root for the default, fully offline setup.
abstract final class LocalLineupDependencies {
  static Future<LineupDependencies> open() async {
    final db = await LineupDatabase.open();
    return LineupDependencies(
      teams: TeamRepositoryImpl(TeamLocalDataSource(db)),
      lineups: LineupRepositoryImpl(LineupLocalDataSource(db)),
      exporter: const DeviceImageExporter(),
    );
  }
}
