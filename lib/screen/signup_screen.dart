// تجاهل تحذيرات معينة
// ignore_for_file: avoid_print
import 'package:electronic/screen/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'userFormScreen.dart'; // شاشة العميل

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // متحكمات الحقول
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // الدور المحدد: client أو sales
  String selectedRole = "";

  // الألوان المستخدمة
  static const _redColor = Color.fromARGB(255, 199, 29, 29);
  static const _blueColor = Color(0xff1976D2);

  // ظل مختصر للنصوص
  final _textShadow = [
    const Shadow(color: Colors.black, blurRadius: 0, offset: Offset(2, 2)),
  ];

  // رسالة خطأ تطابق كلمة المرور
  String? _passwordError;

  // دالة التسجيل
  Future<void> _signUp() async {
    // التحقق من تطابق كلمة المرور
    if (!_passwordConfirmed()) {
      setState(() {
        _passwordError = "كلمة المرور غير متطابقة";
      });
      return;
    }

    // التحقق من اختيار الدور
    if (selectedRole.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى اختيار Client أو Sales Point")),
      );
      return;
    }

    try {
      // إنشاء حساب في Firebase
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      // الانتقال حسب الدور
      if (selectedRole == "client") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UserFormScreen()),
        );
      } else if (selectedRole == "sales") {
        debugPrint("تم تسجيل Sales Point بنجاح");
      }
    } catch (e) {
      print('حدث خطأ أثناء التسجيل: $e');
    }
  }

  // التحقق من تطابق كلمة المرور
  bool _passwordConfirmed() {
    return _passwordController.text.trim() ==
        _confirmPasswordController.text.trim();
  }

  // الانتقال إلى شاشة تسجيل الدخول
  void _openLoginScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SigninScreen()),
    );
  }

  // إنشاء حقول الإدخال
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
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 8),
              child: Text(
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
            ),
        ],
      ),
    );
  }

  // إنشاء نصوص مع ظل
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
    // تحرير الموارد
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
        // تدرج أسفل الشاشة
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
                    // شعار التطبيق
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
                    // العنوان الرئيسي
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
                    const SizedBox(height: 30),
                    // أزرار اختيار الدور
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // زر Sales Point
                        SizedBox(
                          width: 150,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                selectedRole = "sales";
                              });
                            },
                            icon: const Icon(
                              Icons.point_of_sale,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Sales Point",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedRole == "sales"
                                  ? _blueColor
                                  : _redColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // زر Client
                        SizedBox(
                          width: 150,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                selectedRole = "client";
                              });
                            },
                            icon: const Icon(Icons.person, color: Colors.white),
                            label: const Text(
                              "Client",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedRole == "client"
                                  ? _blueColor
                                  : _redColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
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
                      errorText: _passwordError,
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
