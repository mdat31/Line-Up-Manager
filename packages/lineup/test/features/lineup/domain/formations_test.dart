import 'package:flutter_test/flutter_test.dart';
import 'package:lineup/src/features/lineup/domain/entities/formations.dart';
import 'package:lineup/src/features/team/domain/entities/team.dart';

void main() {
  for (final format in TeamFormat.values) {
    group(format.name, () {
      test('every formation fills exactly the players on pitch', () {
        for (final f in Formations.forFormat(format)) {
          expect(f.positions, hasLength(format.playersOnPitch), reason: f.id);
        }
      });

      test('positions stay on the pitch and goalkeeper is deepest', () {
        for (final f in Formations.forFormat(format)) {
          for (final p in f.positions) {
            expect(p.x, inInclusiveRange(0, 1));
            expect(p.y, inInclusiveRange(0, 1));
          }
          final keeperY = f.positions.first.y;
          expect(f.positions.skip(1).every((p) => p.y < keeperY), isTrue);
        }
      });
    });
  }

  test('roles follow the lines: keeper, back line, midfield, front line', () {
    final f = Formations.find(TeamFormat.elevenASide, '4-2-3-1')!;
    expect(f.roles.map((r) => r.name), [
      'goalkeeper',
      ...List.filled(4, 'defender'),
      ...List.filled(5, 'midfielder'),
      'forward',
    ]);
    expect(f.roles, hasLength(f.positions.length));
  });

  test('ids read like football notation', () {
    expect(
      Formations.forFormat(TeamFormat.elevenASide).map((f) => f.id),
      contains('4-2-3-1'),
    );
    expect(Formations.defaultFor(TeamFormat.fiveASide).id, '1-2-1');
    expect(Formations.find(TeamFormat.sevenASide, 'nope'), isNull);
  });
}
