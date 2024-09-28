// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/TaskModel.dart';

class Api {
  final String baseUrl =
      'http://localhost:5000/api'; // Thay thế bằng URL của API của bạn

  Api();

  // Hàm đăng ký người dùng
  Future<Map<String, dynamic>?> register(
      String email, String password, String name) async {
    final url = Uri.parse('$baseUrl/auth/register');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body); // Trả về message nếu đăng ký thành công
    } else {
      return jsonDecode(response.body); // Trả về lỗi nếu có
    }
  }

  // Hàm đăng nhập người dùng
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Lưu token vào SharedPreferences để sử dụng sau này
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);

      return data; // Trả về thông tin người dùng và token
    } else {
      return jsonDecode(response.body); // Trả về lỗi nếu có
    }
  }

  // Lấy token từ SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Đăng xuất và xóa token khỏi SharedPreferences
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Lấy tất cả các tasks của người dùng
  Future<List<dynamic>?> getTasks() async {
    String? token = await getToken();
    final url = Uri.parse('$baseUrl/tasks');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Trả về danh sách tasks
    } else {
      return null; // Xử lý lỗi nếu cần
    }
  }

  // Thêm task mới
  Future<taskModel?> addTask({
    required String title,
    required DateTime date, // Sử dụng kiểu DateTime
    required TimeTask time, // Sử dụng kiểu Time
    required String location,
    required List<String> participants,
    required String notes,
    required String status,
    String? reviewedBy,
    List<DateTime>? reminders, // Sử dụng List<DateTime>
  }) async {
    String? token = await getToken(); // Lấy token nếu cần
    final url = Uri.parse('$baseUrl/tasks/create');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Thêm token vào header
        'Content-Type': 'application/json', // Định dạng dữ liệu là JSON
      },
      body: jsonEncode({
        'title': title,
        'date': date.toIso8601String(), // Chuyển đổi DateTime thành ISO 8601 string
        'time': time.toJson(), // Chuyển đổi Time thành JSON
        'location': location,
        'participants': participants,
        'notes': notes,
        'status': status,
        'reviewedBy': reviewedBy,
        'reminders': reminders?.map((reminder) => reminder.toIso8601String()).toList(), // Chuyển đổi List<DateTime> thành List<String>
      }),
    );

    if (response.statusCode == 201) {
      return taskModel.fromJson(jsonDecode(response.body)); // Trả về TaskModel từ JSON
    } else {
      // Nếu có lỗi, trả về thông tin lỗi
      return taskModel.fromJson(jsonDecode(response.body));
    }
  }
  // Cập nhật task
  Future<taskModel?> updateTask({
    required String id, // ID của task cần cập nhật
    String? title,
    DateTime? date,
    TimeTask? time,
    String? location,
    List<String>? participants,
    String? notes,
    String? status,
    String? reviewedBy,
    List<DateTime>? reminders,
  }) async {
    String? token = await getToken(); // Lấy token nếu cần thiết
    final url = Uri.parse('$baseUrl/tasks/edit/$id'); // Endpoint để cập nhật task

    // Chuẩn bị dữ liệu body
    final body = {
      'title': title,
      'date': date?.toIso8601String(),
      'time': time?.toJson(),
      'location': location,
      'participants': participants,
      'notes': notes,
      'status': status,
      'reviewedBy': reviewedBy,
      'reminders': reminders?.map((reminder) => reminder.toIso8601String()).toList(),
    };

    // Gửi request cập nhật task
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Thêm token vào header nếu cần
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // Nếu thành công, trả về task đã được cập nhật
      return taskModel.fromJson(jsonDecode(response.body));
    } else {
      // Nếu thất bại, trả về lỗi
      print('Failed to update task: ${response.body}');
      return null;
    }
  }

  // Xóa task theo ID
  Future<Map<String, dynamic>?> deleteTask(String taskId) async {
    String? token = await getToken();
    final url = Uri.parse('$baseUrl/tasks/delete/$taskId');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Trả về thông báo thành công
    } else {
      return jsonDecode(response.body); // Trả về lỗi nếu có
    }
  }

  // Lấy chi tiết task theo ID
  Future<Map<String, dynamic>?> getTaskDetails(String taskId) async {
    String? token = await getToken();
    final url = Uri.parse('$baseUrl/tasks/$taskId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Trả về chi tiết task
    } else {
      return jsonDecode(response.body); // Trả về lỗi nếu có
    }
  }

  // Lấy thống kê task của người dùng
  Future<Map<String, dynamic>?> getTaskStats() async {
    String? token = await getToken();
    final url = Uri.parse('$baseUrl/task-stats');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Trích xuất thông tin thống kê từ phản hồi
      Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Cấu trúc phản hồi dựa trên các trạng thái của task
      int tasksCreated = responseBody['tasksCreated'] ?? 0;
      int tasksInProgress = responseBody['tasksInProgress'] ?? 0;
      int tasksCompleted = responseBody['tasksCompleted'] ?? 0;
      int tasksClosed = responseBody['tasksClosed'] ?? 0;

      return {
        'tasksCreated': tasksCreated,
        'tasksInProgress': tasksInProgress,
        'tasksCompleted': tasksCompleted,
        'tasksClosed': tasksClosed,
      };
    } else {
      // Trả về lỗi nếu có
      return jsonDecode(response.body);
    }
  }
}
