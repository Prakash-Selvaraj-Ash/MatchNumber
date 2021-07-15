import 'package:flutter/material.dart';
import 'package:match_number/ui/widgets/fancy_button.dart';
import 'package:match_number/viewmodel/game_view_model.dart';

class GameDash extends StatelessWidget {
  const GameDash({
    Key? key,
    required GameViewModel gameViewModel,
  })  : _gameViewModel = gameViewModel,
        super(key: key);

  final GameViewModel _gameViewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder<int>(
                valueListenable: _gameViewModel.targetCommand,
                builder: (context, target, _) {
                  return FancyButton(
                    color: Colors.deepPurple,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Target',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        getText(target, context),
                      ],
                    ),
                  );
                }),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder<int>(
                valueListenable: _gameViewModel.scoreCommand,
                builder: (context, target, _) {
                  return FancyButton(
                      color: Colors.teal,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Score',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          getText(target, context),
                        ],
                      ));
                }),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder<int>(
                valueListenable: _gameViewModel.outputCommand,
                builder: (context, target, _) {
                  return FancyButton(
                      color: Colors.brown,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Result',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          getText(target, context),
                        ],
                      ));
                }),
          ),
        )
      ],
    );
  }

  Text getText(int target, BuildContext context) {
    return Text(
      '$target',
      style: Theme.of(context)
          .textTheme
          .headline5!
          .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}
