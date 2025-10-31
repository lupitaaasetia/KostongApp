import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/booking_model.dart';
import '../models/kost_model.dart';

class NotifikasiModel {
  final String? id;
  final String? title;
  final String? body;
  final String? createdAt;

  NotifikasiModel({this.id, this.title, this.body, this.createdAt});

  factory NotifikasiModel.fromJson(Map<String, dynamic> json) {
    return NotifikasiModel(
      id: json['_id'] ?? json['id'],
      title: json['title'],
      body: json['body'],
      createdAt: json['createdAt'] ?? json['created_at'],
    );
  }
}

class ApiService {
  // Auto-detect base URL berdasarkan platform
  static String get baseUrl {
    if (kIsWeb) {
      // Flutter Web
      return 'http://localhost:3000/api';
    } else if (Platform.isAndroid) {
      // Android Emulator
      return 'http://10.0.2.2:3000/api';
    } else if (Platform.isIOS) {
      // iOS Simulator
      return 'http://127.0.0.1:3000/api';
    } else {
      // Fallback
      return 'http://localhost:3000/api';
    }
  }

  // Timeout duration
  static const Duration _timeout = Duration(seconds: 15);

  // Common headers
  static Map<String, String> _headers({String? token}) {
    final headers = {'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Enhanced error handler
  static Map<String, dynamic> _handleError(dynamic error, {int? statusCode}) {
    print('❌ API Error: $error');

    if (error is http.Response) {
      try {
        final body = jsonDecode(error.body);
        return {
          'success': false,
          'message': body['message'] ?? body['error'] ?? 'Terjadi kesalahan',
          'statusCode': error.statusCode,
        };
      } catch (e) {
        return {
          'success': false,
          'message': 'Terjadi kesalahan pada server (${error.statusCode})',
          'statusCode': error.statusCode,
        };
      }
    }

    // Handle connection errors
    if (error.toString().contains('Failed host lookup') ||
        error.toString().contains('Network is unreachable') ||
        error.toString().contains('Connection refused')) {
      return {
        'success': false,
        'message':
            'Tidak dapat terhubung ke server. Pastikan backend sudah running di port 3000.',
        'statusCode': 0,
      };
    }

    if (error.toString().contains('TimeoutException')) {
      return {
        'success': false,
        'message': 'Koneksi timeout. Server tidak merespons.',
        'statusCode': 0,
      };
    }

    return {
      'success': false,
      'message': 'Terjadi kesalahan: ${error.toString()}',
      'statusCode': statusCode ?? 0,
    };
  }

  // Generic GET request
  static Future<http.Response> _get(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('🔵 GET: $url');

    final response = await http
        .get(
          url,
          headers: _headers(token: token),
        )
        .timeout(_timeout);

    print('✅ Response: ${response.statusCode}');
    return response;
  }

  // Generic POST request
  static Future<http.Response> _post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('🔵 POST: $url');
    print('📦 Body: ${jsonEncode(body)}');

    final response = await http
        .post(
          url,
          headers: _headers(token: token),
          body: jsonEncode(body),
        )
        .timeout(_timeout);

    print('✅ Response: ${response.statusCode}');
    print('📦 Response body: ${response.body}');
    return response;
  }

  // ==================== AUTH ====================

  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String? phone,
  ) async {
    try {
      final resp = await _post('/users/register', {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      });

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final data = jsonDecode(resp.body);
        return {'success': true, 'data': data};
      } else {
        return _handleError(resp);
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final resp = await _post('/users/login', {
        'email': email,
        'password': password,
      });

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final data = jsonDecode(resp.body);
        return {'success': true, 'data': data};
      } else {
        return _handleError(resp);
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  // ==================== USER ====================

  static Future<Map<String, dynamic>> getProfile(
      String userId, String token) async {
    try {
      final resp = await _get('/users/$userId', token: token);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return {'success': true, 'data': data};
      } else {
        return _handleError(resp);
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> updateProfile(
    String userId,
    String token,
    Map<String, dynamic> updates,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/users/$userId');
      final resp = await http
          .put(
            url,
            headers: _headers(token: token),
            body: jsonEncode(updates),
          )
          .timeout(_timeout);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return {'success': true, 'data': data};
      } else {
        return _handleError(resp);
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  // ==================== BOOKING ====================

  static Future<List<BookingModel>> getBookings(
      String userId, String token) async {
    try {
      final resp = await _get('/booking/user/$userId', token: token);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);

        // Handle both array and object with data property
        final List list =
            data is List ? data : (data['data'] ?? data['bookings'] ?? []);

        return list.map((e) => BookingModel.fromJson(e)).toList();
      } else {
        print('❌ Failed to get bookings: ${resp.body}');
        return [];
      }
    } catch (e) {
      print('❌ Error fetching bookings: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> createBooking(
    String token,
    Map<String, dynamic> bookingData,
  ) async {
    try {
      final resp = await _post('/booking', bookingData, token: token);

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final data = jsonDecode(resp.body);
        return {'success': true, 'data': data};
      } else {
        return _handleError(resp);
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> updateBooking(
    String bookingId,
    String token,
    Map<String, dynamic> updates,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/booking/$bookingId');
      final resp = await http
          .put(
            url,
            headers: _headers(token: token),
            body: jsonEncode(updates),
          )
          .timeout(_timeout);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return {'success': true, 'data': data};
      } else {
        return _handleError(resp);
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> cancelBooking(
    String bookingId,
    String token,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/booking/$bookingId');
      final resp = await http
          .delete(
            url,
            headers: _headers(token: token),
          )
          .timeout(_timeout);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return {'success': true, 'data': data};
      } else {
        return _handleError(resp);
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  // ==================== KOST ====================

  static Future<List<KostModel>> getAllKost(
      {Map<String, String>? filters}) async {
    try {
      String endpoint = '/kost';

      // Add query parameters if filters exist
      if (filters != null && filters.isNotEmpty) {
        final queryParams = filters.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
            .join('&');
        endpoint += '?$queryParams';
      }

      final resp = await _get(endpoint);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final List list =
            data is List ? data : (data['data'] ?? data['kosts'] ?? []);

        return list.map((e) => KostModel.fromJson(e)).toList();
      } else {
        print('❌ Failed to get kost: ${resp.body}');
        return [];
      }
    } catch (e) {
      print('❌ Error fetching kost: $e');
      return [];
    }
  }

  static Future<KostModel?> getKost(String kostId) async {
    try {
      final resp = await _get('/kost/$kostId');

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return KostModel.fromJson(data);
      } else {
        print('❌ Failed to get kost detail: ${resp.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error fetching kost detail: $e');
      return null;
    }
  }

  // ==================== NOTIFIKASI ====================

  static Future<List<dynamic>> getNotifikasi(
      String userId, String token) async {
    try {
      final resp = await _get('/notifikasi/user/$userId', token: token);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final List list =
            data is List ? data : (data['data'] ?? data['notifications'] ?? []);

        return list;
      } else {
        print('❌ Failed to get notifications: ${resp.body}');
        return [];
      }
    } catch (e) {
      print('❌ Error fetching notifikasi: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> markNotificationAsRead(
    String notifId,
    String token,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/notifikasi/$notifId/read');
      final resp = await http
          .put(
            url,
            headers: _headers(token: token),
          )
          .timeout(_timeout);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return {'success': true, 'data': data};
      } else {
        return _handleError(resp);
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  // ==================== FAVORIT ====================

  static Future<List<dynamic>> getFavorit(String userId, String token) async {
    try {
      final resp = await _get('/favorit/user/$userId', token: token);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final List list =
            data is List ? data : (data['data'] ?? data['favorites'] ?? []);

        return list;
      } else {
        print('❌ Failed to get favorit: ${resp.body}');
        return [];
      }
    } catch (e) {
      print('❌ Error fetching favorit: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> addFavorit(
    String userId,
    String kostId,
    String token,
  ) async {
    try {
      final resp = await _post(
          '/favorit',
          {
            'user_id': userId,
            'kost_id': kostId,
          },
          token: token);

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final data = jsonDecode(resp.body);
        return {'success': true, 'data': data};
      } else {
        return _handleError(resp);
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> removeFavorit(
    String favoritId,
    String token,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/favorit/$favoritId');
      final resp = await http
          .delete(
            url,
            headers: _headers(token: token),
          )
          .timeout(_timeout);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return {'success': true, 'data': data};
      } else {
        return _handleError(resp);
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  // ==================== HEALTH CHECK ====================

  static Future<bool> checkConnection() async {
    try {
      print('🔍 Checking connection to: $baseUrl');

      final url = Uri.parse(baseUrl.replaceAll('/api', '/health'));
      final resp = await http.get(url).timeout(Duration(seconds: 5));

      print('✅ Connection OK: ${resp.statusCode}');
      return resp.statusCode == 200;
    } catch (e) {
      print('❌ Connection failed: $e');
      return false;
    }
  }
}
