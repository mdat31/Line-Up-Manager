import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lineup/lineup.dart';
import 'package:lineup/src/features/lineup/presentation/screens/lineup_screen.dart';
import 'package:lineup/src/features/lineup/presentation/widgets/bench_bar.dart';
import 'package:lineup/src/features/lineup/presentation/widgets/pitch_board.dart';
import 'package:lineup/src/lineup_scope.dart';

import '../../../helpers/fakes.dart';

void main() {
  late InMemoryTeamRepository teams;
  late InMemoryLineupRepository lineups;
  late Team team;
  late Map<String, Player> byShortName;

  setUp(() async {
    teams = InMemoryTeamRepository();
    lineups = InMemoryLineupRepository();
    final (seededTeam, players) = await seedFiveASide(teams);
    team = seededTeam;
    byShortName = {for (final p in players) p.shortName: p};
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(1170, 2532)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: LineupScope(
          dependencies: LineupDependencies(
            teams: teams,
            lineups: lineups,
            exporter: MockImageExporter(),
          ),
          child: LineupScreen(teamId: team.id!),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> drag(WidgetTester tester, Finder from, Offset to) async {
    final gesture = await tester.startGesture(tester.getCenter(from));
    await gesture.moveBy(const Offset(0, 24));
    await tester.pump();
    await gesture.moveTo(to);
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
  }

  Lineup saved() => lineups.lineups[team.id]!;

  int slotOf(String shortName) =>
      saved().slots.indexWhere((s) => s.playerId == byShortName[shortName]!.id);

  Finder onPitch(String name) =>
      find.descendant(of: find.byType(PitchBoard), matching: find.text(name));

  testWidgets('token onto token swaps the two players', (tester) async {
    await pumpScreen(tester);
    final keeperSlot = slotOf('An');
    final strikerSlot = slotOf('Em');

    await drag(tester, onPitch('An'), tester.getCenter(onPitch('Em')));

    expect(slotOf('An'), strikerSlot);
    expect(slotOf('Em'), keeperSlot);
  });

  testWidgets('token onto empty grass moves it under the finger', (
    tester,
  ) async {
    await pumpScreen(tester);
    final pitch = tester.getRect(find.byType(PitchBoard));
    final slot = slotOf('Bình');
    final target =
        pitch.topLeft + Offset(pitch.width * 0.2, pitch.height * 0.3);

    await drag(tester, onPitch('Bình'), target);

    // The disc, not the name label, lands under the finger.
    final position = saved().slots[slot].position;
    expect(slotOf('Bình'), slot);
    expect(position.x, closeTo(0.2, 0.02));
    expect(position.y, closeTo(0.3, 0.02));
  });

  testWidgets('dragging off the pitch edge keeps the token inside', (
    tester,
  ) async {
    await pumpScreen(tester);
    final pitch = tester.getRect(find.byType(PitchBoard));

    await drag(tester, onPitch('Bình'), pitch.topLeft + const Offset(2, 2));

    final position = saved().slots[slotOf('Bình')].position;
    expect(position.x * pitch.width, greaterThanOrEqualTo(37));
    expect(position.y * pitch.height, greaterThanOrEqualTo(21));
  });

  testWidgets('starter onto the bench is substituted off', (tester) async {
    await pumpScreen(tester);
    expect(find.text('DỰ BỊ (2)'), findsOneWidget);

    await drag(
      tester,
      onPitch('Cường'),
      tester.getCenter(find.byType(BenchBar)),
    );

    expect(slotOf('Cường'), -1);
    expect(find.text('DỰ BỊ (3)'), findsOneWidget);
  });

  testWidgets('bench player onto a token replaces that starter', (
    tester,
  ) async {
    await pumpScreen(tester);
    final slot = slotOf('Em');
    final sub = find.descendant(
      of: find.byType(BenchBar),
      matching: find.text('Phong'),
    );

    await drag(tester, sub, tester.getCenter(onPitch('Em')));

    expect(slotOf('Phong'), slot);
    expect(slotOf('Em'), -1);
    expect(
      find.descendant(of: find.byType(BenchBar), matching: find.text('Em')),
      findsOneWidget,
    );
  });

  testWidgets('tap a token to make them captain', (tester) async {
    await pumpScreen(tester);

    await tester.tap(onPitch('An'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Đặt An làm đội trưởng'));
    await tester.pumpAndSettle();

    expect(saved().captainId, byShortName['An']!.id);
    expect(onPitch('C'), findsOneWidget);
  });
}
