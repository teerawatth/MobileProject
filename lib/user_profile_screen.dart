import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pocketbase_service.dart';
import 'edit_profile_screen.dart'; // สำหรับแก้ไขโปรไฟล์
import 'user_bookings_screen.dart'; // สำหรับแสดงรายการการจอง

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final PocketBaseService pocketBaseService = PocketBaseService();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  // ฟังก์ชันดึงข้อมูลผู้ใช้ที่ล็อกอินอยู่
  void fetchUserProfile() async {
    try {
      final user = pocketBaseService.getCurrentUser();
      setState(() {
        userData = user;
      });
    } catch (e) {
      print("Failed to fetch user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900], // สีพื้นหลังของหน้า
      appBar: AppBar(
        title: const Text('User Profile'),
        automaticallyImplyLeading: true, // ให้แสดงปุ่มย้อนกลับอัตโนมัติ
      ),
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar หรือ Icon เสมอ
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, size: 40, color: Color.fromARGB(255, 107, 52, 52)),
              ),
              const SizedBox(height: 10), // เพิ่มช่องว่าง
              Text(
                userData?['name'] ?? 'John Doe',
                style: GoogleFonts.prompt(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              Text(
                userData?['username'] ?? 'username123',
                style: GoogleFonts.prompt(
                  fontSize: 14,
                  color: Colors.blue[300],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                ),
                child: Column(
                  children: [
                    _buildProfileItem(
                      icon: Icons.vpn_key,
                      label: 'ID:',
                      value: userData?['id'] ?? '12345',
                    ),
                    const Divider(),
                    _buildProfileItem(
                      icon: Icons.email,
                      label: 'อีเมล:',
                      value: userData?['email'] ?? 'user@example.com',
                    ),
                    const Divider(),
                    _buildProfileItem(
                      icon: Icons.person,
                      label: 'ชื่อ:',
                      value: userData?['name'] ?? 'John Doe',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, // ปรับให้ปุ่มเต็มความกว้าง
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProfileScreen(userData: userData!),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.amber,
                      textStyle: GoogleFonts.prompt(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('แก้ไขโปรไฟล์'),
                  ),
                  const SizedBox(height: 10), // เพิ่มช่องว่างระหว่างปุ่ม
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserBookingsScreen(userId: userData?['id']),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      textStyle: GoogleFonts.prompt(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('ดูการจอง'),
                  ),
                  const SizedBox(height: 10), // เพิ่มช่องว่างระหว่างปุ่ม
                  ElevatedButton(
                    onPressed: () {
                      pocketBaseService.logout();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.redAccent,
                      textStyle: GoogleFonts.prompt(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('ออกจากระบบ'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(
      {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[300]),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.prompt(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.prompt(
              fontSize: 14,
              color: Colors.blue[900],
            ),
          ),
        ],
      ),
    );
  }
}
