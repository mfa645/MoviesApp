import 'package:flutter/material.dart';
import 'package:movies_app/di/app_modules.dart';
import 'package:movies_app/presentation/view/film/film_search_page.dart';

void main() {
  AppModules().setup();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FilmsSearchPage(),
    );
  }
}
