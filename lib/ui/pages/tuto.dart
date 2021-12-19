import 'package:flutter/material.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemBuilder: (context, item) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(child: Image.asset('assets/tuto${item + 1}.png')),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                            text: 'Blue',
                            style: TextStyle(color: Colors.blue, fontSize: 30)),
                        WidgetSpan(child: Padding(padding: EdgeInsets.all(8))),
                        TextSpan(
                            text: 'Indicates Addition',
                            style:
                                TextStyle(color: Colors.black, fontSize: 30)),
                        WidgetSpan(child: Padding(padding: EdgeInsets.all(8))),
                        TextSpan(
                            text: '\nRed',
                            style: TextStyle(color: Colors.red, fontSize: 30)),
                        WidgetSpan(child: Padding(padding: EdgeInsets.all(8))),
                        TextSpan(
                            text: 'Indicates Subtraction',
                            style:
                                TextStyle(color: Colors.black, fontSize: 30)),
                        WidgetSpan(child: Padding(padding: EdgeInsets.all(8))),
                        TextSpan(
                            text: '\nGreen',
                            style:
                                TextStyle(color: Colors.green, fontSize: 30)),
                        WidgetSpan(child: Padding(padding: EdgeInsets.all(8))),
                        TextSpan(
                            text: 'Indicates Multiplication',
                            style:
                                TextStyle(color: Colors.black, fontSize: 30)),
                        WidgetSpan(child: Padding(padding: EdgeInsets.all(8))),
                        TextSpan(
                            text:
                                '\nWith these Color combination, Match the given target to result. See the above reference to get how to match the target.',
                            style: TextStyle(color: Colors.black, fontSize: 22))
                      ])),
                    )
                  ],
                ),
              ),
              itemCount: 4,
            ),
          ),
        ],
      ),
    );
  }
}
