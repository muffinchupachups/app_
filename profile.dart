import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectss/applylogin.dart';
import 'profile2.dart';
import 'homefirst.dart';
import 'search.dart';
import 'addpicture.dart';
import 'apppage.dart';

void main() {
  runApp(Profile(userId: null )); // ตั้งค่า userId ทดสอบ (เปลี่ยนตามจริง)
}

class Profile extends StatelessWidget {
  final int? userId;
  Profile({this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: userId == null ? SignupPage() : ProfileScreen(userId: userId!),
    );

  }
}

class ProfileScreen extends StatefulWidget {
  final int userId; // ✅ เพิ่ม userId

  ProfileScreen({required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  // 📌 **ฟังก์ชันดึงข้อมูลโปรไฟล์จากฐานข้อมูล**
  Future<void> _fetchUserProfile() async {
    final response = await http.get(Uri.parse('http://192.168.1.23:5000/api/profile/${widget.userId}'));

    if (response.statusCode == 200) {
      setState(() {
        userData = json.decode(response.body);
      });
    } else {
      print('❌ ดึงข้อมูลไม่สำเร็จ');
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
          'โปรไฟล์',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator()) // ✅ แสดง Loading ตอนโหลดข้อมูล
          : Column(
        children: [
          SizedBox(height: 20),
          // รูปโปรไฟล์
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
          ),
          SizedBox(height: 20),
          // ข้อมูลผู้ใช้
          Text('ชื่อ: ${userData!['fullname']}'),
          Text('อายุ: ${userData!['age']}'),
          Text('อีเมล: ${userData!['email']}'),
          Text('เบอร์โทร: ${userData!['phone']}'),
          SizedBox(height: 20),
          // ปุ่มแก้ไขโปรไฟล์
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProfileScreen(userId: widget.userId)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text('แก้ไขโปรไฟล์', style: TextStyle(color: Colors.black)),
          ),
          SizedBox(height: 20),
          // ปุ่มออกจากระบบ
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Apppage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Text('ออกจากระบบ', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.search, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Search()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Addpicture()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
