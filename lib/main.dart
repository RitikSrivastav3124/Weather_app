import 'package:flutter/material.dart';
import "whether_screen.dart";

void main() {
  runApp(const whetherApp());
}

class whetherApp extends StatelessWidget {
  const whetherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const WhetherScreen(),
    );
  }
}
