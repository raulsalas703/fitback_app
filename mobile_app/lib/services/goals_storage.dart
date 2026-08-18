import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Goal {
  final String id;
  final String title;
  final String targetDate;
  bool completed;

  Goal({
    required this.id,
    required this.title,
    required this.targetDate,
    this.completed = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'targetDate': targetDate,
    'completed': completed,
  };

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
    id: json['id'],
    title: json['title'],
    targetDate: json['targetDate'],
    completed: json['completed'] ?? false,
  );
}

class GoalsStorage {
  static const String _key = 'fitback_goals';

  static Future<List<Goal>> getGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null) return [];

    final list = jsonDecode(raw) as List<dynamic>;

    return list
        .map((item) => Goal.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<void> _save(List<Goal> goals) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _key,
      jsonEncode(goals.map((goal) => goal.toJson()).toList()),
    );
  }

  static Future<void> addGoal({
    required String title,
    required String targetDate,
  }) async {
    final goals = await getGoals();

    goals.add(
      Goal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        targetDate: targetDate,
      ),
    );

    await _save(goals);
  }

  static Future<void> toggleGoal(String id) async {
    final goals = await getGoals();

    for (final goal in goals) {
      if (goal.id == id) {
        goal.completed = !goal.completed;
      }
    }

    await _save(goals);
  }

  static Future<void> deleteGoal(String id) async {
    final goals = await getGoals();

    goals.removeWhere((goal) => goal.id == id);

    await _save(goals);
  }
}
