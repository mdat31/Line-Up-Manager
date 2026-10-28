import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lineup/lineup.dart';
import 'package:marozi/app.dart';

class _NoTeams implements TeamRepository {
  @override
  Future<List<Team>> getTeams() async => [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NoLineups implements LineupRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NoExport implements ImageExporter {
  @override
  Future<bool> saveToGallery(Uint8List png) async => false;

  @override
  Future<void> share(Uint8List png, {String? text}) async {}
}

void main() {
  testWidgets('app opens on the line-up module team list', (tester) async {
    await tester.pumpWidget(
      MaroziApp(
        lineup: LineupDependencies(
          teams: _NoTeams(),
          lineups: _NoLineups(),
          exporter: _NoExport(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Đội của tôi'), findsOneWidget);
    expect(find.text('Tạo đội'), findsOneWidget);
  });
}
