import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  // Por ahora usaremos localhost para probar en Windows/Chrome.
  static const String baseUrl = 'http://localhost:3001';

  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  // =========================
  // REGISTRO
  // =========================
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    }

    throw Exception(
      data['message'] ?? 'Error al registrar usuario',
    );
  }

  // =========================
  // LOGIN
  // =========================
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final token = data['token'];

      if (token != null) {
        await _storage.write(
          key: 'auth_token',
          value: token,
        );
      }

      return data;
    }

    throw Exception(
      data['message'] ?? 'Error al iniciar sesión',
    );
  }

  // =========================
  // PERFIL
  // =========================
  static Future<Map<String, dynamic>> getProfile() async {
    final token = await _storage.read(
      key: 'auth_token',
    );

    if (token == null) {
      throw Exception('No hay una sesión iniciada');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/auth/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['message'] ?? 'Error al obtener el perfil',
    );
  }

  // =========================
  // OBTENER TOKEN
  // =========================
  static Future<String?> getToken() async {
    return await _storage.read(
      key: 'auth_token',
    );
  }

  // =========================
  // CERRAR SESIÓN
  // =========================
  static Future<void> logout() async {
    await _storage.delete(
      key: 'auth_token',
    );
  }
}