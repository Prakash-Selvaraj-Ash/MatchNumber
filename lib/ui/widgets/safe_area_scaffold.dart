import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SafeAreaScaffold extends StatelessWidget {
  final Widget child;
  const SafeAreaScaffold({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.white,
          ),
          child: child),
    );
  }
}
