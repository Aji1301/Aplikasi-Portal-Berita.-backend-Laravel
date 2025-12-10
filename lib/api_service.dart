import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // Buat cek kIsWeb

class ApiService {
  // Ganti URL sesuai device (Web pakai localhost, Emulator pakai 10.0.2.2)
  final String baseUrl = kIsWeb 
      ? "http://127.0.0.1:8000/api" 
      : "http://10.0.2.2:8000/api";

  // 1. LOGIN
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String token = data['token']; 
        
        // Simpan token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return true;
      }
      return false;
    } catch (e) {
      print("Error Login: $e");
      return false;
    }
  }

  // 2. REGISTER (BARU)
  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 201) { // 201 Created
        final data = json.decode(response.body);
        String token = data['token'];
        
        // Simpan token biar langsung login
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return true;
      }
      return false;
    } catch (e) {
      print("Error Register: $e");
      return false;
    }
  }

  // 3. AMBIL BERITA
  Future<List<dynamic>> getNews() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/news'));
      if (response.statusCode == 200) {
        // Laravel balikin: { "success": true, "data": [...] }
        return json.decode(response.body)['data']; 
      }
    } catch (e) {
      print("Error Get News: $e");
    }
    return [];
  }

  // 4. KIRIM KOMENTAR
  Future<bool> postComment(int newsId, String content) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return false; 

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/news/$newsId/comment'),
        headers: {
          'Authorization': 'Bearer $token', // WAJIB ADA
          'Accept': 'application/json',
        },
        body: {'comment': content},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error Post Comment: $e");
      return false;
    }
  }
  
// 6. AMBIL DETAIL BERITA (Untuk Refresh Komentar)
  Future<Map<String, dynamic>?> getNewsById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/news/$id'));
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      }
    } catch (e) {
      print("Error Get Detail: $e");
    }
    return null;
  }
  
  // 5. LOGOUT
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}

