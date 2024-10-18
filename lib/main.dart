import 'package:badminton_courts/admin_court_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'court_list_screen.dart';
import 'user_profile_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'จองสนามแบดมินตัน',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // หน้าเริ่มต้นเป็น Welcome Screen
      routes: {
        '/': (context) => WelcomeScreen(), // Welcome Screen ที่ถูกสร้างไว้ใน main.dart
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/court_list': (context) => CourtListScreen(),
        '/profile': (context) => UserProfileScreen(),
        '/admin_court_list': (context) => AdminCourtListScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // โลโก้ และชื่อแอป
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sports_tennis, // ใช้ไอคอนรูปแบดมินตันแทน
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
                ],
              ),
              const SizedBox(height: 50),

              // ข้อความต้อนรับ
              Text(
                'ยินดีต้อนรับ!',
                style: GoogleFonts.prompt(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              // ปุ่มเข้าสู่ระบบ (Sign In)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login'); // นำทางไปยังหน้า Login
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue[900],
                      backgroundColor: Colors.yellow[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: GoogleFonts.prompt(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('เข้าสู่ระบบ'),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ปุ่มสมัครสมาชิก (Sign Up)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register'); // นำทางไปยังหน้า Register
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      textStyle: GoogleFonts.prompt(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('สมัครสมาชิก'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
