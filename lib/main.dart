import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies_app/di/app_modules.dart';
import 'package:movies_app/presentation/navigation/navigation_routes.dart';

void main() {
  AppModules().setup();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return MaterialApp.router(
      theme: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
              selectionColor: Colors.blueAccent,
              selectionHandleColor: Colors.blueAccent)),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
