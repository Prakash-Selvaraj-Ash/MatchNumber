import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:match_number/models/number_model.dart';
import 'package:match_number/ui/widgets/tile.dart';
import 'package:match_number/viewmodel/game_view_model.dart';

import 'adaptive_layout.dart';

class GameGrid extends StatefulWidget {
  final GameViewModel _gameViewModel;
  const GameGrid({required GameViewModel gameViewModel})
      : _gameViewModel = gameViewModel;

  @override
  _GameGridState createState() => _GameGridState();
}

class _GameGridState extends State<GameGrid> {
  final key = GlobalKey();
  void _detectMoveItem(PointerEvent event) {
    final renderer = getRenderer(event);
    if (renderer != null) {
      widget._gameViewModel.onMouseMove.execute(renderer.number.numberIndex);
    }
  }

  void _detectTapedItem(PointerEvent event) {
    final renderer = getRenderer(event);
    if (renderer != null) {
      widget._gameViewModel.onMouseDown.execute(renderer.number.numberIndex);
    }
  }

  void _clearSelection(PointerUpEvent event) {
    widget._gameViewModel.onMouseUp.execute();
  }

  FooRenderer? getRenderer(PointerEvent event) {
    final RenderBox box = key.currentContext!.findRenderObject()! as RenderBox;
    final result = BoxHitTestResult();
    final Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        final target = hit.target;
        if (target is FooRenderer) {
          return target;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Listener(
        onPointerDown: _detectTapedItem,
        onPointerMove: _detectMoveItem,
        onPointerUp: _clearSelection,
        child: AdaptiveLayout(
          mobile: buildGridTile(3 / 2.5),
          tablet: buildGridTile(4 / 2.5),
          desktop: buildGridTile(3),
        ),
      );
    });
  }

  GridView buildGridTile(double aspectRatio) {
    return GridView.builder(
      key: key,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget._gameViewModel.numbers.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: 3.0,
        mainAxisSpacing: 3.0,
      ),
      itemBuilder: (context, index) {
        final listenable = widget._gameViewModel.tileCommands[index];
        return ValueListenableBuilder<NumberModel>(
            valueListenable: listenable,
            builder: (context, model, _) {
              return Tile(number: model);
            });
      },
    );
  }
}
