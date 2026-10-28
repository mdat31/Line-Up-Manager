import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lineup/lineup.dart';
import 'package:lineup/src/features/lineup/presentation/widgets/pitch_board.dart';

import '../../../helpers/fakes.dart';

void main() {
  late InMemoryTeamRepository teams;

  setUp(() => teams = InMemoryTeamRepository());

  Future<void> pumpKit(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(1170, 2532)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: LineupKit(
          dependencies: LineupDependencies(
            teams: teams,
            lineups: InMemoryLineupRepository(),
            exporter: MockImageExporter(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('create a team, add a player, open the pitch', (tester) async {
    await pumpKit(tester);
    expect(find.textContaining('Chưa có đội nào'), findsOneWidget);

    await tester.tap(find.text('Tạo đội'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lưu'));
    await tester.pump();
    expect(find.text('Nhập tên đội'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'FC Phủi');
    await tester.tap(find.text('Sân 5'));
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();

    expect(find.text('FC Phủi'), findsOneWidget);
    expect(teams.teams.values.single.format, TeamFormat.fiveASide);

    await tester.tap(find.byTooltip('Thêm cầu thủ'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Nguyễn Văn An');
    await tester.enterText(find.byType(TextFormField).at(1), '1a');
    await tester.tap(find.byType(DropdownButtonFormField<PlayerPosition>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Thủ môn').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();

    final player = teams.players.values.single;
    expect(player.number, 1);
    expect(player.position, PlayerPosition.goalkeeper);
    expect(find.text('Nguyễn Văn An'), findsOneWidget);

    await tester.tap(find.text('Xếp đội hình Sân 5'));
    await tester.pumpAndSettle();
    expect(find.byType(PitchBoard), findsOneWidget);
    expect(find.text('1-2-1'), findsOneWidget);
  });

  testWidgets('edit and delete from the lists', (tester) async {
    final (team, _) = await seedFiveASide(teams);
    await pumpKit(tester);

    await tester.drag(find.text('FC Phủi'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Huỷ'));
    await tester.pumpAndSettle();
    expect(teams.teams, contains(team.id));

    await tester.tap(find.text('FC Phủi'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Sửa đội'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'FC Phủi 2');
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();
    expect(find.text('FC Phủi 2'), findsOneWidget);

    await tester.tap(find.byTooltip('Xoá').first);
    await tester.pumpAndSettle();
    expect(teams.players, hasLength(6));

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.drag(find.text('FC Phủi 2'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xoá'));
    await tester.pumpAndSettle();
    expect(teams.teams, isEmpty);
    expect(find.textContaining('Chưa có đội nào'), findsOneWidget);
  });
}
