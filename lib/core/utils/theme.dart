import "package:flutter/material.dart";

class MaterialTheme {
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00B1C1),
      // primary: Color(0xff006973),
      surfaceTint: Color(0xff00B1C1),
      // surfaceTint: Color(0xff006973),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff9df0fb),
      onPrimaryContainer: Color(0xff001f23),
      secondary: Color(0xff6c5e10),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffFFDF00),
      // secondaryContainer: Color(0xfff6e388),
      onSecondaryContainer: Color(0xff211b00),
      tertiary: Color(0xff515e7d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffd9e2ff),
      onTertiaryContainer: Color(0xff0d1b36),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfff5fafb),
      onSurface: Color(0xff171d1e),
      onSurfaceVariant: Color(0xff3f484a),
      outline: Color(0xff6f797a),
      outlineVariant: Color(0xffbec8ca),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3132),
      inversePrimary: Color(0xff81d3df),
      primaryFixed: Color(0xff9df0fb),
      onPrimaryFixed: Color(0xff001f23),
      primaryFixedDim: Color(0xff81d3df),
      onPrimaryFixedVariant: Color(0xff004f56),
      secondaryFixed: Color(0xfff6e388),
      onSecondaryFixed: Color(0xff211b00),
      secondaryFixedDim: Color(0xffd9c76f),
      onSecondaryFixedVariant: Color(0xff524700),
      tertiaryFixed: Color(0xffd9e2ff),
      onTertiaryFixed: Color(0xff0d1b36),
      tertiaryFixedDim: Color(0xffb9c6ea),
      onTertiaryFixedVariant: Color(0xff3a4664),
      surfaceDim: Color(0xffd5dbdc),
      surfaceBright: Color(0xfff5fafb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f5),
      surfaceContainer: Color(0xffe9eff0),
      surfaceContainerHigh: Color(0xffe3e9ea),
      surfaceContainerHighest: Color(0xffdee4e4),
    );
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff81d3df),
      surfaceTint: Color(0xff81d3df),
      onPrimary: Color(0xff00363c),
      primaryContainer: Color(0xff004f56),
      onPrimaryContainer: Color(0xff9df0fb),
      secondary: Color(0xffd9c76f),
      onSecondary: Color(0xff393000),
      secondaryContainer: Color(0xff524700),
      onSecondaryContainer: Color(0xfff6e388),
      tertiary: Color(0xffb9c6ea),
      onTertiary: Color(0xff23304d),
      tertiaryContainer: Color(0xff3a4664),
      onTertiaryContainer: Color(0xffd9e2ff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffdee4e4),
      onSurfaceVariant: Color(0xffbec8ca),
      outline: Color(0xff899294),
      outlineVariant: Color(0xff3f484a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee4e4),
      inversePrimary: Color(0xff006973),
      primaryFixed: Color(0xff9df0fb),
      onPrimaryFixed: Color(0xff001f23),
      primaryFixedDim: Color(0xff81d3df),
      onPrimaryFixedVariant: Color(0xff004f56),
      secondaryFixed: Color(0xfff6e388),
      onSecondaryFixed: Color(0xff211b00),
      secondaryFixedDim: Color(0xffd9c76f),
      onSecondaryFixedVariant: Color(0xff524700),
      tertiaryFixed: Color(0xffd9e2ff),
      onTertiaryFixed: Color(0xff0d1b36),
      tertiaryFixedDim: Color(0xffb9c6ea),
      onTertiaryFixedVariant: Color(0xff3a4664),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff343a3b),
      surfaceContainerLowest: Color(0xff090f10),
      surfaceContainerLow: Color(0xff171d1e),
      surfaceContainer: Color(0xff1b2122),
      surfaceContainerHigh: Color(0xff252b2c),
      surfaceContainerHighest: Color(0xff303637),
    );
  }

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
