import 'package:flutter/material.dart';

class AdaptiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  const AdaptiveLayout(
      {required this.mobile,
      required this.tablet,
      required this.desktop,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 840) {
        return desktop;
      } else if (constraints.maxWidth > 500) {
        return tablet;
      } else {
        return mobile;
      }
    });
  }
}
