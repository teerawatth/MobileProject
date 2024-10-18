import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pocketbase_service.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // สร้าง Controller สำหรับแต่ละฟิลด์
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();
    final PocketBaseService pocketBaseService = PocketBaseService();

    // ฟังก์ชันสำหรับการสมัครสมาชิก
    Future<void> register() async {
      String name = nameController.text;
      String email = emailController.text;
      String password = passwordController.text;
      String confirmPassword = confirmPasswordController.text;

      // ตรวจสอบว่ารหัสผ่านตรงกันหรือไม่
      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'รหัสผ่านไม่ตรงกัน',
              style: GoogleFonts.prompt(),
            ),
          ),
        );
        return;
      }

      // เรียกใช้ PocketBaseService สำหรับการสมัครสมาชิก
      bool success = await pocketBaseService.register(name, email, password);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'สมัครสมาชิกสำเร็จ',
              style: GoogleFonts.prompt(),
            ),
          ),
        );
        Navigator.pushNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'สมัครสมาชิกไม่สำเร็จ กรุณาลองใหม่',
              style: GoogleFonts.prompt(),
            ),
          ),
        );
      }
    }

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
            child: SingleChildScrollView(
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
                    'สมัครสมาชิก',
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
                        // ฟิลด์ชื่อ
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'ชื่อ',
                            labelStyle: GoogleFonts.prompt(
                              color: Colors.blue[900],
                            ),
                            prefixIcon: Icon(Icons.person, color: Colors.blue[900]),
                            border: const UnderlineInputBorder(),
                          ),
                          style: GoogleFonts.prompt(),
                        ),
                        const SizedBox(height: 20),

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
                        const SizedBox(height: 20),

                        // ฟิลด์ยืนยันรหัสผ่าน
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'ยืนยันรหัสผ่าน',
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

                  // ปุ่มสมัครสมาชิกที่มีสีเหลือง
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // เรียกใช้ฟังก์ชันสมัครสมาชิก
                        register();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700], // ปรับเป็นสีเหลือง
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        'สมัครสมาชิก',
                        style: GoogleFonts.prompt(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900], // ตัวอักษรเป็นสีน้ำเงินเข้ม
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ลิงก์เข้าสู่ระบบ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'มีบัญชีอยู่แล้ว? ',
                        style: GoogleFonts.prompt(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          'เข้าสู่ระบบ',
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
