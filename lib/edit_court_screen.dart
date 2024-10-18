import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pocketbase_service.dart'; // นำเข้า PocketBaseService

class EditCourtScreen extends StatefulWidget {
  final Map<String, dynamic> courtData;

  EditCourtScreen({required this.courtData});

  @override
  _EditCourtScreenState createState() => _EditCourtScreenState();
}

class _EditCourtScreenState extends State<EditCourtScreen> {
  final PocketBaseService pocketBaseService = PocketBaseService();
  late TextEditingController nameController;
  late TextEditingController descController;
  bool isAvailable = false;

  // รายการช่วงเวลาที่เลือกสำหรับสนาม
  late List<String> selectedTimeSlots;

  // รายการช่วงเวลาทั้งหมด
  final List<String> allTimeSlots = ['17:00', '18:00', '19:00', '20:00'];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.courtData['name']);
    descController = TextEditingController(text: widget.courtData['desc']);
    isAvailable = widget.courtData['status'] ?? false;

    // ถ้า 'time' เป็น String แปลงเป็นลิสต์ ถ้าไม่เป็นลิสต์อยู่แล้ว
    final dynamic timeField = widget.courtData['time'];
    selectedTimeSlots =
        timeField is String ? [timeField] : List<String>.from(timeField ?? []);
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  // ฟังก์ชันบันทึกการแก้ไขสนาม
  Future<void> saveCourt() async {
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
      await pocketBaseService.updateCourt(
        courtId: widget.courtData['id'],
        name: nameController.text,
        desc: descController.text,
        status: isAvailable,
        time: selectedTimeSlots,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกการแก้ไขสำเร็จ!')),
      );

      Navigator.pushNamed(context, '/admin_court_list'); // นำทางไปยังหน้า Login

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('บันทึกการแก้ไขไม่สำเร็จ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขสนาม', style: GoogleFonts.prompt(color: Colors.amber)),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ชื่อสนาม', style: GoogleFonts.prompt(fontWeight: FontWeight.bold, color: Colors.blue[900])),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'กรอกชื่อสนาม',
                hintStyle: GoogleFonts.prompt(color: Colors.grey),
                labelStyle: GoogleFonts.prompt(),
              ),
            ),
            const SizedBox(height: 16),

            Text('รายละเอียดสนาม', style: GoogleFonts.prompt(fontWeight: FontWeight.bold, color: Colors.blue[900])),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'กรอกรายละเอียดสนาม',
                hintStyle: GoogleFonts.prompt(color: Colors.grey),
                labelStyle: GoogleFonts.prompt(),
              ),
            ),
            const SizedBox(height: 16),

            // Switch สำหรับสถานะสนาม
            SwitchListTile(
              title: Text('สถานะพร้อมให้บริการ', style: GoogleFonts.prompt(fontWeight: FontWeight.bold, color: Colors.blue[900])),
              value: isAvailable,
              onChanged: (value) {
                setState(() {
                  isAvailable = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // การเลือกช่วงเวลาจองสนาม
            Text('เลือกช่วงเวลาจอง:', style: GoogleFonts.prompt(fontWeight: FontWeight.bold, color: Colors.blue[900])),
            const SizedBox(height: 8),
            Column(
              children: allTimeSlots.map((time) {
                return CheckboxListTile(
                  title: Text(time, style: GoogleFonts.prompt(color: Colors.blue[900])),
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
            const SizedBox(height: 24),

            // ปุ่มบันทึก
            Center(
              child: ElevatedButton(
                onPressed: saveCourt,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'บันทึก',
                  style: GoogleFonts.prompt(fontWeight: FontWeight.bold, color: Colors.blue[900]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
