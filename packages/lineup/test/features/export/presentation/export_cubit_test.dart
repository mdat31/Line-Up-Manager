import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lineup/src/features/export/domain/entities/export_template.dart';
import 'package:lineup/src/features/export/domain/entities/lineup_card.dart';
import 'package:lineup/src/features/export/presentation/bloc/export_cubit.dart';
import 'package:lineup/src/features/export/presentation/bloc/export_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fakes.dart';

void main() {
  const card = LineupCard(teamName: 'FC', formationId: '2-2', starters: []);
  final png = Uint8List.fromList([1, 2, 3]);
  late MockImageExporter exporter;
  late ExportCubit cubit;

  setUpAll(registerFallbacks);

  setUp(() {
    exporter = MockImageExporter();
    cubit = ExportCubit(exporter, card);
  });

  Future<Uint8List> capture() async => png;

  test('options update state', () {
    cubit
      ..selectTemplate(ExportTemplate.pitch)
      ..setHeadline('vs B')
      ..toggleSubstitutes(false);
    expect(cubit.state.template, ExportTemplate.pitch);
    expect(cubit.state.headline, 'vs B');
    expect(cubit.state.showSubstitutes, isFalse);
  });

  test('save reports saved or denied', () async {
    when(() => exporter.saveToGallery(any())).thenAnswer((_) async => true);
    await cubit.save(capture);
    expect(cubit.state.outcome, ExportOutcome.saved);
    expect(cubit.state.busy, isFalse);
    verify(() => exporter.saveToGallery(png)).called(1);

    when(() => exporter.saveToGallery(any())).thenAnswer((_) async => false);
    await cubit.save(capture);
    expect(cubit.state.outcome, ExportOutcome.denied);
  });

  test('share passes the team name and failures are reported', () async {
    when(() => exporter.share(any(), text: any(named: 'text')))
        .thenAnswer((_) async {});
    await cubit.share(capture);
    expect(cubit.state.outcome, ExportOutcome.shared);
    verify(() => exporter.share(png, text: 'FC')).called(1);

    when(() => exporter.share(any(), text: any(named: 'text')))
        .thenThrow(Exception('boom'));
    await cubit.share(capture);
    expect(cubit.state.outcome, ExportOutcome.failed);
    expect(cubit.state.busy, isFalse);
  });
}
