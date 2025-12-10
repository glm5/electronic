import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({super.key});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  // تحكم بالخانات
  final _firstNameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _thirdNameController = TextEditingController();
  final _fourthNameController = TextEditingController();
  final _phoneController = TextEditingController();

  File? _pickedImage;
  String? _location;

  static const _blueColor = Color(0xff1976D2);
  static const _redColor = Color.fromARGB(255, 199, 29, 29);

  final _textShadow = [
    const Shadow(color: Colors.black, blurRadius: 0, offset: Offset(2, 2)),
  ];

  final ImagePicker _picker = ImagePicker();

  // رسائل الأخطاء لكل خانة
  String? _firstNameError;
  String? _secondNameError;
  String? _thirdNameError;
  String? _fourthNameError;
  String? _phoneError;

  // رفع صورة
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  // الموقع
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _location = '${position.latitude},${position.longitude}';
    });
  }

  // التحقق من صحة الحقول
  bool _validateFields() {
    bool hasError = false;
    setState(() {
      _firstNameError = _firstNameController.text.trim().isEmpty
          ? "هذا الحقل مطلوب"
          : null;
      _secondNameError = _secondNameController.text.trim().isEmpty
          ? "هذا الحقل مطلوب"
          : null;
      _thirdNameError = _thirdNameController.text.trim().isEmpty
          ? "هذا الحقل مطلوب"
          : null;
      _fourthNameError = _fourthNameController.text.trim().isEmpty
          ? "هذا الحقل مطلوب"
          : null;

      String phone = _phoneController.text.trim();
      if (phone.isEmpty) {
        _phoneError = "هذا الحقل مطلوب";
        hasError = true;
      } else if (phone.length != 9) {
        _phoneError = "رقم الهاتف يجب أن يكون 9 أرقام";
        hasError = true;
      } else {
        _phoneError = null;
      }

      if (_firstNameError != null ||
          _secondNameError != null ||
          _thirdNameError != null ||
          _fourthNameError != null) {
        hasError = true;
      }
    });
    return !hasError;
  }

  // زر Submit
  void _submitForm() {
    if (_validateFields()) {
      Navigator.pushReplacementNamed(context, 'HomeScreen');
    }
  }

  // دالة لبناء الحقول مع مساحة ثابتة لرسائل الخطأ
  Widget _buildInputField(
    TextEditingController controller,
    String hint, {
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: controller,
                obscureText: isPassword,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8), // مساحة ثابتة لرسالة الخطأ
          Text(
            errorText ?? '',
            style: const TextStyle(
              color: Color.fromARGB(255, 253, 253, 253),
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

  // حقل الهاتف مع +967 واضح دائمًا
  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Text(
                    "+967 ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Phone",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _phoneError ?? '',
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 0, 0),
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
    _firstNameController.dispose();
    _secondNameController.dispose();
    _thirdNameController.dispose();
    _fourthNameController.dispose();
    _phoneController.dispose();
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
                colors: const [
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
                  children: [
                    const SizedBox(height: 40),
                    _buildText(
                      'User Profile',
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),

                    // الاسم مقسم 4 خانات على صفين
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildInputField(
                                _firstNameController,
                                "First",
                                errorText: _firstNameError,
                              ),
                            ),
                            const SizedBox(width: 0),
                            Expanded(
                              child: _buildInputField(
                                _secondNameController,
                                "Second",
                                errorText: _secondNameError,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 0),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInputField(
                                _thirdNameController,
                                "Third",
                                errorText: _thirdNameError,
                              ),
                            ),
                            const SizedBox(width: 0),
                            Expanded(
                              child: _buildInputField(
                                _fourthNameController,
                                "Fourth",
                                errorText: _fourthNameError,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    // حقل الهاتف المعدل
                    _buildPhoneField(),

                    const SizedBox(height: 15),

                    // رفع الصورة
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: _blueColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: _buildText(
                              _pickedImage == null
                                  ? 'Upload Background Image'
                                  : 'Image Selected',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // الموقع
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: GestureDetector(
                        onTap: _getCurrentLocation,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: _redColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: _buildText(
                              _location ?? 'Get Current Location',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // زر Submit
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: GestureDetector(
                        onTap: _submitForm,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _blueColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: _buildText(
                              'Submit',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
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
