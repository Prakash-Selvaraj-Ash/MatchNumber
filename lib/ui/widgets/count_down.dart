import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CountDown extends StatefulWidget {
  final ValueListenable<int> timeListener;
  final Function onDispose;
  const CountDown({
    Key? key,
    required this.onDispose,
    required this.timeListener,
  }) : super(key: key);

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late CurvedAnimation _animation;

  @override
  void initState() {
    super.initState();
    widget.timeListener.addListener(() {
      if (controller.status != AnimationStatus.dismissed &&
          widget.timeListener.value <= 0) {
        controller.stop();
      } else if (controller.status == AnimationStatus.dismissed) {
        controller.repeat();
      } else if (controller.status == AnimationStatus.forward &&
          !controller.isAnimating) {
        controller.repeat();
      }
    });
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic);
  }

  @override
  void dispose() {
    widget.onDispose();
    widget.timeListener.removeListener(() {});
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, snapshot) {
                    return CustomPaint(
                        painter: _CountDownTimer(_animation.value));
                  }),
            ),
            Align(
                alignment: FractionalOffset.center,
                child: ValueListenableBuilder<int>(
                    valueListenable: widget.timeListener,
                    builder: (context, value, snapshot) {
                      return Text(value.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold));
                    })),
          ],
        ),
      ),
    );
  }
}

class _CountDownTimer extends CustomPainter {
  final double animation;

  _CountDownTimer(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = Colors.white;
    final double progress = (1.0 - animation) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, -math.pi * 2.0, -progress, false, paint);
  }

  @override
  bool shouldRepaint(_CountDownTimer old) {
    return old != this;
  }
}
