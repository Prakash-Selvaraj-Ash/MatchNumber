import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:match_number/ui/route/app_route.dart';
import 'package:match_number/ui/widgets/safe_area_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideInTransition;
  late Animation<Offset> _slideOutTransition;
  late Brightness brightness;
  late bool isDarkModeOn;
  @override
  void initState() {
    super.initState();
    brightness = SchedulerBinding.instance!.window.platformBrightness;
    isDarkModeOn = brightness == Brightness.dark;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _slideInTransition = Tween<Offset>(
            begin: const Offset(-1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _slideOutTransition =
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _controller,
                curve: const Interval(0.4, 1, curve: Curves.easeOutCubic)));

    _controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaScaffold(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, RouteCatalog.game),
                  child: SlideTransition(
                    position: _slideInTransition,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.videogame_asset,
                            size: 60,
                            color: Colors.white,
                          ),
                          Text('New Game', style: GoogleFonts.pressStart2p())
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () =>
                            Navigator.pushNamed(context, RouteCatalog.tuto),
                        child: SlideTransition(
                          position: _slideOutTransition,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.pink[600],
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.book,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Tuto',
                                      style: GoogleFonts.pressStart2p(),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () =>
                            Navigator.pushNamed(context, RouteCatalog.stats),
                        child: SlideTransition(
                          position: _slideOutTransition,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.pink[600],
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.format_list_numbered,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Champion Board',
                                      style: GoogleFonts.pressStart2p(),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
