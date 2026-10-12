import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const Color primary800 = Color(0xFF0F5E1B);
  static const Color primary600 = Color(0xFF2E7D32);
  static const Color primary400 = Color(0xFF66BB6A);
  static const Color primary100 = Color(0xFFDDEBDC);
  static const Color accentChip = Color(0xFFB6F2B0);

  // Surface
  static const Color bg = Color(0xFFF2F7F1);
  static const Color surface = Color(0xFFEBEFEA);
  static const Color surfaceInset = Color(0xFFE1E5E0);

  // Text
  static const Color textPrimary = Color(0xFF1C201C);
  static const Color textSecondary = Color(0xFF4B554B);
  static const Color textMuted = Color(0xFF6F7A6F);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Semantic
  static const Color warning500 = Color(0xFFF59E0B);
  static const Color warning100 = Color(0xFFFCEBCB);
  static const Color danger600 = Color(0xFFD32F2F);
  static const Color danger100 = Color(0xFFF8DADA);
  static const Color dangerBorder = Color(0xFFE8B8B8);
  static const Color success600 = Color(0xFF2E7D32);
  static const Color success100 = Color(0xFFDDEBDC);
}

class AppShadows {
  static const BoxShadow _shadowDark = BoxShadow(
    color: Color(0x5996A896),
    offset: Offset(8, 8),
    blurRadius: 18,
  );
  static const BoxShadow _shadowLight = BoxShadow(
    color: Color(0xD9FFFFFF),
    offset: Offset(-8, -8),
    blurRadius: 18,
  );
  static const BoxShadow _shadowDarkSm = BoxShadow(
    color: Color(0x4D96A896),
    offset: Offset(4, 4),
    blurRadius: 10,
  );
  static const BoxShadow _shadowLightSm = BoxShadow(
    color: Color(0xCCFFFFFF),
    offset: Offset(-4, -4),
    blurRadius: 10,
  );

  static const List<BoxShadow> raised = [_shadowDark, _shadowLight];
  static const List<BoxShadow> raisedSm = [_shadowDarkSm, _shadowLightSm];

  static const List<BoxShadow> fab = [
    BoxShadow(
      color: Color(0x592E7D32),
      offset: Offset(0, 8),
      blurRadius: 20,
    ),
  ];
  static const List<BoxShadow> buttonPrimary = [
    BoxShadow(
      color: Color(0x4D0F5E1B),
      offset: Offset(0, 6),
      blurRadius: 14,
    ),
  ];
}

class AppSpacing {
  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s5 = 20;
  static const double s6 = 24;
  static const double s8 = 32;

  static const double pagePaddingX = 20;
  static const double cardPadding = 20;
  static const double sectionGap = 20;
  static const double tapTargetMin = 48;
  static const double bottomNavHeight = 72;
}

class AppRadius {
  static const double card = 28;
  static const double tile = 20;
  static const double button = 18;
  static const double pill = 999;
}
