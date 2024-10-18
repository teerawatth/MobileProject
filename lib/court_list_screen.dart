import 'package:flutter/material.dart';
import 'pocketbase_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'court_detail_screen.dart'; // นำเข้า CourtDetailScreen

class CourtListScreen extends StatefulWidget {
  @override
  _CourtListScreenState createState() => _CourtListScreenState();
}

class _CourtListScreenState extends State<CourtListScreen> {
  final PocketBaseService pocketBaseService = PocketBaseService();
  List courts = [];
  String? avatarUrl;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    refreshData(); // เรียกฟังก์ชันรีเฟรชข้อมูลเมื่อเริ่มต้น
  }

  // ฟังก์ชันดึงข้อมูลสนาม
  Future<void> fetchCourts() async {
    try {
      List fetchedCourts = await pocketBaseService.getCourts();
      setState(() {
        courts = fetchedCourts;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load courts')),
      );
    }
  }

  // ฟังก์ชันดึงข้อมูลโปรไฟล์ผู้ใช้
  Future<void> fetchUserProfile() async {
    try {
      final user = await pocketBaseService.getCurrentUser();
      setState(() {
        userData = user;
      });
    } catch (e) {
      print("Failed to fetch user profile: $e");
    }
  }

  // ฟังก์ชันรีเฟรชข้อมูลทั้งหมด
  Future<void> refreshData() async {
    await fetchUserProfile();
    await fetchCourts();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // ป้องกันการกดปุ่มย้อนกลับ
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // ปิดการแสดงปุ่มย้อนกลับ
          backgroundColor: const Color(0xFF002366), // น้ำเงินเข้ม
          title: Text(
            'Badminton Courts',
            style: GoogleFonts.prompt(
              fontWeight: FontWeight.bold,
              color: Colors.yellow[700], // สีเหลือง
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, color: Color.fromARGB(255, 78, 45, 45)), // แสดงไอคอนเสมอ
                ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: refreshData, // เรียกใช้ฟังก์ชัน refreshData เมื่อปัดหน้าจอลง
          color: Colors.yellow[700], // สีเหลืองสำหรับ Refresh Indicator
          child: ListView.builder(
            itemCount: courts.length,
            itemBuilder: (context, index) {
              final court = courts[index];

              final String courtName = court.data['name'] ?? 'Unknown';
              final String courtDesc = court.data['desc'] ?? 'No description';
              final bool isAvailable = court.data['status'] ?? false; // true หรือ false

              // ตรวจสอบว่าฟิลด์ 'time' เป็น List หรือ String
              final dynamic timeField = court.data['time'];
              final List<String> availableTimes = timeField is String
                  ? [timeField] // ถ้าเป็นสตริง ให้นำมาสร้างเป็นลิสต์ที่มีรายการเดียว
                  : List<String>.from(timeField ?? []);

              return Card(
                color: isAvailable
                    ? Colors.white
                    : Colors.grey[300], // พื้นหลังสีเทาถ้าสนามไม่พร้อม
                child: ListTile(
                  title: Text(courtName,
                      style: GoogleFonts.prompt(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(courtDesc, style: GoogleFonts.prompt()),
                      const SizedBox(height: 5),
                      Text(
                        'รอบจอง : ${availableTimes.join(', ')}',
                        style: GoogleFonts.prompt(color: Colors.blueGrey),
                      ),
                    ],
                  ),
                  trailing: isAvailable
                      ? const Icon(Icons.check_circle, color: Colors.green) // ถ้าว่างแสดงสีเขียว
                      : const Icon(Icons.cancel, color: Colors.red), // ไม่ว่างแสดงสีแดง
                  onTap: isAvailable
                      ? () {
                          // เมื่อกดจะนำไปยัง CourtDetailScreen และส่งข้อมูลสนามไปด้วย
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourtDetailScreen(
                                courtData: {
                                  'id': court.id, // ใช้ 'court.id' แทน 'court.data['id']' เพื่อความถูกต้อง
                                  'name': court.data['name'],
                                  'desc': court.data['desc'],
                                  'status': court.data['status'],
                                  'time': court.data['time'],
                                },
                              ),
                            ),
                          );
                        }
                      : null, // ถ้าไม่พร้อม ไม่ทำอะไร
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
