import 'package:flutter/material.dart';

class FancyButton extends StatefulWidget {
  const FancyButton({
    required this.child,
    required this.color,
  });

  final Widget child;
  final Color color;

  @override
  _FancyButtonState createState() => _FancyButtonState();
}

class _FancyButtonState extends State<FancyButton> {
  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10);

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ClipRRect(
          borderRadius: radius,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: _hslRelativeColor(l: 0.06),
                  borderRadius: radius,
                ),
                child: Container(),
              ),
              Transform.translate(
                offset: const Offset(0.0, 50.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _hslRelativeColor(),
                    borderRadius: radius,
                  ),
                  child: Container(),
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(child: widget.child)
      ],
    );
  }

  Color _hslRelativeColor({double h = 0.0, double s = 0.0, double l = 0.0}) {
    final hslColor = HSLColor.fromColor(widget.color);
    double _h = h;
    double _s = s;
    double _l = l;
    _h = (hslColor.hue + _h).clamp(0.0, 360.0);
    _s = (hslColor.saturation + _s).clamp(0.0, 1.0);
    _l = (hslColor.lightness + _l).clamp(0.0, 1.0);
    return HSLColor.fromAHSL(hslColor.alpha, _h, _s, _l).toColor();
  }
}
