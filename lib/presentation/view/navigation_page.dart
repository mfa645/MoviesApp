import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/presentation/widget/navigationbar/films_navigation_bar.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBody: true,
      body: widget.navigationShell,
      bottomNavigationBar: Stack(children: [
        Container(
          height: 75,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(167, 255, 255, 255),
                Colors.white,
              ],
              stops: [0, 0.5],
            ),
          ),
        ),
        FilmsNavigationBar(
            key: widget.key, navigationShell: widget.navigationShell),
      ]),
    ));
  }
}
