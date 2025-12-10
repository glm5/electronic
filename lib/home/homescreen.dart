import 'dart:async';
import 'package:electronic/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'home2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> images = [
    "images/image.png",
    "images/image1.png",
    "images/image2.png",
  ];

  final List<Map<String, String>> products = [
    {"img": "images/image.png", "name": "Arduino UNO"},
    {"img": "images/image1.png", "name": "LED High Power"},
    {"img": "images/image2.png", "name": "Sensor Module"},
  ];

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget categoryChip(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // انتقال بإنميشن احترافي
  void animatedPush(Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: Curves.easeInOut));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 41, 50, 67),
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
        backgroundColor: Color.fromARGB(255, 32, 39, 50),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home_Screen()),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------ Slider ------------------
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 300,
                  child: PageView(
                    controller: _pageController,
                    children: images.map((img) {
                      return Image.asset(img, fit: BoxFit.cover);
                    }).toList(),
                  ),
                ),
              ),
            ),

            // ------------------ New Ones Title ------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                "New ones",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 15),

            // ------------------ CATEGORY BUTTONS ------------------
            SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 14),
                children: [
                  categoryChip("All"),
                  SizedBox(width: 10),

                  // زر يفتح Home2
                  GestureDetector(
                    onTap: () => animatedPush(Home2()),
                    child: categoryChip("Electronic Components"),
                  ),
                  SizedBox(width: 10),

                  categoryChip("Computer Parts"),
                  SizedBox(width: 10),
                  categoryChip("Boards"),
                  SizedBox(width: 10),
                  categoryChip("Sensors"),
                ],
              ),
            ),

            SizedBox(height: 20),

            // ------------------ PRODUCTS LIST ------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: products.map((product) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 32, 39, 50),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: Image.asset(
                            product['img']!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            product['name']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
