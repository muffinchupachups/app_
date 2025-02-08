import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'profile.dart';
import 'applylogin.dart'; // ✅ เพิ่มหน้า Signup

class EditProfileScreen extends StatefulWidget {
  final int? userId; // ✅ เปลี่ยนเป็น nullable

  EditProfileScreen({this.userId});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _selectedImage;
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.userId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignupPage()),
        );
      });
    } else {
      _fetchUserProfile();
    }
  }

  // 📌 **ฟังก์ชันดึงข้อมูลโปรไฟล์จากฐานข้อมูล**
  Future<void> _fetchUserProfile() async {
    final response = await http.get(Uri.parse('http://192.168.1.23:5000/api/profile/${widget.userId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _fullnameController.text = data['fullname'] ?? '';
        _ageController.text = data['age']?.toString() ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
      });
    } else {
      print('❌ ดึงข้อมูลโปรไฟล์ล้มเหลว');
    }
  }

  // 📌 **ฟังก์ชันเลือกภาพโปรไฟล์**
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  //อัปเดตโปรไฟล์
  Future<void> _updateProfile() async {
    final response = await http.put(
      Uri.parse('http://192.168.1.23:5000/api/updateProfile/${widget.userId}'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'fullname': _fullnameController.text,
        'age': _ageController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'password': _passwordController.text.isEmpty ? null : _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen(userId: widget.userId!)),
      );
    } else {
      print('❌ อัปเดตโปรไฟล์ล้มเหลว');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3D9C5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3D9C5),
        elevation: 0,
        title: Text(
          'แก้ไขโปรไฟล์',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // รูปโปรไฟล์
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                child: _selectedImage == null ? Icon(Icons.person, size: 50, color: Colors.black) : null,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text('แก้ไขรูปภาพ', style: TextStyle(color: Colors.black)),
              ),
              SizedBox(height: 20),
              // ฟิลด์ข้อมูล
              _buildTextField('ชื่อ-นามสกุล', _fullnameController),
              _buildTextField('อายุ', _ageController),
              _buildTextField('อีเมล', _emailController),
              _buildTextField('เบอร์โทรศัพท์', _phoneController),
              _buildTextField('รหัสผ่าน (ถ้าต้องการเปลี่ยน)', _passwordController),
              SizedBox(height: 20),
              // ปุ่มบันทึกและยกเลิก
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen(userId: widget.userId!)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text('ยกเลิก', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text('บันทึก', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
