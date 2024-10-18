import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pocketbase_service.dart';
import 'package:intl/intl.dart';

class UserBookingsScreen extends StatefulWidget {
  final String userId;

  UserBookingsScreen({required this.userId});

  @override
  _UserBookingsScreenState createState() => _UserBookingsScreenState();
}

class _UserBookingsScreenState extends State<UserBookingsScreen> {
  final PocketBaseService pocketBaseService = PocketBaseService();
  List bookings = [];

  @override
  void initState() {
    super.initState();
    fetchUserBookings();
  }

  Future<void> fetchUserBookings() async {
    try {
      List fetchedBookings =
          await pocketBaseService.getUserBookings(widget.userId);
      setState(() {
        bookings = fetchedBookings;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load bookings')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การจองของฉัน',
            style: GoogleFonts.prompt(color: Colors.amber)),
        backgroundColor: const Color(0xFF002366), // น้ำเงินเข้ม
      ),
      body: bookings.isEmpty
          ? Center(
              child: Text('ยังไม่มีการจอง', style: GoogleFonts.prompt()),
            )
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      'สนาม: ${booking['courtName']}',
                      style: GoogleFonts.prompt(),
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // จัดให้ข้อความชิดซ้าย
                      children: [
                        Text(
                          'วันที่: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(booking['date']))}', // จัดรูปแบบวันที่
                          style: GoogleFonts.prompt(),
                        ),
                        Text(
                          'เวลา: ${booking['time']}',
                          style: GoogleFonts.prompt(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
