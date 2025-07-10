import 'package:flutter/material.dart';

class Layout extends StatefulWidget {

  const Layout({super.key});

  @override
  State<StatefulWidget> createState() => LayoutState();

}

class LayoutState extends State<Layout> {

  @override
  Widget build(BuildContext context) {

    return GridView.count(
        crossAxisCount: 2,
        children: List.generate(9, (index) {
          return Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 8.0, horizontal: 5.0),
            child: SizedBox(
              child: FittedBox(
                child: FloatingActionButton.extended(
                  heroTag: '$index',
                  label: Text('$index'),
                  onPressed: () => print("OH GOD I'VE been PRESSED!"),
                ),
              ),
            )
          );
        }),
      );
  }

}