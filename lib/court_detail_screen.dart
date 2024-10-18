import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pocketbase_service.dart'; // นำเข้า PocketBaseService สำหรับบันทึกข้อมูล
import 'package:intl/intl.dart'; // นำเข้า intl สำหรับจัดการวันที่

class CourtDetailScreen extends StatefulWidget {
  final Map<String, dynamic> courtData; // ข้อมูลของสนามที่ส่งมา

  CourtDetailScreen({required this.courtData});

  @override
  _CourtDetailScreenState createState() => _CourtDetailScreenState();
}

class _CourtDetailScreenState extends State<CourtDetailScreen> {
  final PocketBaseService pocketBaseService = PocketBaseService();
  DateTime? selectedDate; // เก็บวันที่ที่เลือก
  String? selectedTime; // เก็บรอบจองที่เลือก

  @override
  Widget build(BuildContext context) {
    // ดึง courtId จากข้อมูลที่ส่งมา
    final String courtId =
        widget.courtData['id'] ?? ''; // ดึงค่า id จาก courtData
    final String courtName = widget.courtData['name'] ?? 'Unknown';
    final String courtDesc = widget.courtData['desc'] ?? 'No description';
    final dynamic timeField = widget.courtData['time'];
    final List<String> availableTimes =
        timeField is String ? [timeField] : List<String>.from(timeField ?? []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF002366), // สีโทนน้ำเงินเข้ม
        title: Text(
          'รายละเอียดสนาม',
          style: GoogleFonts.prompt(
            fontWeight: FontWeight.bold,
            color: Colors.yellow[700], // สีเหลือง
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              courtName,
              style: GoogleFonts.prompt(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              courtDesc,
              style: GoogleFonts.prompt(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // แสดงรอบจองทั้งหมด
            Center(
              child: Text(
                'รอบจองทั้งหมด',
                style: GoogleFonts.prompt(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: availableTimes.map((time) {
                return Chip(
                  label: Text(
                    time,
                    style: GoogleFonts.prompt(),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // ส่วนเลือกวันที่
            Center(
              child: Text(
                'เลือกวันที่',
                style: GoogleFonts.prompt(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ปุ่มเลือกวันที่
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 30)),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700], // สีเหลือง
                  foregroundColor: Colors.blue[900], // ตัวอักษรสีน้ำเงิน
                ),
                child: Text(
                  selectedDate == null
                      ? 'เลือกวันที่'
                      : 'วันที่: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}', // ใช้ DateFormat สำหรับแสดงวันที่
                  style: GoogleFonts.prompt(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ส่วนเลือกรอบจองที่ผู้ใช้ต้องการ
            Center(
              child: Text(
                'เลือกรอบจอง',
                style: GoogleFonts.prompt(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Dropdown สำหรับเลือกรอบจอง
            Center(
              child: DropdownButton<String>(
                hint: Text('เลือกรอบจอง', style: GoogleFonts.prompt()),
                value: selectedTime,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTime = newValue;
                  });
                },
                items:
                    availableTimes.map<DropdownMenuItem<String>>((String time) {
                  return DropdownMenuItem<String>(
                    value: time,
                    child: Text(time, style: GoogleFonts.prompt()),
                  );
                }).toList(),
              ),
            ),
            const Spacer(),

            // ปุ่มจองสนาม
            Center(
              child: ElevatedButton(
                onPressed: selectedDate != null && selectedTime != null
                    ? () async {
                        // พิมพ์ข้อมูลทั้งหมดของ courtData เพื่อตรวจสอบว่ามีอะไรบ้าง
                        print("Court Data: ${widget.courtData}");

                        // ตรวจสอบว่ามีฟิลด์ไหนที่เก็บค่า id ของสนาม
                        print("Court ID: $courtId");
                        print("Date: $selectedDate");
                        print("Time: $selectedTime");

                        // ดึง userId จาก PocketBaseService
                        final currentUser = pocketBaseService.getCurrentUser();
                        final userId = currentUser?['id'];

                        if (userId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('กรุณาล็อกอินก่อนทำการจอง')),
                          );
                          return;
                        }

                        // เรียกใช้งาน PocketBaseService เพื่อบันทึกการจอง
                        await pocketBaseService.bookCourt(
                          courtId: courtId,
                          date: selectedDate!,
                          time: selectedTime!,
                          userId: userId, // ส่ง userId ที่ได้จากการล็อกอิน
                        );

                        // แสดงผลเมื่อจองเสร็จสิ้น
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('การจองสำเร็จ!')),
                        );

                        // ย้อนกลับไปหน้าหลักหลังจองเสร็จสิ้น
                        Navigator.pop(context);
                      }
                    : null, // ปิดปุ่มถ้ายังไม่เลือกวันที่หรือรอบจอง
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue[900],
                  backgroundColor: selectedDate != null && selectedTime != null
                      ? Colors.yellow[700]
                      : Colors.grey, // เปลี่ยนสีปุ่มเมื่อพร้อมใช้งาน
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'จองสนามนี้',
                  style: GoogleFonts.prompt(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
