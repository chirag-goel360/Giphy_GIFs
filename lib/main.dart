import 'package:flutter/material.dart';
import 'package:giphy/giphy_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Giphy GIFs',
      debugShowCheckedModeBanner: false,
      home: GiphyPage(),
    );
  }
}
