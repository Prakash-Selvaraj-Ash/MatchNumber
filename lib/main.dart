import 'package:flutter/material.dart';
import 'package:match_number/registration.dart';
import 'package:match_number/ui/route/app_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Registration().register();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Match My Number',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
          primarySwatch: Colors.grey,
          textTheme: Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.white, fontSizeFactor: 1.4)),
      theme: ThemeData(
          textTheme: Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.white, fontSizeFactor: 1.4)),
      onGenerateRoute: RouteCatalog.generateRoute,
      initialRoute: '/',
    );
  }
}

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [],
      ),
    );
  }
}
