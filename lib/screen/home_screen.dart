import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:electronic/screen/signin_screen.dart'; // تأكد من المسار الصحيح

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  User? user;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? currentUser) {
      setState(() {
        user = currentUser;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      // إعادة التوجيه إلى SignInScreen
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SigninScreen(),
          ), // ✅ التصحيح هنا
        );
      });

      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('مرحباً، أنت مسجل الدخول', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              'البريد الإلكتروني: ${user!.email}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SigninScreen(),
                    ), // ✅ هنا أيضاً
                  );
                } catch (e) {
                  print('خطأ في تسجيل الخروج: $e');
                }
              },
              color: Colors.amber[900],
              child: Text('تسجيل الخروج'),
            ),
          ],
        ),
      ),
    );
  }
}
