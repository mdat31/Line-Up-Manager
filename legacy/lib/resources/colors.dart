import 'dart:ui';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

final colorPlayerBackground = HexColor('F0F0F0');
final colorScaffoldBackground = HexColor('EAEAEA');
final colorPlayerNumberExport = HexColor('880000');
final colorSubstitutesText = HexColor('CBCBCB');
final colorSubstitutesLandscapeText = HexColor('ABAAAA');
final colorExportBlueText = HexColor('0C538B');
