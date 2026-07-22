import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opdsure/config/app_design_system.dart';

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
    fontFamily: AppDesign.fontFamily,
    fontFamilyFallback: ['Roboto', 'NotoEmoji'],
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

  static const Duration animationDuration = Duration(milliseconds: 350);
  static const Curve animationCurve = Curves.easeOutCubic;

  static ThemeData buildTheme(
    BuildContext context,
    Brightness brightness, [
    Color? seed,
  ]) {
    final colorScheme = ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: seed ?? AppDesign.primary,
      primary: AppDesign.primary,
      secondary: AppDesign.accent,
      surface: AppDesign.surface,
      error: AppDesign.error,
    );

    return ThemeData(
      visualDensity: VisualDensity.standard,
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: AppDesign.fontFamily,
      scaffoldBackgroundColor: AppDesign.background,
      canvasColor: AppDesign.surface,

      // Text Theme
      textTheme: _buildTextTheme(brightness),

      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 64,
        titleTextStyle: AppDesign.titleLg.copyWith(
          color: AppDesign.textPrimary,
        ),
        iconTheme: const IconThemeData(
          color: AppDesign.textPrimary,
          size: 22,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: brightness.reversed,
          statusBarBrightness: brightness,
          systemNavigationBarIconBrightness: brightness.reversed,
          systemNavigationBarColor: AppDesign.background,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppDesign.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppDesign.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesign.spacingXxl,
            vertical: AppDesign.spacingLg,
          ),
          minimumSize: const Size(double.infinity, 52),
          textStyle: AppDesign.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppDesign.primary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesign.spacingXxl,
            vertical: AppDesign.spacingLg,
          ),
          minimumSize: const Size(double.infinity, 52),
          textStyle: AppDesign.button.copyWith(color: AppDesign.primary),
          side: const BorderSide(color: AppDesign.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppDesign.primary,
          textStyle: AppDesign.titleMd,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusSm),
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppDesign.inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDesign.spacingLg,
          vertical: AppDesign.spacingLg,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          borderSide: const BorderSide(color: AppDesign.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          borderSide: const BorderSide(color: AppDesign.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          borderSide: const BorderSide(color: AppDesign.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          borderSide: const BorderSide(color: AppDesign.error),
        ),
        hintStyle: AppDesign.bodyMd.copyWith(color: AppDesign.textTertiary),
        labelStyle: AppDesign.labelSm,
        errorStyle: AppDesign.bodySm.copyWith(color: AppDesign.error),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        ),
        elevation: 4,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusXl),
        ),
        titleTextStyle: AppDesign.headingSm,
        contentTextStyle: AppDesign.bodyLg,
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppDesign.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDesign.radiusXxl),
          ),
        ),
        elevation: 8,
      ),

      // Popup Menu
      popupMenuTheme: PopupMenuThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        ),
        color: AppDesign.card,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppDesign.divider,
        thickness: 1,
        space: 1,
      ),

      // Navigation Bar
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppDesign.card,
        elevation: 0,
        indicatorColor: AppDesign.accentLight,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppDesign.labelSm.copyWith(
              color: AppDesign.primary,
              fontWeight: FontWeight.w600,
            );
          }
          return AppDesign.labelSm.copyWith(color: AppDesign.textTertiary);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppDesign.primary, size: 24);
          }
          return const IconThemeData(color: AppDesign.textTertiary, size: 24);
        }),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppDesign.surface,
        selectedColor: AppDesign.accentLight,
        labelStyle: AppDesign.labelSm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusFull),
        ),
        side: const BorderSide(color: AppDesign.divider),
      ),

      // TabBar
      tabBarTheme: TabBarThemeData(
        labelColor: AppDesign.primary,
        unselectedLabelColor: AppDesign.textTertiary,
        labelStyle: AppDesign.titleMd,
        unselectedLabelStyle: AppDesign.bodyMd,
        indicatorColor: AppDesign.primary,
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }

  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseColor =
        brightness == Brightness.light ? AppDesign.textPrimary : Colors.white;

    return TextTheme(
      displayLarge: AppDesign.headingLg.copyWith(color: baseColor),
      displayMedium: AppDesign.headingMd.copyWith(color: baseColor),
      displaySmall: AppDesign.headingSm.copyWith(color: baseColor),
      headlineMedium: AppDesign.headingSm.copyWith(color: baseColor),
      headlineSmall: AppDesign.titleLg.copyWith(color: baseColor),
      titleLarge: AppDesign.titleLg.copyWith(color: baseColor),
      titleMedium: AppDesign.titleMd.copyWith(color: baseColor),
      titleSmall: AppDesign.labelLg.copyWith(color: baseColor),
      bodyLarge: AppDesign.bodyLg.copyWith(color: baseColor),
      bodyMedium: AppDesign.bodyMd.copyWith(color: baseColor),
      bodySmall: AppDesign.bodySm,
      labelLarge: AppDesign.button.copyWith(color: baseColor),
      labelSmall: AppDesign.labelSm,
    );
  }
}

extension on Brightness {
  Brightness get reversed =>
      this == Brightness.dark ? Brightness.light : Brightness.dark;
}
