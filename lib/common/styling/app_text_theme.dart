import 'package:flutter/material.dart';

class _AppTextTheme {
  _AppTextTheme._();

  static const Color foreground = Colors.black;
}

class FontSizes {
  FontSizes._();
  static const small = 12.0;
  static const regular = 14.0;
  static const medium = 15.0;
  static const base = 16.0;
  static const large = 24.0;
  static const xlarge = 36.0;
}

extension ConfigurableTextStyle on TextStyle {
  static Text generate(String text, double size) {
    return Text(text, style: create(size));
  }

  static TextStyle create(double size) {
    return TextStyle(
      fontSize: size,
      color: _AppTextTheme.foreground,
    ).useQuicksand().makeMedium();
  }

  TextStyle useQuicksand() {
    return copyWith(fontFamily: "Quicksand");
  }

  TextStyle useLato() {
    return copyWith(fontFamily: "Lato");
  }

  TextStyle useNative() {
    return copyWith(fontFamily: "Roboto");
  }

  TextStyle withColor(Color color) {
    return copyWith(color: color);
  }

  TextStyle makeBold() {
    return copyWith(fontWeight: FontWeight.bold);
  }

  TextStyle makeSemiBold({bool Function()? onlyIf}) {
    if (onlyIf == null || onlyIf()) {
      return copyWith(fontWeight: FontWeight.w600);
    }
    return this;
  }

  TextStyle makeItalic() {
    return copyWith(fontStyle: FontStyle.italic);
  }

  TextStyle makeExtraBold() {
    return copyWith(fontWeight: FontWeight.w800);
  }

  TextStyle makeMedium() {
    return copyWith(fontWeight: FontWeight.w500);
  }

  TextStyle fontSize(double size) {
    return copyWith(fontSize: size);
  }

  static TextStyle forButton() {
    return create(16).withColor(Colors.white).makeMedium().useLato();
  }
}
