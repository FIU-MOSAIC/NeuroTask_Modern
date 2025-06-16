import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main Menu',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(0, 243, 243, 243),
        ),
      ),
      home: const MyHomePage(title: 'NueroTask'),
    );
  }
}
final List<String> arry = ["1", "2", "3", "4","5"];
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(left: 12, right: 12),
                child: FloatingActionButton.extended(
                  onPressed: () => print("Hello world"),
                  tooltip: "Log out of application",
                  isExtended: true,
                  label: Text("Log out"),
                  extendedPadding: EdgeInsets.symmetric(horizontal: (screenWidth * .02), vertical: (screenHeight * .01)),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: SingleChildScrollView(
          child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight * .8,
            minWidth: screenWidth,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: arry.map((index) =>
            FloatingActionButton.extended(
              onPressed: () => print("I've been pressed"),
              label: Text(index),
              icon: Icon(Icons.games_outlined),
              extendedPadding: EdgeInsets.symmetric(horizontal: (screenWidth * .4), vertical: (screenHeight * .3)),
            )
          ).toList(),
          )
        ),
      ),
      ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
