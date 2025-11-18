// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // الثوابت المستخدمة
  static const _redColor = Color.fromARGB(255, 199, 29, 29);
  static const _blueColor = Color(0xff1976D2);

  // ظل مختصر
  final _textShadow = [
    const Shadow(color: Colors.black, blurRadius: 0, offset: Offset(2, 2)),
  ];

  Future<void> _signUp() async {
    if (_passwordConfirmed()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // التحقق من mounted قبل استخدام context
        if (mounted) {
          Navigator.of(context).pushNamed('/');
        }
      } catch (e) {
        // معالجة الأخطاء
        print('Error during sign up: $e');
      }
    }
  }

  bool _passwordConfirmed() {
    return _passwordController.text.trim() ==
        _confirmPasswordController.text.trim();
  }

  void _openLoginScreen() {
    Navigator.of(context).pushReplacementNamed('LoginScreen');
  }

  // دالة مساعدة لإنشاء حقول الإدخال
  Widget _buildInputField(
    TextEditingController controller,
    String hint, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
            ),
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء النص
  Widget _buildText(
    String text, {
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.white,
  }) {
    return Text(
      text,
      style: GoogleFonts.robotoCondensed(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        shadows: _textShadow,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الخلفية
        Positioned.fill(
          child: Image.asset('images/SMA.png', fit: BoxFit.cover),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.3, // 30% من الشاشة
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color.fromRGBO(25, 118, 210, 0.7),
                  Color.fromRGBO(25, 118, 210, 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // الصورة
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset(
                        'images/USA.png',
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // العنوان
                    _buildText(
                      'SIGN UP',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 7),
                    _buildText(
                      'Welcome here you can sign up',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 50),

                    // حقول الإدخال
                    _buildInputField(_emailController, "Email"),
                    const SizedBox(height: 15),
                    _buildInputField(
                      _passwordController,
                      "Password",
                      isPassword: true,
                    ),
                    const SizedBox(height: 10),
                    _buildInputField(
                      _confirmPasswordController,
                      "Confirm Password",
                      isPassword: true,
                    ),
                    const SizedBox(height: 15),

                    // زر التسجيل
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: GestureDetector(
                        onTap: _signUp,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _blueColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: _buildText(
                              'SIGN UP',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // رابط تسجيل الدخول
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildText('Already a member?  ', fontSize: 17.8),
                        GestureDetector(
                          onTap: _openLoginScreen,
                          child: _buildText(
                            'Sign in here',
                            color: _redColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
