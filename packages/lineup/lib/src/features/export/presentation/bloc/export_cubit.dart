import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lineup/src/features/export/domain/entities/export_template.dart';
import 'package:lineup/src/features/export/domain/entities/lineup_card.dart';
import 'package:lineup/src/features/export/domain/repositories/image_exporter.dart';
import 'package:lineup/src/features/export/presentation/bloc/export_state.dart';

/// Rendering lives in the widget tree, so actions take a callback that
/// captures the preview only when the user actually saves or shares.
typedef CaptureImage = Future<Uint8List> Function();

class ExportCubit extends Cubit<ExportState> {
  ExportCubit(this._exporter, LineupCard card) : super(ExportState(card: card));

  final ImageExporter _exporter;

  void selectTemplate(ExportTemplate template) =>
      emit(state.copyWith(template: template, outcome: ExportOutcome.none));

  void setHeadline(String headline) =>
      emit(state.copyWith(headline: headline, outcome: ExportOutcome.none));

  void toggleSubstitutes(bool show) =>
      emit(state.copyWith(showSubstitutes: show, outcome: ExportOutcome.none));

  Future<void> save(CaptureImage capture) => _run(() async {
    final ok = await _exporter.saveToGallery(await capture());
    return ok ? ExportOutcome.saved : ExportOutcome.denied;
  });

  Future<void> share(CaptureImage capture) => _run(() async {
    await _exporter.share(await capture(), text: state.card.teamName);
    return ExportOutcome.shared;
  });

  Future<void> _run(Future<ExportOutcome> Function() action) async {
    if (state.busy) return;
    emit(state.copyWith(busy: true, outcome: ExportOutcome.none));
    try {
      emit(state.copyWith(busy: false, outcome: await action()));
    } on Object {
      emit(state.copyWith(busy: false, outcome: ExportOutcome.failed));
    }
  }
}
