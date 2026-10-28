import 'package:lineup/src/features/lineup/data/datasources/lineup_local_data_source.dart';
import 'package:lineup/src/features/lineup/data/models/lineup_model.dart';
import 'package:lineup/src/features/lineup/domain/entities/lineup.dart';
import 'package:lineup/src/features/lineup/domain/repositories/lineup_repository.dart';

final class LineupRepositoryImpl implements LineupRepository {
  const LineupRepositoryImpl(this._local);

  final LineupLocalDataSource _local;

  @override
  Future<Lineup?> getLineup(int teamId) async {
    final row = await _local.queryLineup(teamId);
    return row == null ? null : LineupModel.fromMap(row).toEntity();
  }

  @override
  Future<void> saveLineup(Lineup lineup) =>
      _local.upsertLineup(LineupModel.fromEntity(lineup).toMap());
}
