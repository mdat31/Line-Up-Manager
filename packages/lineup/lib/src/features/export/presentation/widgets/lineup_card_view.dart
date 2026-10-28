import 'package:flutter/material.dart';
import 'package:lineup/src/core/widgets/pitch_painter.dart';
import 'package:lineup/src/features/export/domain/entities/export_template.dart';
import 'package:lineup/src/features/export/domain/entities/lineup_card.dart';
import 'package:lineup/src/features/export/presentation/widgets/template_style.dart';

/// The exported image. Laid out at a fixed logical [size] so every phone
/// produces the same picture; the preview scales it with a FittedBox.
class LineupCardView extends StatelessWidget {
  const LineupCardView({
    super.key,
    required this.card,
    required this.template,
    this.headline = '',
    this.showSubstitutes = true,
  });

  /// 4:5, the tallest ratio Facebook and Instagram feeds show uncropped.
  static const size = Size(360, 450);

  final LineupCard card;
  final ExportTemplate template;
  final String headline;
  final bool showSubstitutes;

  @override
  Widget build(BuildContext context) {
    final style = TemplateStyle.of(template);
    return SizedBox.fromSize(
      size: size,
      child: DecoratedBox(
        decoration: style.background,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Column(
            children: [
              _Header(card: card, headline: headline, style: style),
              const SizedBox(height: 8),
              Expanded(
                child: _Pitch(card: card, style: style),
              ),
              if (showSubstitutes && card.substitutes.isNotEmpty)
                _Substitutes(names: card.substitutes, style: style),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'MAROZI',
                  style: style.display(9, color: style.muted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.card,
    required this.headline,
    required this.style,
  });

  final LineupCard card;
  final String headline;
  final TemplateStyle style;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      card.formationId,
      if (card.coachName.isNotEmpty) card.coachName,
    ].join('  ·  ');
    return Column(
      children: [
        Text(
          card.teamName.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: style.display(30, bold: true),
        ),
        Text(
          subtitle.toUpperCase(),
          style: style.display(14, color: style.muted),
        ),
        if (headline.isNotEmpty)
          Text(
            headline.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style.display(15, color: style.accent),
          ),
      ],
    );
  }
}

class _Pitch extends StatelessWidget {
  const _Pitch({required this.card, required this.style});

  static const _tokenW = 64.0;
  static const _tokenH = 50.0;

  final LineupCard card;
  final TemplateStyle style;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: PitchPainter(lineColor: style.pitchLines),
              ),
            ),
            for (final p in card.starters)
              Positioned(
                left: p.x * w - _tokenW / 2,
                top: p.y * h - _tokenH / 2,
                width: _tokenW,
                height: _tokenH,
                child: _CardToken(player: p, style: style),
              ),
          ],
        );
      },
    );
  }
}

class _CardToken extends StatelessWidget {
  const _CardToken({required this.player, required this.style});

  final CardPlayer player;
  final TemplateStyle style;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: style.disc, shape: BoxShape.circle),
          child: Text(
            player.number?.toString() ?? '',
            style: style.display(16, bold: true, color: style.discText),
          ),
        ),
        const SizedBox(height: 2),
        Text.rich(
          TextSpan(
            text: player.name.toUpperCase(),
            children: [
              if (player.isCaptain)
                TextSpan(
                  text: ' C',
                  style: TextStyle(color: style.accent),
                ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: style.display(14),
        ),
      ],
    );
  }
}

class _Substitutes extends StatelessWidget {
  const _Substitutes({required this.names, required this.style});

  final List<String> names;
  final TemplateStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        children: [
          Text('DỰ BỊ', style: style.display(11, color: style.muted)),
          Text(
            names.map((n) => n.toUpperCase()).join('   '),
            maxLines: 2,
            textAlign: TextAlign.center,
            style: style.display(14),
          ),
        ],
      ),
    );
  }
}
