import 'package:flutter/material.dart';
import 'homefirst.dart';
import 'profile.dart';
import 'addpicture.dart';

void main() {
  runApp(const Search());
}

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SearchPage(),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3D9C5), // สีพื้นหลังเบจ
      body: SafeArea(
        child: Column(
          children: [
            // Logo and Search Bar Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  // Logo
                  Image.asset(
                    'assets/image.png', // ใส่โลโก้ตามที่คุณอัปโหลด
                    height: 80,
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'ค้นหา',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Grid Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  itemCount: 10,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Bottom Navigation Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.home),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Home()),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),

                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Addpicture()),
                    );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>  ProfileScreen(userId: 1)),
                    );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
