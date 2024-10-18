import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pocketbase_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // สร้าง controller สำหรับเก็บข้อมูลอีเมลและรหัสผ่าน
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final PocketBaseService pocketBaseService = PocketBaseService();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF002366), Color(0xFF001d4e)], // โทนสีน้ำเงินเข้ม
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView( // ใช้ SingleChildScrollView เพื่อแก้ปัญหา overflow
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // โลโก้ หรือ ไอคอน
                  Icon(
                    Icons.sports_tennis,
                    size: 80,
                    color: Colors.yellow[700],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'UBU Badminton Arena',
                    style: GoogleFonts.prompt(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow[700],
                    ),
                  ),
                  const SizedBox(height: 50),

                  // กล่องฟอร์มลอย (Floating Form Card)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // ฟิลด์อีเมล
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'อีเมล',
                            labelStyle: GoogleFonts.prompt(
                              color: Colors.blue[900],
                            ),
                            prefixIcon: Icon(Icons.email, color: Colors.blue[900]),
                            border: const UnderlineInputBorder(),
                          ),
                          style: GoogleFonts.prompt(),
                        ),
                        const SizedBox(height: 20),

                        // ฟิลด์รหัสผ่าน
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'รหัสผ่าน',
                            labelStyle: GoogleFonts.prompt(
                              color: Colors.blue[900],
                            ),
                            prefixIcon: Icon(Icons.lock, color: Colors.blue[900]),
                            border: const UnderlineInputBorder(),
                          ),
                          style: GoogleFonts.prompt(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // ปุ่มเข้าสู่ระบบที่มี Gradient
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        // โค้ดสำหรับการเข้าสู่ระบบ
                        bool success = await pocketBaseService.login(
                          emailController.text,
                          passwordController.text,
                        );
                        if (success) {
                          // ดึงข้อมูลผู้ใช้ปัจจุบัน
                          final currentUser = pocketBaseService.getCurrentUser();

                          // ตรวจสอบว่าผู้ใช้เป็น Admin หรือไม่
                          if (currentUser != null && currentUser['Admin_Role'] == true) {
                            // ถ้าเป็น Admin
                            Navigator.pushReplacementNamed(context, '/admin_court_list');
                          } else {
                            // ถ้าไม่ใช่ Admin
                            Navigator.pushReplacementNamed(context, '/court_list');
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'เข้าสู่ระบบไม่สำเร็จ กรุณาตรวจสอบข้อมูล',
                                style: GoogleFonts.prompt(), // ใช้ Prompt font
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700], // ปรับเป็นสีเหลือง
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        'เข้าสู่ระบบ',
                        style: GoogleFonts.prompt(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900], // ตัวอักษรเป็นสีน้ำเงินเข้ม
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ลิงก์สมัครสมาชิก
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ยังไม่มีบัญชี? ',
                        style: GoogleFonts.prompt(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          'สมัครสมาชิก',
                          style: GoogleFonts.prompt(
                            color: Colors.yellow[700],
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}
