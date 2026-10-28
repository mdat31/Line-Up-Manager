import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lineup/lineup.dart';
import 'package:lineup/src/features/export/domain/entities/export_template.dart';
import 'package:lineup/src/features/export/domain/entities/lineup_card.dart';
import 'package:lineup/src/features/export/presentation/screens/export_screen.dart';
import 'package:lineup/src/features/lineup/domain/entities/formations.dart';
import 'package:lineup/src/lineup_scope.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fakes.dart';

/// Worst case for layout: 11 starters with long names, a full bench.
LineupCard _crowdedCard() {
  final f = Formations.find(TeamFormat.elevenASide, '4-2-3-1')!;
  return LineupCard(
    teamName: 'Câu lạc bộ bóng đá phủi Quận Bảy',
    coachName: 'Nguyễn Văn Huấn Luyện',
    formationId: f.id,
    starters: [
      for (var i = 0; i < f.positions.length; i++)
        CardPlayer(
          name: 'Trườngggggg$i',
          number: i + 1,
          x: f.positions[i].x,
          y: f.positions[i].y,
          isCaptain: i == 5,
        ),
    ],
    substitutes: List.generate(9, (i) => 'Dựbị$i'),
  );
}

void main() {
  late MockImageExporter exporter;

  setUpAll(registerFallbacks);

  setUp(() => exporter = MockImageExporter());

  Future<void> pump(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(1170, 2532)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: LineupScope(
          dependencies: LineupDependencies(
            teams: InMemoryTeamRepository(),
            lineups: InMemoryLineupRepository(),
            exporter: exporter,
          ),
          child: ExportScreen(card: _crowdedCard()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('every template lays out a crowded card without overflow', (
    tester,
  ) async {
    await pump(tester);
    for (final t in ExportTemplate.values) {
      await tester.tap(find.text(t.label));
      await tester.enterText(find.byType(TextField), 'vs FC Phủi · 20:00 T7');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: t.name);
    }
  });

  testWidgets('save captures a 1080x1350 PNG and confirms', (tester) async {
    Uint8List? captured;
    when(() => exporter.saveToGallery(any())).thenAnswer((inv) async {
      captured = inv.positionalArguments.first as Uint8List;
      return true;
    });
    await pump(tester);

    await tester.runAsync(() async {
      await tester.tap(find.text('Lưu ảnh'));
      for (var i = 0; i < 50 && captured == null; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        await tester.pump();
      }
    });
    await tester.pump();

    expect(captured, isNotNull);
    // PNG IHDR: width and height are big-endian ints at bytes 16 and 20.
    final header = ByteData.sublistView(captured!);
    expect(header.getUint32(16), 1080);
    expect(header.getUint32(20), 1350);
    expect(find.text('Đã lưu vào thư viện ảnh'), findsOneWidget);
  });
}
