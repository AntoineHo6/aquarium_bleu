import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

@immutable
class BabyBlueTheme extends ThemeExtension<BabyBlueTheme> {
  final Color primaryColor, tertiaryColor, neutralColor;

  const BabyBlueTheme({
    this.primaryColor = const Color(0xFF8AAAE5),
    this.tertiaryColor = const Color(0xFFa487a9),
    this.neutralColor = const Color(0xFF909094),
  });

  ThemeData toThemeData() {
    return ThemeData(useMaterial3: true);
  }

  @override
  ThemeExtension<BabyBlueTheme> copyWith({
    Color? primaryColor,
    Color? tertiaryColor,
    Color? neutralColor,
  }) =>
      BabyBlueTheme(
        primaryColor: primaryColor ?? this.primaryColor,
        tertiaryColor: tertiaryColor ?? this.tertiaryColor,
        neutralColor: neutralColor ?? this.neutralColor,
      );

  @override
  ThemeExtension<BabyBlueTheme> lerp(
      covariant ThemeExtension<BabyBlueTheme>? other, double t) {
    if (other is! BabyBlueTheme) return this;

    return BabyBlueTheme(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      tertiaryColor: Color.lerp(tertiaryColor, other.tertiaryColor, t)!,
      neutralColor: Color.lerp(neutralColor, other.neutralColor, t)!,
    );
  }

  // Scheme _scheme() {
  //   final base = CorePalette.of(primaryColor.value);
  //   final primary = base.primary;
  //   final tertiary = CorePalette.of(tertiaryColor.value).primary;
  //   final neutral = CorePalette.of(neutralColor.value).neutral;
  //   return Scheme(
  //     primary: primary.get(40),
  //     onPrimary: primary.get(100),
  //     primaryContainer: primary.get(90),
  //     onPrimaryContainer: primary.get(10),
  //     secondary: base.secondary.get(40),
  //     onSecondary: base.secondary.get(100),
  //     secondaryContainer: base.secondary.get(90),
  //     onSecondaryContainer: base.secondary.get(10),
  //     tertiary: tertiary.get(40),
  //     onTertiary: tertiary.get(100),
  //     tertiaryContainer: tertiary.get(90),
  //     onTertiaryContainer: tertiary.get(10),
  //     error: error,
  //     onError: onError,
  //     errorContainer: errorContainer,
  //     onErrorContainer: onErrorContainer,
  //     background: background,
  //     onBackground: onBackground,
  //     surface: surface,
  //     onSurface: onSurface,
  //     surfaceVariant: surfaceVariant,
  //     onSurfaceVariant: onSurfaceVariant,
  //     outline: outline,
  //     outlineVariant: outlineVariant,
  //     shadow: shadow,
  //     scrim: scrim,
  //     inverseSurface: inverseSurface,
  //     inverseOnSurface: inverseOnSurface,
  //     inversePrimary: inversePrimary,
  //   );
  // }
}
