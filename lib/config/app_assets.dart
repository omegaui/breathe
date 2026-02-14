import 'package:flutter/material.dart';

class AppAssets {
  AppAssets._();

  static const String logo = 'assets/icons/logo.png';

  // icons
  static const AssetImage arrowDown = AssetImage('assets/icons/arrow_down.png');
  static const AssetImage arrowUp = AssetImage('assets/icons/arrow_up.png');
  static const AssetImage fastWind = AssetImage('assets/icons/fast_wind.png');
  static const AssetImage darkMode = AssetImage('assets/icons/dark_mode.png');
  static const AssetImage lightMode = AssetImage('assets/icons/light_mode.png');
  static const AssetImage play = AssetImage('assets/icons/play.png');
  static const AssetImage pause = AssetImage('assets/icons/pause.png');

  // artworks, I had to deliver the app quick and complete, so I edited your figma file with a local copy
  // so that I do not need to figure out extact positioning of clouds :)
  // this asset isn't yet utilized
  static const AssetImage lightBackground = AssetImage(
    'assets/artworks/light_artwork.png',
  );

  // sounds
  static const String chimeSound = 'assets/sounds/chime.mp3';

  // animations
  static const String completionAnimation =
      'assets/animations/completion.json';
}
