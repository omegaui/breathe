import 'dart:async';

import 'package:breathe/core/architecture/error_tracker.dart';
import 'package:breathe/core/injection/dependency_injection.dart';
import 'package:breathe/core/services/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    DependencyInjection.init();
    runApp(BreatheApp());
  }, ErrorTracker.track);
}

class BreatheApp extends StatefulWidget {
  const BreatheApp({super.key});

  @override
  State<BreatheApp> createState() => _BreatheAppState();
}

class _BreatheAppState extends State<BreatheApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (BuildContext context, Widget? child) {
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: child!,
                );
              },
            ),
          ],
        );
      },
      title: "Breate",
      initialRoute: Routes.init,
      getPages: RouteService.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
