import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_api.dart';

class WorkoutApi {
  static const String baseUrl = 'http://localhost:3002';

  static Future<Map<String, dynamic>> createWorkout({
    required String name,
    required List<Map<String, dynamic>> exercises,
    required int durationMinutes,
    String? notes,
  }) async {
    final token = await AuthApi.getToken();

    if (token == null) {
      throw Exception('No hay una sesión iniciada');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/workouts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'exercises': exercises,
        'durationMinutes': durationMinutes,
        'notes': notes ?? '',
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    }

    throw Exception(data['message'] ?? 'Error al registrar entrenamiento');
  }

  static Future<List<dynamic>> getWorkouts() async {
    final token = await AuthApi.getToken();

    if (token == null) {
      throw Exception('No hay una sesión iniciada');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/workouts'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['workouts'] ?? [];
    }

    throw Exception(data['message'] ?? 'Error al obtener el historial');
  }

  static Future<Map<String, dynamic>> getWeeklyWorkouts() async {
    final token = await AuthApi.getToken();

    if (token == null) {
      throw Exception('No hay una sesión iniciada');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/workouts/weekly'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'total': data['total'] ?? 0, 'workouts': data['workouts'] ?? []};
    }

    throw Exception(data['message'] ?? 'Error al obtener el progreso semanal');
  }
}
