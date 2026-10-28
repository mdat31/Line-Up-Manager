import 'package:lineup/src/features/lineup/domain/entities/formation.dart';
import 'package:lineup/src/features/team/domain/entities/team.dart';

/// Formations offered per format; the first entry is the default.
abstract final class Formations {
  static final Map<TeamFormat, List<Formation>> _byFormat = {
    TeamFormat.fiveASide: _build(TeamFormat.fiveASide, const [
      [1, 2, 1],
      [2, 2],
      [3, 1],
      [2, 1, 1],
    ]),
    TeamFormat.sevenASide: _build(TeamFormat.sevenASide, const [
      [2, 3, 1],
      [3, 2, 1],
      [3, 1, 2],
      [2, 2, 2],
    ]),
    TeamFormat.elevenASide: _build(TeamFormat.elevenASide, const [
      [4, 4, 2],
      [4, 3, 3],
      [4, 2, 3, 1],
      [3, 5, 2],
      [3, 4, 3],
      [5, 3, 2],
    ]),
  };

  static List<Formation> _build(TeamFormat format, List<List<int>> lines) => [
    for (final l in lines) Formation.fromLines(format, l),
  ];

  static List<Formation> forFormat(TeamFormat format) => _byFormat[format]!;

  static Formation defaultFor(TeamFormat format) => forFormat(format).first;

  static Formation? find(TeamFormat format, String id) {
    for (final f in forFormat(format)) {
      if (f.id == id) return f;
    }
    return null;
  }
}
