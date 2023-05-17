import 'package:flutter/material.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const Homepage(),
    );
  }
}

class SliderData extends ChangeNotifier {
  double _value = 0.0;
  double get value => _value;
  set value(double newvalue) {
    if (newvalue != _value) {
      _value = newvalue;
      notifyListeners();
    }
  }
}

final sliderData = SliderData();

class SliderInheritedWidget extends InheritedNotifier<SliderData> {
  const SliderInheritedWidget({
    Key? key,
    required Widget child,
    required SliderData sliderData,
  }) : super(
          key: key,
          child: child,
          notifier: sliderData,
        );
  static double of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<SliderInheritedWidget>()
          ?.notifier
          ?.value ??
      0.0;
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Homepage'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SliderInheritedWidget(
          sliderData: sliderData,
          child: Builder(builder: (context) {
            return Column(
              children: [
                Slider(
                    value: SliderInheritedWidget.of(context),
                    onChanged: (value) {
                      sliderData.value = value;
                    }),
                Row(
                  children: [
                    Opacity(
                      opacity: SliderInheritedWidget.of(context),
                      child: Container(
                        height: 150,
                        color: Colors.blue,
                      ),
                    ),
                    Opacity(
                      opacity: SliderInheritedWidget.of(context),
                      child: Container(
                        height: 150,
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ].expandRandomly().toList(),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

extension Expandrandomly on Iterable<Widget> {
  Iterable<Widget> expandRandomly() => map(
        (w) => Expanded(
          child: w,
        ),
      );
}
