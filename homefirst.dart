import 'package:flutter/material.dart';
import 'search.dart'; // Import search.dart
import 'profile.dart'; // Import profile.dart
import 'addpicture.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3D9C5), // สีพื้นหลังเบจ
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo Section
              Column(
                children: [
                  Image.asset(
                    'assets/image.png', // โลโก้ CAT DOG
                    height: 100,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              const SizedBox(height: 20),

              // Profile Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // CircleAvatar for Profile
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/profile.jpg'), // รูปโปรไฟล์
                  ),
                  const SizedBox(width: 16), // เว้นระยะห่างระหว่าง CircleAvatar และปุ่มชื่อสัตว์
                  // Animal Name Button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'ชื่อสัตว์', // ปุ่มชื่อสัตว์
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Animal Image Section
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // มุมมน
                child: Image.asset(
                  'assets/catfirstpage.jpg', // รูปแมว
                  fit: BoxFit.cover,
                  height: 500,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 20),

              // Information Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'ชื่อ: ตะหลิว\nเพศ: เมีย\nอายุ: 3 เดือน',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Search()),
                );
              },
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Addpicture())
                );
              },
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}