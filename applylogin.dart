import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'homefirst.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signup() async {
    final url = Uri.parse('http://192.168.1.23:5000/signup'); // เปลี่ยนเป็น IP จริงถ้าใช้มือถือ

    // ✅ ตรวจสอบว่ากรอกข้อมูลครบหรือไม่
    if (_fullnameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ กรุณากรอกข้อมูลให้ครบทุกช่อง')),
      );
      return;
    }

    print("🔹 Sending request to: $url");
    print("🔹 Fullname: ${_fullnameController.text}");
    print("🔹 Age: ${_ageController.text}");
    print("🔹 Email: ${_emailController.text}");
    print("🔹 Phone: ${_phoneController.text}");
    print("🔹 Password: ${_passwordController.text}");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "fullname": _fullnameController.text,
        "age": int.tryParse(_ageController.text) ?? 0,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "password": _passwordController.text,
      }),
    );

    print("📌 Response Code: ${response.statusCode}");
    print("📌 Response Body: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ สมัครสมาชิกสำเร็จ!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ สมัครสมาชิกไม่สำเร็จ! ${data['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset('assets/image.png', height: 100), // Logo
                const SizedBox(height: 20),
                const Text(
                  'สมัครสมาชิก',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                _buildTextField(_fullnameController, 'ชื่อ-นามสกุล'),
                const SizedBox(height: 10),
                _buildTextField(_ageController, 'อายุ'),
                const SizedBox(height: 10),
                _buildTextField(_emailController, 'อีเมล'),
                const SizedBox(height: 10),
                _buildTextField(_phoneController, 'เบอร์โทรศัพท์'),
                const SizedBox(height: 10),
                _buildTextField(_passwordController, 'รหัสผ่าน', obscureText: true),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEACDA3),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'สมัครสมาชิก',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }
}
