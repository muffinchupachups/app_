import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'search.dart';
import 'homefirst.dart'; // ✅ ใช้ HomePage() แทน Home()
import 'profile.dart';
// import 'applylogin.dart';
// import 'profile2.dart';

void main() {
  runApp(const Addpicture());
}
class Addpicture extends StatefulWidget {
  const Addpicture({super.key});

  @override
  _AddPictureState createState() => _AddPictureState();
}

class _AddPictureState extends State<Addpicture> {
  File? _selectedImage;
  int _selectedIndex = 1; // ✅ กำหนดค่า index ของไอคอน "เพิ่มรูปภาพ"

  // ตัวแปรเก็บข้อมูลสัตว์
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _traitsController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  // ✅ ฟังก์ชันเปลี่ยนหน้าใน BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Addpicture()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Search()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  ProfileScreen(userId: 1),
        ));
        break;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitData() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ กรุณาเลือกภาพ')),
      );
      return;
    }

    try {
      // ✅ อัปโหลดรูปภาพไปที่เซิร์ฟเวอร์
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.23:5000/api/upload'),
      );

      request.files.add(await http.MultipartFile.fromPath('image', _selectedImage!.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = json.decode(await response.stream.bytesToString());
        String imageUrl = responseData['imageUrl'];

        // ✅ ส่งข้อมูลสัตว์ไปที่เซิร์ฟเวอร์
        final data = {
          'name': _nameController.text,
          'gender': _genderController.text,
          'age': _ageController.text,
          'traits': _traitsController.text,
          'details': _detailsController.text,
          'image': imageUrl,
        };

        final responsePost = await http.post(
          Uri.parse('http://192.168.1.23:5000/api/postdata'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data),
        );

        if (responsePost.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ บันทึกข้อมูลสำเร็จ')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ บันทึกข้อมูลล้มเหลว')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ อัปโหลดรูปภาพล้มเหลว')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ เกิดข้อผิดพลาด: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3D9C5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Column(
          children: [
            Image.asset(
              'assets/image.png',
              height: 75,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("เลือกภาพจากแกลเลอรี"),
            ),
            const SizedBox(height: 20),
            _selectedImage != null
                ? Image.file(_selectedImage!)
                : const Text("กรุณาเลือกภาพ"),
            const SizedBox(height: 20),
            _buildTextField(_nameController, 'ชื่อสัตว์'),
            _buildTextField(_genderController, 'เพศ'),
            _buildTextField(_ageController, 'อายุ'),
            _buildTextField(_traitsController, 'ลักษณะนิสัย'),
            _buildTextField(_detailsController, 'รายละเอียดข้อมูล'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: const Text("บันทึกข้อมูล"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped, // ✅ ใช้ฟังก์ชันที่แก้ไขแล้ว
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo),
            label: 'เพิ่มรูปภาพ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'ค้นหา',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'โปรไฟล์',
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
