import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreen();
}

class _SigninScreen extends State<SigninScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  static const _redColor = Color.fromARGB(255, 199, 29, 29);
  static const _blueColor = Color(0xff1976D2);

  final _textShadow = [
    const Shadow(color: Colors.black, blurRadius: 0, offset: Offset(2, 2)),
  ];

  // رسائل الخطأ لكل حقل
  String? _emailError;
  String? _passwordError;

  Future<void> _signIn() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    bool hasError = false;

    if (_emailController.text.trim().isEmpty) {
      _emailError = "هذا الحقل مطلوب";
      hasError = true;
    }
    if (_passwordController.text.trim().isEmpty) {
      _passwordError = "هذا الحقل مطلوب";
      hasError = true;
    }

    if (hasError) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      // تسجيل الدخول ناجح، اذهب إلى الصفحة الرئيسية
      Navigator.pushReplacementNamed(context, 'HomeScreen');
    } on FirebaseAuthException catch (_) {
      // إذا كان الإيميل أو الباسورد خطأ
      setState(() {
        _emailError = "الإيميل أو كلمة المرور غير صحيحة";
        _passwordError = "الإيميل أو كلمة المرور غير صحيحة";
      });
    }
  }

  void _openSignupScreen() {
    Navigator.of(context).pushReplacementNamed('SignupScreen');
  }

  Widget _buildInputField(
    TextEditingController controller,
    String hint, {
    bool isPassword = false,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
          const SizedBox(height: 0),
          if (errorText != null)
            Text(
              errorText,
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 15,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(offset: Offset(-1, -1), color: Colors.black),
                  Shadow(offset: Offset(1, -1), color: Colors.black),
                  Shadow(offset: Offset(1, 1), color: Colors.black),
                  Shadow(offset: Offset(-1, 1), color: Colors.black),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildText(
    String text, {
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.white,
  }) {
    return Text(
      text,
      style: TextStyle(
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('images/SMA.png', fit: BoxFit.cover),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.3,
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
                    _buildText(
                      'WELCOME',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    _buildText('Please sign in to continue', fontSize: 16),
                    const SizedBox(height: 40),
                    _buildInputField(
                      _emailController,
                      "Email",
                      errorText: _emailError,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      _passwordController,
                      "Password",
                      isPassword: true,
                      errorText: _passwordError,
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: GestureDetector(
                        onTap: _signIn,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _blueColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: _buildText(
                              'SIGN IN',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildText('Not yet a member?  '),
                        GestureDetector(
                          onTap: _openSignupScreen,
                          child: _buildText(
                            'Sign up now',
                            color: _redColor,
                            fontWeight: FontWeight.bold,
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
