import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/madrasah_model.dart';
import '../models/rekap_model.dart';
import '../models/supervisor_model.dart';
import 'storage_service.dart';

class ApiService {
  static Future<String> _getBaseUrl() async {
    return await StorageService.getApiUrl();
  }

  // 1. LOGIN
  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final baseUrl = await _getBaseUrl();
      final url = Uri.parse('$baseUrl?action=login');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'user': UserModel.fromJson(data),
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Username atau password salah',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal terhubung ke server: $e',
      };
    }
  }

  // 2. GET MADRASAH
  static Future<List<MadrasahModel>> getMadrasah() async {
    try {
      final baseUrl = await _getBaseUrl();
      final url = Uri.parse('$baseUrl?action=get_madrasah');
      
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded.map((item) => MadrasahModel.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // 3. GET SUPERVISORS
  static Future<List<SupervisorModel>> getSupervisors() async {
    try {
      final baseUrl = await _getBaseUrl();
      final url = Uri.parse('$baseUrl?action=get_supervisors');
      
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded.map((item) => SupervisorModel.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // 4. ADD SUPERVISOR
  static Future<Map<String, dynamic>> addSupervisor({
    required String username,
    required String password,
    required String namaSupervisor,
    required String wilayahTugas,
  }) async {
    try {
      final baseUrl = await _getBaseUrl();
      final url = Uri.parse('$baseUrl?action=add_supervisor');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'nama_supervisor': namaSupervisor,
          'wilayah_tugas': wilayahTugas,
        }),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      return {'success': false, 'message': 'Gagal menambahkan supervisor: $e'};
    }
  }

  // 5. SUBMIT SUPERVISI
  static Future<Map<String, dynamic>> submitSupervisi({
    required String madrasahNama,
    required String supervisorNama,
    required int supervisorId,
    required String periode,
    required Map<String, String> nilai,
    required Map<String, String> catatan,
  }) async {
    try {
      final baseUrl = await _getBaseUrl();
      final url = Uri.parse('$baseUrl?action=submit_supervisi');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'madrasah': madrasahNama,
          'supervisor_nama': supervisorNama,
          'supervisor_id': supervisorId,
          'periode': periode,
          'nilai': nilai,
          'catatan': catatan,
        }),
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      return {'success': false, 'message': 'Gagal menyimpan supervisi: $e'};
    }
  }

  // 6. GET REKAP SUPERVISI
  static Future<List<RekapModel>> getRekap() async {
    try {
      final baseUrl = await _getBaseUrl();
      final url = Uri.parse('$baseUrl?action=get_rekap');

      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded['data'] is List) {
          return (decoded['data'] as List)
              .map((item) => RekapModel.fromJson(item))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // 7. DELETE DATA (Admin only)
  static Future<Map<String, dynamic>> deleteData(String jenis) async {
    try {
      final baseUrl = await _getBaseUrl();
      final url = Uri.parse('$baseUrl?action=delete_data');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'jenis': jenis}),
      ).timeout(const Duration(seconds: 10));

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Gagal menghapus data: $e'};
    }
  }
}

