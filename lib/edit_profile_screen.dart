import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pocketbase_service.dart'; // นำเข้า PocketBaseService

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  EditProfileScreen({required this.userData});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final PocketBaseService pocketBaseService = PocketBaseService();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userData['name']);
    emailController = TextEditingController(text: widget.userData['email']);
    usernameController =
        TextEditingController(text: widget.userData['username']);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  // ฟังก์ชันบันทึกโปรไฟล์
  Future<void> saveProfile() async {
    try {
      // อัปเดตข้อมูลผู้ใช้โดยไม่ส่งไฟล์รูปภาพ
      await pocketBaseService.updateUserProfile(
        userId: widget.userData['id'],
        name: nameController.text,
        email: emailController.text,
        username: usernameController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกโปรไฟล์สำเร็จ!')),
      );

      // เมื่อบันทึกสำเร็จให้ส่งค่า true กลับไปและปิดหน้าจอ
        Navigator.pushNamed(context, '/profile'); // นำทางไปยังหน้า Login
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('บันทึกโปรไฟล์ไม่สำเร็จ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขโปรไฟล์', style: GoogleFonts.prompt(color: Colors.amber)),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // แสดง Avatar ที่เลือก หรือใช้ Icon เป็นค่าเริ่มต้นถ้าไม่มี Avatar
            const Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person, size: 40, color: Colors.white), // แสดงไอคอนเสมอ
              ),
            ),
            const SizedBox(height: 24), // เพิ่มระยะห่างที่เหมาะสม

            // ฟิลด์ชื่อ
            Text(
              'ชื่อ',
              style: GoogleFonts.prompt(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'กรอกชื่อของคุณ',
                labelStyle: GoogleFonts.prompt(),
              ),
            ),
            const SizedBox(height: 24),

            // ฟิลด์อีเมล
            Text(
              'อีเมล',
              style: GoogleFonts.prompt(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'กรอกอีเมลของคุณ',
                labelStyle: GoogleFonts.prompt(),
              ),
            ),
            const SizedBox(height: 24),

            // ฟิลด์ Username
            Text(
              'Username',
              style: GoogleFonts.prompt(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'กรอก Username ของคุณ',
                labelStyle: GoogleFonts.prompt(),
              ),
            ),
            const SizedBox(height: 32), // ระยะห่างก่อนถึงปุ่มบันทึก

            // ปุ่มบันทึกโปรไฟล์
            Center(
              child: ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'บันทึก',
                  style: GoogleFonts.prompt(
                    fontWeight: FontWeight.bold, 
                    color: Colors.blue[900],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
