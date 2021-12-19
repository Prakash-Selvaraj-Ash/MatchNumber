import 'package:flutter/material.dart';
import 'package:match_number/ui/pages/game.dart';
import 'package:match_number/ui/pages/home.dart';
import 'package:match_number/ui/pages/stats.dart';
import 'package:match_number/ui/pages/tuto.dart';

// ignore: avoid_classes_with_only_static_members
class RouteCatalog {
  static String stats = '/stats';
  static String game = '/game';
  static String tuto = '/tuto';
  static String home = '/';
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case '/game':
        return MaterialPageRoute(builder: (_) => const Game());
      case '/tuto':
        return MaterialPageRoute(builder: (_) => const TutorialPage());
      case '/stats':
        return MaterialPageRoute(builder: (_) => StatsPage(arguments as int?));
      case '/':
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
