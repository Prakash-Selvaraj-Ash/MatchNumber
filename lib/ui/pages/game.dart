import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:match_number/ui/widgets/count_down.dart';
import 'package:match_number/ui/widgets/game_dash.dart';
import 'package:match_number/ui/widgets/game_grid.dart';
import 'package:match_number/ui/widgets/game_over.dart';
import 'package:match_number/ui/widgets/game_resume.dart';
import 'package:match_number/ui/widgets/safe_area_scaffold.dart';
import 'package:match_number/viewmodel/game_view_model.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> with WidgetsBindingObserver {
  final GameViewModel _gameViewModel = GameViewModel();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _gameViewModel.onResumed();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      default:
        _gameViewModel.onPaused();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _gameViewModel.createGame();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaScaffold(
      child: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: CountDown(
                      onDispose: () => _gameViewModel.dispose(),
                      timeListener: _gameViewModel.timeOutCommand,
                    ),
                  ),
                ),
                Expanded(child: GameDash(gameViewModel: _gameViewModel)),
                Expanded(
                    flex: 3, child: GameGrid(gameViewModel: _gameViewModel))
              ],
            ),
            ValueListenableBuilder<bool>(
                valueListenable: _gameViewModel.gamePausedOrOverCommand,
                builder: (context, target, _) {
                  if (target) {
                    return GameOver(gameViewModel: _gameViewModel);
                  } else {
                    return const SizedBox();
                  }
                }),
            ValueListenableBuilder<bool>(
                valueListenable: _gameViewModel.gameResumedCommand,
                builder: (context, target, _) {
                  if (target) {
                    return GameResume(gameViewModel: _gameViewModel);
                  } else {
                    return const SizedBox();
                  }
                })
          ],
        ),
      ),
    );
  }
}
