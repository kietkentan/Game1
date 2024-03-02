import 'package:flutter/material.dart';
import '../view/ui/game_screen.dart';
import '../view/ui/splash_screen.dart';
import 'custom_route.dart';

class Routes {
  static dynamic route() {
    return {
      'SplashScreen': (BuildContext context) => const SplashScreen(),
    };
  }

  static Route? onGenerateRoute(RouteSettings settings) {
    final List<String> pathElements = settings.name!.split('/');
    if (pathElements[0] != '' || pathElements.length == 1) {
      return null;
    }
    switch (pathElements[1]) {
      case 'GameScreen':
        return CustomRoute<bool>(
            builder: (BuildContext context) => const GameScreen());
      case 'SplashScreen':
        return CustomRoute<bool>(
            builder: (BuildContext context) => const SplashScreen());
      default:
        return onUnknownRoute(const RouteSettings(name: '/GameScreen'));
    }
  }

  static Route onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text(""),
          centerTitle: true,
        ),
        body: Center(
          child: Text('${settings.name!.split('/')[1]} Comming soon..'),
        ),
      ),
    );
  }
}