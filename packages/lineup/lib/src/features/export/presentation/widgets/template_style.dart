import 'package:flutter/material.dart';
import 'package:lineup/src/features/export/domain/entities/export_template.dart';

/// Colours and type for one export template. Assets and fonts are loaded
/// from this package so the module works inside any host app.
final class TemplateStyle {
  const TemplateStyle({
    required this.background,
    required this.text,
    required this.muted,
    required this.accent,
    required this.disc,
    required this.discText,
    required this.pitchLines,
  });

  factory TemplateStyle.of(ExportTemplate template) => switch (template) {
    ExportTemplate.gloryRed => const TemplateStyle(
      background: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/portrait_red.png',
            package: _package,
          ),
          fit: BoxFit.cover,
        ),
      ),
      text: Colors.white,
      muted: Color(0xFFFFCDD2),
      accent: Color(0xFFFFEB3B),
      disc: Colors.white,
      discText: Color(0xFF880000),
      pitchLines: Color(0x55FFFFFF),
    ),
    ExportTemplate.blueWhite => const TemplateStyle(
      background: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/blue_n_white.png',
            package: _package,
          ),
          fit: BoxFit.cover,
        ),
      ),
      text: Color(0xFF0C538B),
      muted: Color(0xFF6B8BA8),
      accent: Color(0xFFE53935),
      disc: Color(0xFF0C538B),
      discText: Colors.white,
      pitchLines: Color(0x330C538B),
    ),
    ExportTemplate.pitch => const TemplateStyle(
      background: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
        ),
      ),
      text: Colors.white,
      muted: Color(0xFFC8E6C9),
      accent: Color(0xFFFFEB3B),
      disc: Colors.white,
      discText: Color(0xFF1B5E20),
      pitchLines: Color(0x88FFFFFF),
    ),
  };

  static const _package = 'lineup';
  static const _font = 'Oswald';

  final BoxDecoration background;
  final Color text;
  final Color muted;
  final Color accent;
  final Color disc;
  final Color discText;
  final Color pitchLines;

  TextStyle display(double size, {bool bold = false, Color? color}) {
    return TextStyle(
      fontFamily: _font,
      package: _package,
      fontSize: size,
      height: 1.2,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
      color: color ?? text,
    );
  }
}
