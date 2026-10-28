import 'package:equatable/equatable.dart';
import 'package:lineup/src/features/export/domain/entities/export_template.dart';
import 'package:lineup/src/features/export/domain/entities/lineup_card.dart';

enum ExportOutcome { none, saved, denied, shared, failed }

final class ExportState extends Equatable {
  const ExportState({
    required this.card,
    this.template = ExportTemplate.gloryRed,
    this.headline = '',
    this.showSubstitutes = true,
    this.busy = false,
    this.outcome = ExportOutcome.none,
  });

  final LineupCard card;
  final ExportTemplate template;

  /// Free text such as "vs FC Phủi · 20:00 T7"; empty hides the line.
  final String headline;
  final bool showSubstitutes;
  final bool busy;

  /// Result of the last save/share, for a one-off snackbar.
  final ExportOutcome outcome;

  ExportState copyWith({
    ExportTemplate? template,
    String? headline,
    bool? showSubstitutes,
    bool? busy,
    ExportOutcome? outcome,
  }) {
    return ExportState(
      card: card,
      template: template ?? this.template,
      headline: headline ?? this.headline,
      showSubstitutes: showSubstitutes ?? this.showSubstitutes,
      busy: busy ?? this.busy,
      outcome: outcome ?? this.outcome,
    );
  }

  @override
  List<Object?> get props => [
    card,
    template,
    headline,
    showSubstitutes,
    busy,
    outcome,
  ];
}
