// ignore_for_file: unintended_html_in_doc_comment

import 'package:flutter/material.dart';

class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.extraSmallBold,
    required this.extraSmallSemiBold,
    required this.smallRegular,
    required this.smallSemiBold,
    required this.smallBold,
    required this.bodySmall,
    required this.bodyRegular,
    required this.bodySemiBold,
    required this.medium,
    required this.mediumBold,
    required this.titleBold,
    required this.headingSmall,
    required this.headingMedium,
    required this.headingLarge,
    required this.headingXLarge,
    required this.displayLarge,
  });

  final TextStyle extraSmallBold;
  final TextStyle extraSmallSemiBold;

  final TextStyle smallRegular;
  final TextStyle smallSemiBold;
  final TextStyle smallBold;

  final TextStyle bodySmall;
  final TextStyle bodyRegular;
  final TextStyle bodySemiBold;

  final TextStyle medium;
  final TextStyle mediumBold;

  final TextStyle titleBold;

  final TextStyle headingSmall;
  final TextStyle headingMedium;
  final TextStyle headingLarge;
  final TextStyle headingXLarge;

  final TextStyle displayLarge;

  /// Создаёт всю типографику приложения
  /// с указанным цветом текста.
  static AppTypography create(Color color) {
    const fontFamily = 'Outfit';

    return AppTypography(
      // 10 / 800
      extraSmallBold: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w800,
      ).copyWith(color: color),

      // 10 / 700
      extraSmallSemiBold: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ).copyWith(color: color),

      // 11 / 400
      smallRegular: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ).copyWith(color: color),

      // 11 / 600
      smallSemiBold: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ).copyWith(color: color),

      // 11 / 700
      smallBold: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ).copyWith(color: color),

      // 12 / 400
      bodySmall: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ).copyWith(color: color),

      // 13 / 400
      bodyRegular: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ).copyWith(color: color),

      // 13 / 600
      bodySemiBold: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ).copyWith(color: color),

      // 15 / 500
      medium: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ).copyWith(color: color),

      // 15 / 700
      mediumBold: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ).copyWith(color: color),

      // 16 / 800
      titleBold: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ).copyWith(color: color),

      // 22 / 800
      headingSmall: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w800,
      ).copyWith(color: color),

      // 26 / 800
      headingMedium: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 26,
        fontWeight: FontWeight.w800,
      ).copyWith(color: color),

      // 30 / 900
      headingLarge: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 30,
        fontWeight: FontWeight.w900,
      ).copyWith(color: color),

      // 24 / 900
      headingXLarge: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w900,
      ).copyWith(color: color),

      // 42 / 900
      displayLarge: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 42,
        fontWeight: FontWeight.w900,
      ).copyWith(color: color),
    );
  }

  @override
  AppTypography copyWith({
    TextStyle? extraSmallBold,
    TextStyle? extraSmallSemiBold,
    TextStyle? smallRegular,
    TextStyle? smallSemiBold,
    TextStyle? smallBold,
    TextStyle? bodySmall,
    TextStyle? bodyRegular,
    TextStyle? bodySemiBold,
    TextStyle? medium,
    TextStyle? mediumBold,
    TextStyle? titleBold,
    TextStyle? headingSmall,
    TextStyle? headingMedium,
    TextStyle? headingLarge,
    TextStyle? headingXLarge,
    TextStyle? displayLarge,
  }) {
    return AppTypography(
      extraSmallBold: extraSmallBold ?? this.extraSmallBold,
      extraSmallSemiBold: extraSmallSemiBold ?? this.extraSmallSemiBold,
      smallRegular: smallRegular ?? this.smallRegular,
      smallSemiBold: smallSemiBold ?? this.smallSemiBold,
      smallBold: smallBold ?? this.smallBold,
      bodySmall: bodySmall ?? this.bodySmall,
      bodyRegular: bodyRegular ?? this.bodyRegular,
      bodySemiBold: bodySemiBold ?? this.bodySemiBold,
      medium: medium ?? this.medium,
      mediumBold: mediumBold ?? this.mediumBold,
      titleBold: titleBold ?? this.titleBold,
      headingSmall: headingSmall ?? this.headingSmall,
      headingMedium: headingMedium ?? this.headingMedium,
      headingLarge: headingLarge ?? this.headingLarge,
      headingXLarge: headingXLarge ?? this.headingXLarge,
      displayLarge: displayLarge ?? this.displayLarge,
    );
  }

  @override
  AppTypography lerp(covariant AppTypography? other, double t) {
    if (other == null) {
      return this;
    }

    return AppTypography(
      extraSmallBold: TextStyle.lerp(extraSmallBold, other.extraSmallBold, t)!,
      extraSmallSemiBold: TextStyle.lerp(
        extraSmallSemiBold,
        other.extraSmallSemiBold,
        t,
      )!,
      smallRegular: TextStyle.lerp(smallRegular, other.smallRegular, t)!,
      smallSemiBold: TextStyle.lerp(smallSemiBold, other.smallSemiBold, t)!,
      smallBold: TextStyle.lerp(smallBold, other.smallBold, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      bodyRegular: TextStyle.lerp(bodyRegular, other.bodyRegular, t)!,
      bodySemiBold: TextStyle.lerp(bodySemiBold, other.bodySemiBold, t)!,
      medium: TextStyle.lerp(medium, other.medium, t)!,
      mediumBold: TextStyle.lerp(mediumBold, other.mediumBold, t)!,
      titleBold: TextStyle.lerp(titleBold, other.titleBold, t)!,
      headingSmall: TextStyle.lerp(headingSmall, other.headingSmall, t)!,
      headingMedium: TextStyle.lerp(headingMedium, other.headingMedium, t)!,
      headingLarge: TextStyle.lerp(headingLarge, other.headingLarge, t)!,
      headingXLarge: TextStyle.lerp(headingXLarge, other.headingXLarge, t)!,
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
    );
  }
}

/// Позволяет писать:
///
/// context.typography.headingLarge
///
/// вместо:
///
/// Theme.of(context)
///     .extension<AppTypography>()!
extension AppTypographyContext on BuildContext {
  AppTypography get typography {
    return Theme.of(this).extension<AppTypography>()!;
  }
}
