import 'package:flutter/material.dart';

import '../services/workout_api.dart';
import '../utils/formatters.dart';
import '../widgets/fitback_background.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<Map<String, dynamic>> _weeklyFuture;
  late Future<List<dynamic>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _weeklyFuture = WorkoutApi.getWeeklyWorkouts();
    _historyFuture = WorkoutApi.getWorkouts();
  }

  Future<void> _reload() async {
    setState(() {
      _weeklyFuture = WorkoutApi.getWeeklyWorkouts();
      _historyFuture = WorkoutApi.getWorkouts();
    });
  }

  Widget _summaryCard(int weeklyTotal, int totalCount) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: _summaryItem(
                icon: Icons.event_available,
                value: '$weeklyTotal',
                label: 'Esta semana',
              ),
            ),

            Container(width: 1, height: 48, color: const Color(0x55D4AF37)),

            Expanded(
              child: _summaryItem(
                icon: Icons.history,
                value: '$totalCount',
                label: 'En total',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFD4AF37)),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE6C65C),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }

  Widget _historyList(List<dynamic> workouts) {
    if (workouts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            const Icon(Icons.history, size: 56, color: Color(0x66D4AF37)),
            const SizedBox(height: 12),
            const Text(
              'Aún no has registrado entrenamientos',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 4),
            const Text(
              'Completa una rutina para verla aquí',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: workouts.length,
separatorBuilder: (_, _) =>
          const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final workout = workouts[index] as Map<String, dynamic>;

        final DateTime date =
            DateTime.tryParse(workout['workoutDate']?.toString() ?? '') ??
            DateTime.now();

        final int duration = (workout['durationMinutes'] as num?)?.toInt() ?? 0;

        final exercises =
            (workout['exercises'] as List<dynamic>? ?? const []).length;

        return Card(
          child: ListTile(
            leading: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2008),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x66D4AF37)),
              ),
              child: const Icon(Icons.fitness_center, color: Color(0xFFD4AF37)),
            ),
            title: Text(
              workout['name']?.toString() ?? 'Entrenamiento',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${formatDate(date)} • $duration min • $exercises ejercicios',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
            isThreeLine: false,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FitBackBackground(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _weeklyFuture,
          builder: (context, weeklySnapshot) {
            return FutureBuilder<List<dynamic>>(
              future: _historyFuture,
              builder: (context, historySnapshot) {
                if (weeklySnapshot.hasError || historySnapshot.hasError) {
                  final message =
                      (weeklySnapshot.hasError
                              ? weeklySnapshot.error
                              : historySnapshot.error)
                          .toString()
                          .replaceFirst('Exception: ', '');

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud_off,
                            size: 56,
                            color: Color(0x66D4AF37),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _reload,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (!weeklySnapshot.hasData || !historySnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
                  );
                }

                final weekly = weeklySnapshot.data!;
                final history = historySnapshot.data!;

                final weeklyTotal = (weekly['total'] as num?)?.toInt() ?? 0;

                return RefreshIndicator(
                  color: const Color(0xFFD4AF37),
                  backgroundColor: const Color(0xFF1E1E1E),
                  onRefresh: () async {
                    await Future.wait([_weeklyFuture, _historyFuture]);
                    _reload();
                  },
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _summaryCard(weeklyTotal, history.length),

                      const SizedBox(height: 24),

                      const Text(
                        'Todos tus entrenamientos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE6C65C),
                        ),
                      ),

                      const SizedBox(height: 12),

                      _historyList(history),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
