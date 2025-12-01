import 'package:flutter/material.dart';

class Home1 extends StatefulWidget {
  const Home1({super.key});

  @override
  State<Home1> createState() => _Home1();
}

class _Home1 extends State<Home1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF242C3B),
      appBar: AppBar(
        title: Center(
          child: Text(
            "Electronic",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Color(0xFF242C3B),
      ),
    );
  }
}
