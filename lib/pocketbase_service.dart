import 'package:pocketbase/pocketbase.dart';

class PocketBaseService {
  // กำหนดให้ PocketBaseService เป็น Singleton
  static final PocketBaseService _instance = PocketBaseService._internal();
  factory PocketBaseService() {
    return _instance;
  }
  PocketBaseService._internal();

  final PocketBase pb = PocketBase(
      'https://586485bea01e-17076610223505492659.ngrok-free.app'); // URL ของ PocketBase

  // ฟังก์ชันสำหรับล็อกอินผู้ใช้
  Future<bool> login(String email, String password) async {
    try {
      await pb.collection('users').authWithPassword(email, password);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // ฟังก์ชันสำหรับสมัครสมาชิก
  Future<bool> register(String name, String email, String password) async {
    try {
      await pb.collection('users').create(body: {
        'username': name,
        'email': email,
        'password': password,
        'passwordConfirm': password,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // ฟังก์ชันดึงข้อมูลผู้ใช้ที่ล็อกอินอยู่
  Map<String, dynamic>? getCurrentUser() {
    print(pb.authStore.model?.toJson());

    return pb.authStore.model?.toJson();
  }

  // ฟังก์ชันสำหรับ logout
  void logout() {
    pb.authStore.clear();
  }

  // ฟังก์ชันสำหรับดึงข้อมูลรายการสนาม
  Future<List> getCourts() async {
    try {
      final result = await pb.collection('courts').getList(
            expand: '', // ไม่จำเป็นต้องขยายฟิลด์อื่น
          );
      print(result.items
          .map((e) => e.toJson())); // พิมพ์ข้อมูลทุกฟิลด์ออกมาเพื่อตรวจสอบ
      return result.items;
    } catch (e) {
      print("Error loading courts: $e");
      throw Exception('Failed to load courts');
    }
  }

  Future<void> bookCourt({
    required String courtId,
    required DateTime date,
    required String time,
    required String userId,
  }) async {
    try {
      final userId = pb.authStore.model?.id;
      if (userId == null) {
        throw Exception(
            'User not logged in'); // ตรวจสอบว่าผู้ใช้ล็อกอินอยู่หรือไม่
      }

      // เพิ่มการพิมพ์ค่าตัวแปร
      print("Court ID: $courtId");
      print("User ID: $userId");
      print("Date: $date");
      print("Time: $time");

      await pb.collection('bookings').create(body: {
        'courtId': courtId,
        'date': date.toIso8601String(),
        'time': time,
        'userId': userId,
      });

      print(userId);

      print(
          "จองสำเร็จ: สนาม $courtId วันที่ ${date.toLocal()} เวลา $time โดยผู้ใช้ $userId");
    } catch (e) {
      print("Error booking court: $e");
      throw Exception('Failed to book court');
    }
  }

  Future<List> getUserBookings(String userId) async {
    try {
      final result = await pb.collection('bookings').getList(
            filter: 'userId="$userId"', // กรองการจองที่เกี่ยวข้องกับ userId
          );

      List bookings = result.items;

      // ดึง courtId จากการจองทั้งหมดและไปดึงข้อมูลจาก collection 'courts'
      List<Map<String, dynamic>> bookingsWithCourtDetails = [];

      for (var booking in bookings) {
        String courtId = booking.data['courtId']; // ดึง courtId จาก booking

        // ดึงข้อมูลสนามจากคอลเล็กชัน 'courts' ตาม courtId
        final court = await pb.collection('courts').getOne(courtId);

        // สร้างรายการข้อมูลการจองรวมข้อมูลสนาม
        bookingsWithCourtDetails.add({
          'courtName':
              court.data['name'] ?? 'Unknown', // ชื่อสนามจากคอลเล็กชัน 'courts'
          'date': booking.data['date'],
          'time': booking.data['time'],
        });
      }

      return bookingsWithCourtDetails;
    } catch (e) {
      print("Error fetching user bookings: $e");
      throw Exception('Failed to load bookings');
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    required String name,
    required String email,
    required String username,
  }) async {
    try {
      // เตรียมข้อมูลสำหรับอัปเดต
      final Map<String, dynamic> body = {
        'name': name,
        'email': email,
        'username': username,
      };

      // อัปเดตข้อมูลผู้ใช้ใน PocketBase
      await pb.collection('users').update(userId, body: body);

      print('User profile updated successfully!');
    } catch (e) {
      print('Failed to update profile: $e');
      throw Exception('Failed to update profile');
    }
  }

  Future<void> deleteCourt(String courtId) async {
    try {
      await pb.collection('courts').delete(courtId);
    } catch (e) {
      throw Exception('Failed to delete court');
    }
  }

  Future<void> updateCourt({
    required String courtId,
    required String name,
    required String desc,
    required bool status,
    required List<String> time, // เพิ่มการรับค่า time
  }) async {
    try {
      await pb.collection('courts').update(
        courtId,
        body: {
          'name': name,
          'desc': desc,
          'status': status,
          'time': time, // เพิ่มการอัปเดต time
        },
      );
    } catch (e) {
      throw Exception('Failed to update court');
    }
  }

  Future<void> addCourt({
    required String name,
    required String desc,
    required bool status,
    required List<String> time,
  }) async {
    try {
      await pb.collection('courts').create(body: {
        'name': name,        // ชื่อสนาม
        'desc': desc,        // รายละเอียดสนาม
        'status': status,    // สถานะสนาม
        'time': time,        // ช่วงเวลาที่สามารถจองได้
      });
    } catch (e) {
      throw Exception('Failed to add court');
    }
  }
}
