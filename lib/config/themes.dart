import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opdsure/custom_ui/input_decoration/decoratedInputBorder.dart';

import 'app_config.dart';

abstract class OpdThemes {
  static const double columnWidth = 360.0;

  static const double navRailWidth = 64.0;

  static bool isColumnModeByWidth(double width) =>
      width > columnWidth * 2 + navRailWidth;

  static bool isColumnMode(BuildContext context) =>
      isColumnModeByWidth(MediaQuery.of(context).size.width);

  static bool isThreeColumnMode(BuildContext context) =>
      MediaQuery.of(context).size.width > OpdThemes.columnWidth * 3.5;

  static const fallbackTextStyle = TextStyle(
    fontFamily: 'Roboto',
    fontFamilyFallback: ['NotoEmoji'],
  );

  static var fallbackTextTheme = const TextTheme(
    bodyLarge: fallbackTextStyle,
    bodyMedium: fallbackTextStyle,
    labelLarge: fallbackTextStyle,
    bodySmall: fallbackTextStyle,
    labelSmall: fallbackTextStyle,
    displayLarge: fallbackTextStyle,
    displayMedium: fallbackTextStyle,
    displaySmall: fallbackTextStyle,
    headlineMedium: fallbackTextStyle,
    headlineSmall: fallbackTextStyle,
    titleLarge: fallbackTextStyle,
    titleMedium: fallbackTextStyle,
    titleSmall: fallbackTextStyle,
  );

  static LinearGradient backgroundGradient(
    BuildContext context,
    int alpha,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return LinearGradient(
      begin: Alignment.topCenter,
      colors: [
        colorScheme.primaryContainer.withAlpha(alpha),
        colorScheme.secondaryContainer.withAlpha(alpha),
        colorScheme.tertiaryContainer.withAlpha(alpha),
        colorScheme.primaryContainer.withAlpha(alpha),
      ],
    );
  }

  static const Duration animationDuration = Duration(milliseconds: 250);
  static const Curve animationCurve = Curves.easeInOut;

  static ThemeData buildTheme(
    BuildContext context,
    Brightness brightness, [
    Color? seed,
  ]) {
    final colorScheme = ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: seed ?? AppConfig.colorSchemeSeed ?? AppConfig.primaryColorLight,
    );
    return ThemeData(
      visualDensity: VisualDensity.standard,
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: brightness == Brightness.light
              ? Typography.material2018().black.merge(fallbackTextTheme)
              : Typography.material2018().white.merge(fallbackTextTheme),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      dividerColor: brightness == Brightness.light
          ? Colors.blueGrey.shade50
          : Colors.blueGrey.shade900,
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: colorScheme.onSurface.withAlpha(128),
        selectionHandleColor: colorScheme.secondary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: DecoratedInputBorder(
            child: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
            ), shadow: const BoxShadow(
          color: Color(0xff101828),
          blurRadius: 0.2,
          offset: Offset(0, 1)
        )
        ),
        filled: true,
        fillColor: Colors.white
      ),
      appBarTheme: AppBarTheme(
        toolbarHeight: OpdThemes.isColumnMode(context) ? 72 : 56,
        shadowColor: OpdThemes.isColumnMode(context)
            ? Colors.grey.withAlpha(64)
            : null,
        surfaceTintColor: AppConfig.primaryColorLight,
        backgroundColor: AppConfig.primaryColorLight,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: brightness.reversed,
          statusBarBrightness: brightness,
          systemNavigationBarIconBrightness: brightness.reversed,
          systemNavigationBarColor: colorScheme.surface,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            width: 1,
            color: colorScheme.primary,
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: colorScheme.primary),
            borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
          ),
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondaryContainer,
          foregroundColor: colorScheme.onSecondaryContainer,
          elevation: 0,
          padding: const EdgeInsets.all(16),
          textStyle: const TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.all(GoogleFonts.montserrat(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ))
      ),
        canvasColor: AppConfig.primaryColor
    );
  }
}

extension on Brightness {
  Brightness get reversed =>
      this == Brightness.dark ? Brightness.light : Brightness.dark;
}
