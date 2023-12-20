import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:movies_app/presentation/navigation/navigation_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 70, 69, 69),
      body: Expanded(
        child: Center(
          child: Column(
            children: [
              Lottie.asset("assets/lottie/splash_animation.json",
                  repeat: true, animate: true),
              const Text(
                "Movies app",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _navigateToNextPage() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      context.go(NavigationRoutes.HOME_ROUTE);
    }
  }
}
