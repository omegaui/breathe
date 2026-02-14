import 'package:breathe/core/services/storage/shared_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// TOOD: Dark mode not yet complete!

abstract class AppTheme {
  Color get backgroundColor;
  Color get borderColor;
  Color get primary;
  Color get textTitle;
  Color get textSubtitle;
  Color get chipBackground;
  Color get chipActiveBackground;
  Color get chipActiveBorder;
  Color get durationSelectorBackground;
  Color get durationSelectorBorder;
  Color get bubbleColor;
  Color get bubbleBorderColor;
  Color get indicatorBackground;
  Color get buttonBackground;
  Color get buttonTextColor;
  BoxDecoration get homePageBackgroundDecoration;

  static bool get isLight => _instance.runtimeType == LightTheme;

  static AppTheme _instance = LightTheme(); // default is light
  static AppTheme get instance => _instance;
  static void init(bool isLight) {
    if (isLight) {
      _instance = LightTheme();
    } else {
      _instance = DarkTheme();
    }
  }

  static final List<VoidCallback> _listeners = [];
  
  static Future<void> toggle() async {
    if (isLight) {
      _instance = DarkTheme();
    } else {
      _instance = LightTheme();
    }
    for (final listener in _listeners) {
      listener();
    }
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
        systemNavigationBarIconBrightness: isLight
            ? Brightness.dark
            : Brightness.light,
      ),
    );
    await Get.find<SharedStorage>().set('theme', isLight ? 'light' : 'dark');
  }

  static void watchToggle(VoidCallback onChange) {
    _listeners.add(onChange);
  }

  static void unwatchToggle(VoidCallback onChange) {
    _listeners.remove(onChange);
  }
}

class LightTheme extends AppTheme {
  @override
  Color get backgroundColor => Colors.white;

  @override
  Color get borderColor => Colors.black.withAlpha((0.04 * 255.0).round());

  @override
  Color get primary => Color(0xFF630068);

  @override
  Color get textTitle => Color(0xFF141414);

  @override
  Color get textSubtitle => Color(0xFF737373);

  @override
  Color get chipBackground => Color(0xFFF5F5F5);

  @override
  Color get chipActiveBackground => Color(0xFFFFF8F0);

  @override
  Color get chipActiveBorder => Color(0xFFE47B00);

  @override
  Color get durationSelectorBackground => Color(0xFFF7F7F7);

  @override
  Color get durationSelectorBorder => Color(0xFFF5F5F5);

  @override
  Color get bubbleColor => Color(0xFF7B2D8E);

  @override
  Color get bubbleBorderColor =>
      Color(0xFF7B2D8E).withAlpha((0.12 * 255).round());

  @override
  Color get indicatorBackground => Color(0xFFEEE5F0);

  @override
  Color get buttonBackground => Color(0xFF630068);

  @override
  Color get buttonTextColor => Color(0xFF2C002E);

  @override
  BoxDecoration get homePageBackgroundDecoration => BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFF630068).withAlpha((0.08 * 255).round()),
        Color((0xFFFF8A00)).withAlpha((0.08 * 255).round()),
      ],
      begin: .topCenter,
      end: .bottomCenter,
    ),
  );
}

class DarkTheme extends AppTheme {
  @override
  Color get backgroundColor => Colors.white.withAlpha((0.05 * 255).round());

  @override
  Color get borderColor => Colors.black.withAlpha((0.04 * 255.0).round());

  @override
  Color get primary => Color(0xFFFFFFFF);

  @override
  Color get textTitle => Color(0xFFFFFFFF);

  @override
  Color get textSubtitle => Color(0xFFA3A3A3);

  @override
  Color get chipBackground => Color(0xFF141414);

  @override
  Color get chipActiveBackground => Color(0xFF5C2D00);

  @override
  Color get chipActiveBorder => Color(0xFFE47B00);

  @override
  Color get durationSelectorBackground => Color(0xFF141414);

  @override
  Color get durationSelectorBorder => Color(0xFF292929);

  @override
  Color get bubbleColor => Color(0xFFE2D1E3);

  @override
  Color get bubbleBorderColor =>
      Color(0xFF7B2D8E).withAlpha((0.12 * 255).round());

  @override
  Color get indicatorBackground => Color(0xFFEEE5F0);

  @override
  Color get buttonBackground => Color(0xFF813685);

  @override
  Color get buttonTextColor => Color(0xFF2C002E);

  @override
  BoxDecoration get homePageBackgroundDecoration => BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF21182D), Color((0xFF3D2760))],
      begin: .topCenter,
      end: .bottomCenter,
    ),
  );
}
