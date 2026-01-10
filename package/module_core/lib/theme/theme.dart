import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff006c46),
      surfaceTint: Color(0xff006c46),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff00a76f),
      onPrimaryContainer: Color(0xff00321f),
      secondary: Color(0xff5e5e5e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff919191),
      onSecondaryContainer: Color(0xff292a2a),
      tertiary: Color(0xff5152b8),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8587f0),
      onTertiaryContainer: Color(0xff191583),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff4fbf4),
      onSurface: Color(0xff161d19),
      onSurfaceVariant: Color(0xff3d4a41),
      outline: Color(0xff6d7a71),
      outlineVariant: Color(0xffbccabf),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b322d),
      inversePrimary: Color(0xff5adda0),
      primaryFixed: Color(0xff79fabb),
      onPrimaryFixed: Color(0xff002112),
      primaryFixedDim: Color(0xff5adda0),
      onPrimaryFixedVariant: Color(0xff005234),
      secondaryFixed: Color(0xffe3e2e2),
      onSecondaryFixed: Color(0xff1b1c1c),
      secondaryFixedDim: Color(0xffc7c6c6),
      onSecondaryFixedVariant: Color(0xff464747),
      tertiaryFixed: Color(0xffe1dfff),
      onTertiaryFixed: Color(0xff08006c),
      tertiaryFixedDim: Color(0xffc1c1ff),
      onTertiaryFixedVariant: Color(0xff38399e),
      surfaceDim: Color(0xffd5dcd5),
      surfaceBright: Color(0xfff4fbf4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5ee),
      surfaceContainer: Color(0xffe9f0e8),
      surfaceContainerHigh: Color(0xffe3eae3),
      surfaceContainerHighest: Color(0xffdde4dd),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003f27),
      surfaceTint: Color(0xff006c46),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff007d52),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff353636),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6d6d6d),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff26258d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff6061c8),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff4fbf4),
      onSurface: Color(0xff0c130f),
      onSurfaceVariant: Color(0xff2c3931),
      outline: Color(0xff48564d),
      outlineVariant: Color(0xff637067),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b322d),
      inversePrimary: Color(0xff5adda0),
      primaryFixed: Color(0xff007d52),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff00623f),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6d6d6d),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff545555),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff6061c8),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff4748ad),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc1c8c1),
      surfaceBright: Color(0xfff4fbf4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5ee),
      surfaceContainer: Color(0xffe3eae3),
      surfaceContainerHigh: Color(0xffd8dfd7),
      surfaceContainerHighest: Color(0xffccd3cc),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00341f),
      surfaceTint: Color(0xff006c46),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff005436),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2b2c2c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff484949),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff1b1784),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff3b3ba1),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff4fbf4),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff232f27),
      outlineVariant: Color(0xff3f4c44),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b322d),
      inversePrimary: Color(0xff5adda0),
      primaryFixed: Color(0xff005436),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003b24),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff484949),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff323333),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff3b3ba1),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff22218a),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb3bbb4),
      surfaceBright: Color(0xfff4fbf4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffecf3eb),
      surfaceContainer: Color(0xffdde4dd),
      surfaceContainerHigh: Color(0xffcfd6cf),
      surfaceContainerHighest: Color(0xffc1c8c1),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff5adda0),
      surfaceTint: Color(0xff5adda0),
      onPrimary: Color(0xff003823),
      primaryContainer: Color(0xff00a76f),
      onPrimaryContainer: Color(0xff00321f),
      secondary: Color(0xffc7c6c6),
      onSecondary: Color(0xff2f3131),
      secondaryContainer: Color(0xff919191),
      onSecondaryContainer: Color(0xff292a2a),
      tertiary: Color(0xffc1c1ff),
      onTertiary: Color(0xff201e88),
      tertiaryContainer: Color(0xff8587f0),
      onTertiaryContainer: Color(0xff191583),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0e1511),
      onSurface: Color(0xffdde4dd),
      onSurfaceVariant: Color(0xffbccabf),
      outline: Color(0xff86948a),
      outlineVariant: Color(0xff3d4a41),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde4dd),
      inversePrimary: Color(0xff006c46),
      primaryFixed: Color(0xff79fabb),
      onPrimaryFixed: Color(0xff002112),
      primaryFixedDim: Color(0xff5adda0),
      onPrimaryFixedVariant: Color(0xff005234),
      secondaryFixed: Color(0xffe3e2e2),
      onSecondaryFixed: Color(0xff1b1c1c),
      secondaryFixedDim: Color(0xffc7c6c6),
      onSecondaryFixedVariant: Color(0xff464747),
      tertiaryFixed: Color(0xffe1dfff),
      onTertiaryFixed: Color(0xff08006c),
      tertiaryFixedDim: Color(0xffc1c1ff),
      onTertiaryFixedVariant: Color(0xff38399e),
      surfaceDim: Color(0xff0e1511),
      surfaceBright: Color(0xff343b36),
      surfaceContainerLowest: Color(0xff09100c),
      surfaceContainerLow: Color(0xff161d19),
      surfaceContainer: Color(0xff1a211d),
      surfaceContainerHigh: Color(0xff252c27),
      surfaceContainerHighest: Color(0xff2f3632),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff72f4b5),
      surfaceTint: Color(0xff5adda0),
      onPrimary: Color(0xff002c1a),
      primaryContainer: Color(0xff00a76f),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffdddcdc),
      onSecondary: Color(0xff252626),
      secondaryContainer: Color(0xff919191),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffdad9ff),
      onTertiary: Color(0xff120c7e),
      tertiaryContainer: Color(0xff8587f0),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0e1511),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd2e0d4),
      outline: Color(0xffa7b5ab),
      outlineVariant: Color(0xff86948a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde4dd),
      inversePrimary: Color(0xff005335),
      primaryFixed: Color(0xff79fabb),
      onPrimaryFixed: Color(0xff00150a),
      primaryFixedDim: Color(0xff5adda0),
      onPrimaryFixedVariant: Color(0xff003f27),
      secondaryFixed: Color(0xffe3e2e2),
      onSecondaryFixed: Color(0xff101112),
      secondaryFixedDim: Color(0xffc7c6c6),
      onSecondaryFixedVariant: Color(0xff353636),
      tertiaryFixed: Color(0xffe1dfff),
      onTertiaryFixed: Color(0xff04004d),
      tertiaryFixedDim: Color(0xffc1c1ff),
      onTertiaryFixedVariant: Color(0xff26258d),
      surfaceDim: Color(0xff0e1511),
      surfaceBright: Color(0xff3f4641),
      surfaceContainerLowest: Color(0xff040906),
      surfaceContainerLow: Color(0xff181f1b),
      surfaceContainer: Color(0xff232925),
      surfaceContainerHigh: Color(0xff2d342f),
      surfaceContainerHighest: Color(0xff383f3a),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbbffd7),
      surfaceTint: Color(0xff5adda0),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff56d99d),
      onPrimaryContainer: Color(0xff000e06),
      secondary: Color(0xfff1f0ef),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffc3c2c2),
      onSecondaryContainer: Color(0xff0a0b0c),
      tertiary: Color(0xfff1eeff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffbcbdff),
      onTertiaryContainer: Color(0xff02003c),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff0e1511),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffe5f4e8),
      outlineVariant: Color(0xffb8c6bb),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde4dd),
      inversePrimary: Color(0xff005335),
      primaryFixed: Color(0xff79fabb),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff5adda0),
      onPrimaryFixedVariant: Color(0xff00150a),
      secondaryFixed: Color(0xffe3e2e2),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffc7c6c6),
      onSecondaryFixedVariant: Color(0xff101112),
      tertiaryFixed: Color(0xffe1dfff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffc1c1ff),
      onTertiaryFixedVariant: Color(0xff04004d),
      surfaceDim: Color(0xff0e1511),
      surfaceBright: Color(0xff4b524c),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1a211d),
      surfaceContainer: Color(0xff2b322d),
      surfaceContainerHigh: Color(0xff363d38),
      surfaceContainerHighest: Color(0xff414843),
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


  List<ExtendedColor> get extendedColors => [
  ];
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
