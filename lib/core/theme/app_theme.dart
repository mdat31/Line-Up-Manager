import 'package:flutter/material.dart';

import 'package:marozi/core/theme/app_colors.dart';
import 'package:marozi/core/theme/app_fonts.dart';

abstract final class AppTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    fontFamily: AppFonts.sfDisplayRegular,
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
  );
}
