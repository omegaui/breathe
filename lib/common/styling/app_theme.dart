import 'package:breathe/core/services/storage/shared_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BreatheThemeExtension extends ThemeExtension<BreatheThemeExtension> {
  final Color backgroundColor;
  final Color borderColor;
  final Color primary;
  final Color textTitle;
  final Color textSubtitle;
  final Color chipBackground;
  final Color chipActiveBackground;
  final Color chipActiveBorder;
  final Color durationSelectorBackground;
  final Color durationSelectorBorder;
  final Color bubbleColor;
  final Color bubbleBorderColor;
  final Color indicatorBackground;
  final Color buttonBackground;
  final Color buttonTextColor;
  final BoxDecoration homePageBackgroundDecoration;

  const BreatheThemeExtension({
    required this.backgroundColor,
    required this.borderColor,
    required this.primary,
    required this.textTitle,
    required this.textSubtitle,
    required this.chipBackground,
    required this.chipActiveBackground,
    required this.chipActiveBorder,
    required this.durationSelectorBackground,
    required this.durationSelectorBorder,
    required this.bubbleColor,
    required this.bubbleBorderColor,
    required this.indicatorBackground,
    required this.buttonBackground,
    required this.buttonTextColor,
    required this.homePageBackgroundDecoration,
  });

  static const light = BreatheThemeExtension(
    backgroundColor: Colors.white,
    borderColor: Color(0x0A000000),
    primary: Color(0xFF630068),
    textTitle: Color(0xFF141414),
    textSubtitle: Color(0xFF737373),
    chipBackground: Color(0xFFF5F5F5),
    chipActiveBackground: Color(0xFFFFF8F0),
    chipActiveBorder: Color(0xFFE47B00),
    durationSelectorBackground: Color(0xFFF7F7F7),
    durationSelectorBorder: Color(0xFFF5F5F5),
    bubbleColor: Color(0xFF7B2D8E),
    bubbleBorderColor: Color(0x1F7B2D8E),
    indicatorBackground: Color(0xFFEEE5F0),
    buttonBackground: Color(0xFF630068),
    buttonTextColor: Color(0xFF2C002E),
    homePageBackgroundDecoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0x14630068), Color(0x14FF8A00)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
  );

  static const dark = BreatheThemeExtension(
    backgroundColor: Color(0x0DFFFFFF),
    borderColor: Color(0x0A000000),
    primary: Color(0xFFFFFFFF),
    textTitle: Color(0xFFFFFFFF),
    textSubtitle: Color(0xFFA3A3A3),
    chipBackground: Color(0xFF141414),
    chipActiveBackground: Color(0xFF5C2D00),
    chipActiveBorder: Color(0xFFE47B00),
    durationSelectorBackground: Color(0xFF141414),
    durationSelectorBorder: Color(0xFF292929),
    bubbleColor: Color(0xFFE2D1E3),
    bubbleBorderColor: Color(0x1F7B2D8E),
    indicatorBackground: Color(0xFFEEE5F0),
    buttonBackground: Color(0xFF813685),
    buttonTextColor: Color(0xFF2C002E),
    homePageBackgroundDecoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF21182D), Color(0xFF3D2760)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
  );

  @override
  BreatheThemeExtension copyWith({
    Color? backgroundColor,
    Color? borderColor,
    Color? primary,
    Color? textTitle,
    Color? textSubtitle,
    Color? chipBackground,
    Color? chipActiveBackground,
    Color? chipActiveBorder,
    Color? durationSelectorBackground,
    Color? durationSelectorBorder,
    Color? bubbleColor,
    Color? bubbleBorderColor,
    Color? indicatorBackground,
    Color? buttonBackground,
    Color? buttonTextColor,
    BoxDecoration? homePageBackgroundDecoration,
  }) {
    return BreatheThemeExtension(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      primary: primary ?? this.primary,
      textTitle: textTitle ?? this.textTitle,
      textSubtitle: textSubtitle ?? this.textSubtitle,
      chipBackground: chipBackground ?? this.chipBackground,
      chipActiveBackground: chipActiveBackground ?? this.chipActiveBackground,
      chipActiveBorder: chipActiveBorder ?? this.chipActiveBorder,
      durationSelectorBackground:
          durationSelectorBackground ?? this.durationSelectorBackground,
      durationSelectorBorder:
          durationSelectorBorder ?? this.durationSelectorBorder,
      bubbleColor: bubbleColor ?? this.bubbleColor,
      bubbleBorderColor: bubbleBorderColor ?? this.bubbleBorderColor,
      indicatorBackground: indicatorBackground ?? this.indicatorBackground,
      buttonBackground: buttonBackground ?? this.buttonBackground,
      buttonTextColor: buttonTextColor ?? this.buttonTextColor,
      homePageBackgroundDecoration:
          homePageBackgroundDecoration ?? this.homePageBackgroundDecoration,
    );
  }

  @override
  BreatheThemeExtension lerp(
    covariant BreatheThemeExtension? other,
    double t,
  ) {
    if (other == null) return this;
    return BreatheThemeExtension(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      textTitle: Color.lerp(textTitle, other.textTitle, t)!,
      textSubtitle: Color.lerp(textSubtitle, other.textSubtitle, t)!,
      chipBackground: Color.lerp(chipBackground, other.chipBackground, t)!,
      chipActiveBackground:
          Color.lerp(chipActiveBackground, other.chipActiveBackground, t)!,
      chipActiveBorder:
          Color.lerp(chipActiveBorder, other.chipActiveBorder, t)!,
      durationSelectorBackground: Color.lerp(
        durationSelectorBackground,
        other.durationSelectorBackground,
        t,
      )!,
      durationSelectorBorder:
          Color.lerp(durationSelectorBorder, other.durationSelectorBorder, t)!,
      bubbleColor: Color.lerp(bubbleColor, other.bubbleColor, t)!,
      bubbleBorderColor:
          Color.lerp(bubbleBorderColor, other.bubbleBorderColor, t)!,
      indicatorBackground:
          Color.lerp(indicatorBackground, other.indicatorBackground, t)!,
      buttonBackground:
          Color.lerp(buttonBackground, other.buttonBackground, t)!,
      buttonTextColor: Color.lerp(buttonTextColor, other.buttonTextColor, t)!,
      homePageBackgroundDecoration: t < 0.5
          ? homePageBackgroundDecoration
          : other.homePageBackgroundDecoration,
    );
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        extensions: const [BreatheThemeExtension.light],
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        extensions: const [BreatheThemeExtension.dark],
      );

  static bool get isLight => !Get.isDarkMode;

  static Future<void> toggle() async {
    final goingLight = Get.isDarkMode;
    Get.changeThemeMode(goingLight ? ThemeMode.light : ThemeMode.dark);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness:
            goingLight ? Brightness.dark : Brightness.light,
        systemNavigationBarIconBrightness:
            goingLight ? Brightness.dark : Brightness.light,
      ),
    );
    await Get.find<SharedStorage>().set('theme', goingLight ? 'light' : 'dark');
  }
}

extension BreatheThemeContext on BuildContext {
  BreatheThemeExtension get colors =>
      Theme.of(this).extension<BreatheThemeExtension>()!;

  bool get isLightMode => Theme.of(this).brightness == Brightness.light;
}
