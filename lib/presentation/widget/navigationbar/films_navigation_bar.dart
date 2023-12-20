import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FilmsNavigationBar extends StatefulWidget {
  const FilmsNavigationBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<FilmsNavigationBar> createState() => _FilmsNavigationBarState();
}

class _FilmsNavigationBarState extends State<FilmsNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 70,
      elevation: 0,
      indicatorColor: Colors.blueAccent,
      backgroundColor: Colors.transparent,
      selectedIndex: widget.navigationShell.currentIndex,
      onDestinationSelected: (value) {
        widget.navigationShell.goBranch(value,
            initialLocation: value == widget.navigationShell.currentIndex);
      },
      destinations: const [
        NavigationDestination(
            icon: Icon(Icons.movie_outlined),
            selectedIcon: Icon(Icons.movie),
            label: "Home"),
        NavigationDestination(
            icon: Icon(Icons.search_off_outlined),
            selectedIcon: Icon(Icons.search_off),
            label: "Discover"),
        NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: "Favourites")
      ],
    );
  }
}
