import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:match_number/ui/route/app_route.dart';
import 'package:match_number/ui/widgets/fancy_button.dart';
import 'package:match_number/viewmodel/game_view_model.dart';

class GameOver extends StatelessWidget {
  const GameOver({
    Key? key,
    required GameViewModel gameViewModel,
  })  : _gameViewModel = gameViewModel,
        super(key: key);

  final GameViewModel _gameViewModel;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LimitedBox(
                maxHeight: 120,
                child: InkWell(
                  onTap: () {
                    _gameViewModel.createGame();
                  },
                  child: FancyButton(
                    color: Colors.teal,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.videogame_asset_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'New Game',
                            style: GoogleFonts.pressStart2p(),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              LimitedBox(
                maxHeight: 120,
                child: InkWell(
                  onTap: () {
                    Navigator.popAndPushNamed(context, RouteCatalog.stats,
                        arguments: _gameViewModel.score);
                  },
                  child: FancyButton(
                    color: Colors.teal,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.clear_sharp,
                            size: 50,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Quit Game',
                            style: GoogleFonts.pressStart2p(),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
