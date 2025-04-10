import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3b6939),
      surfaceTint: Color(0xff3b6939),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffbcf0b4), // App bar & button color
      onPrimaryContainer: Color(0xff002204),
      secondary: Color(0xff52634f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd5e8cf),
      onSecondaryContainer: Color(0xff111f0f),
      tertiary: Color(0xff38656a),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffbcebf0),
      onTertiaryContainer: Color(0xff002023),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color.fromARGB(255, 240, 240, 240), // background
      onSurface: Color(0xff191d17),
      onSurfaceVariant: Color(0xff424940),
      outline: Color(0xff72796f),
      outlineVariant: Color(0xffc2c9bd),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inversePrimary: Color(0xffa1d39a),
      primaryFixed: Color(0xffbcf0b4),
      onPrimaryFixed: Color(0xff002204),
      primaryFixedDim: Color(0xffa1d39a),
      onPrimaryFixedVariant: Color(0xff235024),
      secondaryFixed: Color(0xffd5e8cf),
      onSecondaryFixed: Color(0xff111f0f),
      secondaryFixedDim: Color(0xffbaccb3),
      onSecondaryFixedVariant: Color(0xff3b4b38),
      tertiaryFixed: Color(0xffbcebf0),
      onTertiaryFixed: Color(0xff002023),
      tertiaryFixedDim: Color(0xffa0cfd4),
      onTertiaryFixedVariant: Color(0xff1f4d52),
      surfaceDim: Color(0xffd8dbd2),
      surfaceBright: Color(0xfff7fbf1),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color.fromARGB(255, 233, 233, 233),
      surfaceContainer: Color(0xffecefe6),
      surfaceContainerHigh: Color(0xffe6e9e0),
      surfaceContainerHighest: Color(0xffe0e4db),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff1f4c20),
      surfaceTint: Color(0xff3b6939),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff517f4e),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff374735),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff687964),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff1a494e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4f7c81),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7fbf1),
      onSurface: Color(0xff191d17),
      onSurfaceVariant: Color(0xff3e453c),
      outline: Color(0xff5a6157),
      outlineVariant: Color(0xff767d72),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inversePrimary: Color(0xffa1d39a),
      primaryFixed: Color(0xff517f4e),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff396637),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff687964),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff50604d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff4f7c81),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff366368),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd8dbd2),
      surfaceBright: Color(0xfff7fbf1),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ec),
      surfaceContainer: Color(0xffecefe6),
      surfaceContainerHigh: Color(0xffe6e9e0),
      surfaceContainerHighest: Color(0xffe0e4db),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002905),
      surfaceTint: Color(0xff3b6939),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1f4c20),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff172616),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff374735),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff00272a),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff1a494e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7fbf1),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff1f261e),
      outline: Color(0xff3e453c),
      outlineVariant: Color(0xff3e453c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inversePrimary: Color(0xffc5fabd),
      primaryFixed: Color(0xff1f4c20),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff05350c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff374735),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff213020),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff1a494e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff003237),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd8dbd2),
      surfaceBright: Color(0xfff7fbf1),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ec),
      surfaceContainer: Color(0xffecefe6),
      surfaceContainerHigh: Color(0xffe6e9e0),
      surfaceContainerHighest: Color(0xffe0e4db),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa1d39a),
      surfaceTint: Color(0xffa1d39a),
      onPrimary: Color(0xff0a390f),
      primaryContainer: Color(0xff235024),
      onPrimaryContainer: Color(0xffbcf0b4),
      secondary: Color(0xffbaccb3),
      onSecondary: Color(0xff253423),
      secondaryContainer: Color(0xff3b4b38),
      onSecondaryContainer: Color(0xffd5e8cf),
      tertiary: Color(0xffa0cfd4),
      onTertiary: Color(0xff00363b),
      tertiaryContainer: Color(0xff1f4d52),
      onTertiaryContainer: Color(0xffbcebf0),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff10140f),
      onSurface: Color(0xffe0e4db),
      onSurfaceVariant: Color(0xffc2c9bd),
      outline: Color(0xff8c9388),
      outlineVariant: Color(0xff424940),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4db),
      inversePrimary: Color(0xff3b6939),
      primaryFixed: Color(0xffbcf0b4),
      onPrimaryFixed: Color(0xff002204),
      primaryFixedDim: Color(0xffa1d39a),
      onPrimaryFixedVariant: Color(0xff235024),
      secondaryFixed: Color(0xffd5e8cf),
      onSecondaryFixed: Color(0xff111f0f),
      secondaryFixedDim: Color(0xffbaccb3),
      onSecondaryFixedVariant: Color(0xff3b4b38),
      tertiaryFixed: Color(0xffbcebf0),
      onTertiaryFixed: Color(0xff002023),
      tertiaryFixedDim: Color(0xffa0cfd4),
      onTertiaryFixedVariant: Color(0xff1f4d52),
      surfaceDim: Color(0xff10140f),
      surfaceBright: Color(0xff363a34),
      surfaceContainerLowest: Color(0xff0b0f0a),
      surfaceContainerLow: Color(0xff191d17),
      surfaceContainer: Color(0xff1d211b),
      surfaceContainerHigh: Color(0xff272b25),
      surfaceContainerHighest: Color(0xff323630),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa5d89e),
      surfaceTint: Color(0xffa1d39a),
      onPrimary: Color(0xff001b03),
      primaryContainer: Color(0xff6c9c68),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffbed0b7),
      onSecondary: Color(0xff0b1a0a),
      secondaryContainer: Color(0xff84967f),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffa5d3d8),
      onTertiary: Color(0xff001a1c),
      tertiaryContainer: Color(0xff6b989e),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff10140f),
      onSurface: Color(0xfff9fcf3),
      onSurfaceVariant: Color(0xffc6cdc1),
      outline: Color(0xff9ea59a),
      outlineVariant: Color(0xff7e857b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4db),
      inversePrimary: Color(0xff255125),
      primaryFixed: Color(0xffbcf0b4),
      onPrimaryFixed: Color(0xff001602),
      primaryFixedDim: Color(0xffa1d39a),
      onPrimaryFixedVariant: Color(0xff113f15),
      secondaryFixed: Color(0xffd5e8cf),
      onSecondaryFixed: Color(0xff061406),
      secondaryFixedDim: Color(0xffbaccb3),
      onSecondaryFixedVariant: Color(0xff2b3a29),
      tertiaryFixed: Color(0xffbcebf0),
      onTertiaryFixed: Color(0xff001416),
      tertiaryFixedDim: Color(0xffa0cfd4),
      onTertiaryFixedVariant: Color(0xff073c41),
      surfaceDim: Color(0xff10140f),
      surfaceBright: Color(0xff363a34),
      surfaceContainerLowest: Color(0xff0b0f0a),
      surfaceContainerLow: Color(0xff191d17),
      surfaceContainer: Color(0xff1d211b),
      surfaceContainerHigh: Color(0xff272b25),
      surfaceContainerHighest: Color(0xff323630),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff1ffea),
      surfaceTint: Color(0xffa1d39a),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa5d89e),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfff1ffea),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffbed0b7),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffeffdff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffa5d3d8),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff10140f),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff7fdf0),
      outline: Color(0xffc6cdc1),
      outlineVariant: Color(0xffc6cdc1),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4db),
      inversePrimary: Color(0xff023209),
      primaryFixed: Color(0xffc0f4b8),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffa5d89e),
      onPrimaryFixedVariant: Color(0xff001b03),
      secondaryFixed: Color(0xffdaecd3),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffbed0b7),
      onSecondaryFixedVariant: Color(0xff0b1a0a),
      tertiaryFixed: Color(0xffc0eff5),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffa5d3d8),
      onTertiaryFixedVariant: Color(0xff001a1c),
      surfaceDim: Color(0xff10140f),
      surfaceBright: Color(0xff363a34),
      surfaceContainerLowest: Color(0xff0b0f0a),
      surfaceContainerLow: Color(0xff191d17),
      surfaceContainer: Color(0xff1d211b),
      surfaceContainerHigh: Color(0xff272b25),
      surfaceContainerHighest: Color(0xff323630),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
