import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pocketbase_service.dart';
import 'edit_court_screen.dart'; // นำเข้า EditCourtScreen สำหรับแก้ไขสนาม
import 'add_court_screen.dart'; // นำเข้า AddCourtScreen สำหรับเพิ่มสนามใหม่

class AdminCourtListScreen extends StatefulWidget {
  @override
  _AdminCourtListScreenState createState() => _AdminCourtListScreenState();
}

class _AdminCourtListScreenState extends State<AdminCourtListScreen> {
  final PocketBaseService pocketBaseService = PocketBaseService();
  List courts = [];

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

  // ฟังก์ชันรีเฟรชข้อมูลทั้งหมด
  Future<void> refreshData() async {
    await fetchCourts();
  }

  // ฟังก์ชันลบสนาม
  Future<void> deleteCourt(String courtId) async {
    try {
      await pocketBaseService.deleteCourt(courtId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ลบสนามสำเร็จ!')),
      );
      refreshData(); // รีเฟรชข้อมูลหลังลบสำเร็จ
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ลบสนามไม่สำเร็จ!')),
      );
    }
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
            'Badminton Courts (Admin)',
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
                  Navigator.pushNamed(context, '/profile'); // นำไปยังหน้าโปรไฟล์
                },
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // เมื่อกดปุ่มนี้จะไปยังหน้าสำหรับเพิ่มสนามใหม่
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCourtScreen()), // หน้าสำหรับเพิ่มสนามใหม่
            ).then((value) {
              if (value == true) {
                refreshData(); // รีเฟรชข้อมูลหลังจากเพิ่มสนามใหม่
              }
            });
          },
          backgroundColor: Colors.yellow[700],
          child: const Icon(Icons.add, color: Colors.white),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(courtName, style: GoogleFonts.prompt(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text(courtDesc, style: GoogleFonts.prompt()),
                      const SizedBox(height: 5),
                      Text(
                        'รอบจอง : ${availableTimes.join(', ')}',
                        style: GoogleFonts.prompt(color: Colors.blueGrey),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              // ไปยังหน้าสำหรับแก้ไขสนาม
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditCourtScreen(
                                    courtData: {
                                      'id': court.id, // ใช้ 'court.id' แทน 'court.data['id']'
                                      'name': court.data['name'],
                                      'desc': court.data['desc'],
                                      'status': court.data['status'],
                                      'time': court.data['time'],
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, color: Colors.white),
                            label: Text('แก้ไข', style: GoogleFonts.prompt(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              // ยืนยันก่อนลบสนาม
                              showDialog(
                        
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('ยืนยันการลบ',style: GoogleFonts.prompt(),),
                                    content: Text('คุณแน่ใจว่าต้องการลบสนามนี้หรือไม่?',style: GoogleFonts.prompt()),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text('ยกเลิก',style: GoogleFonts.prompt()),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // ปิด Dialog
                                          deleteCourt(court.id); // เรียกฟังก์ชันลบสนาม
                                        },
                                        child: Text('ลบ',style: GoogleFonts.prompt()),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete, color: Colors.white),
                            label: Text('ลบ', style: GoogleFonts.prompt(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
