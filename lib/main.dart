import 'package:electronic/auth.dart';
import 'package:electronic/chat/chat1.dart';
import 'package:electronic/home/home2.dart';
import 'package:electronic/screen/signin_screen.dart';
import 'package:electronic/screen/signup_screen.dart';
import 'package:electronic/screen/userformscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:electronic/home/homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),

      home: const Auth(),
      routes: {
        // '/': (context) => const Auth(),
        'HomeScreen': (context) => const HomeScreen(),
        'SignupScreen': (context) => const SignupScreen(),
        'loginScreen': (context) => const SigninScreen(),
      },
    );
  }
}
