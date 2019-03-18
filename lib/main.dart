import 'package:flutter/material.dart';
import 'package:gif_lovers/ui/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        hintColor: Color(0xFF970342)
      ),
    )
  );
}