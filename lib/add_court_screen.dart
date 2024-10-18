import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pocketbase_service.dart';

class AddCourtScreen extends StatefulWidget {
  @override
  _AddCourtScreenState createState() => _AddCourtScreenState();
}

class _AddCourtScreenState extends State<AddCourtScreen> {
  final PocketBaseService pocketBaseService = PocketBaseService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  bool status = false; // สำหรับเก็บสถานะสนาม

  // รายการช่วงเวลาที่ให้ผู้ใช้เลือก
  final List<String> allTimeSlots = ['17:00', '18:00', '19:00', '20:00'];
  List<String> selectedTimeSlots = []; // ช่วงเวลาที่เลือกโดยผู้ใช้

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มสนามใหม่', style: GoogleFonts.prompt(color: Colors.amber)),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ฟิลด์กรอกชื่อสนาม
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'ชื่อสนาม',
                border: OutlineInputBorder(),
                labelStyle: GoogleFonts.prompt(),
              ),
            ),
            const SizedBox(height: 16),

            // ฟิลด์กรอกรายละเอียดสนาม
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'รายละเอียดสนาม',
                border: OutlineInputBorder(),
                labelStyle: GoogleFonts.prompt(),
              ),
            ),
            const SizedBox(height: 16),

            // Switch สำหรับสถานะสนาม
            SwitchListTile(
              title: Text('สถานะสนาม', style: GoogleFonts.prompt()),
              value: status,
              onChanged: (bool value) {
                setState(() {
                  status = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // การเลือกช่วงเวลาจองสนาม
            Text('เลือกช่วงเวลาจอง:', style: GoogleFonts.prompt(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Column(
              children: allTimeSlots.map((time) {
                return CheckboxListTile(
                  title: Text(time, style: GoogleFonts.prompt()),
                  value: selectedTimeSlots.contains(time),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedTimeSlots.add(time);
                      } else {
                        selectedTimeSlots.remove(time);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // ปุ่มเพิ่มสนาม
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isEmpty || descController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
                    );
                    return;
                  }

                  if (selectedTimeSlots.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('กรุณาเลือกช่วงเวลาจองอย่างน้อยหนึ่งช่วง')),
                    );
                    return;
                  }

                  try {
                    await pocketBaseService.addCourt(
                      name: nameController.text,
                      desc: descController.text,
                      status: status,
                      time: selectedTimeSlots, // ส่งช่วงเวลาที่เลือก
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('เพิ่มสนามสำเร็จ!')),
                    );
                    Navigator.pop(context, true); // ส่งค่า true กลับเพื่อรีเฟรชข้อมูล
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('เพิ่มสนามไม่สำเร็จ: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'เพิ่มสนาม',
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
