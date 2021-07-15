import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:match_number/models/number_model.dart';
import 'package:match_number/ui/widgets/fancy_button.dart';

class Tile extends StatefulWidget {
  final NumberModel number;
  const Tile({required this.number, Key? key}) : super(key: key);

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> with TickerProviderStateMixin {
  late AnimationController _scaleAnimationController;
  late AnimationController _successAnimationController;

  @override
  void initState() {
    super.initState();
    _scaleAnimationController = AnimationController(
        vsync: this,
        lowerBound: 0.6,
        duration: const Duration(milliseconds: 500));
    _successAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    _scaleAnimationController.dispose();
    _successAnimationController.dispose();
    super.dispose();
  }

  void manageAnimation() {
    if (widget.number.isTouched) {
      _scaleAnimationController.forward();
    } else {
      _scaleAnimationController.reverse();
    }

    if (widget.number.isRotate) {
      _successAnimationController.forward();
    } else {
      _successAnimationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    manageAnimation();
    return Foo(
        number: widget.number,
        child: RotationTransition(
          turns: CurvedAnimation(
              curve: Curves.elasticInOut, parent: _successAnimationController),
          child: ScaleTransition(
              scale: CurvedAnimation(
                  parent: _scaleAnimationController,
                  curve: Curves.bounceOut,
                  reverseCurve: Curves.easeOut),
              child: FancyButton(
                color: getColor(widget.number.color),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      '${widget.number.numberValue}',
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              )),
        ));
  }

  Color getColor(int colorIndex) {
    switch (colorIndex) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.blue;

      case 3:
      default:
        return Colors.green;
    }
  }

  Color getGradienColor(int colorIndex) {
    switch (colorIndex) {
      case 1:
        return Colors.red.shade300;
      case 2:
        return Colors.blue.shade400;
      case 3:
      default:
        return Colors.teal.shade400;
    }
  }
}

class Foo extends SingleChildRenderObjectWidget {
  final NumberModel number;

  const Foo({required Widget child, required this.number, Key? key})
      : super(child: child, key: key);

  @override
  FooRenderer createRenderObject(BuildContext context) {
    return FooRenderer()..number = number;
  }

  @override
  void updateRenderObject(BuildContext context, FooRenderer renderObject) {
    renderObject.number = number;
  }
}

class FooRenderer extends RenderProxyBox {
  late NumberModel number;
}

class TileContent extends StatelessWidget {
  Color getColor(int colorIndex) {
    switch (colorIndex) {
      case 1:
        return const Color(0xFF99154E);
      case 2:
        return const Color(0xFF1A3263);

      case 3:
      default:
        return Colors.green;
    }
  }

  Color getGradienColor(int colorIndex) {
    switch (colorIndex) {
      case 1:
        return Colors.red.shade300;
      case 2:
        return Colors.blue.shade400;
      case 3:
      default:
        return Colors.teal.shade400;
    }
  }

  final NumberModel number;
  const TileContent(this.number);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: number.isTouched
                ? [Colors.grey[400]!, Colors.black12]
                : [getColor(number.color), getGradienColor(number.color)]),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        boxShadow: number.isTouched
            ? []
            : [
                BoxShadow(
                    color: getColor(number.color),
                    blurRadius: 1,
                    spreadRadius: 4),
              ],
      ),
      child: FittedBox(
          child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text('${number.numberValue}'),
      )),
    );
  }
}
