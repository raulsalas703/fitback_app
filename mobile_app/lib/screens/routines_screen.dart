import 'package:flutter/material.dart';

import '../models/routine.dart';
import '../widgets/fitback_background.dart';
import '../widgets/fitback_cover.dart';
import 'routine_detail_screen.dart';

class RoutinesScreen extends StatefulWidget {
  const RoutinesScreen({super.key});

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  static const List<String> _levels = [
    'Todos',
    'Principiante',
    'Intermedio',
    'Avanzado',
  ];

  String _selectedLevel = 'Todos';

  List<Routine> get _filteredRoutines {
    if (_selectedLevel == 'Todos') return defaultRoutines;

    return defaultRoutines
        .where((routine) => routine.level == _selectedLevel)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rutinas')),
      body: FitBackBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: FitBackCover(
                imagePath: 'assets/images/cover_workout.jpg',
                height: 130,
              ),
            ),

            SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: _levels.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final level = _levels[index];
                  final selected = level == _selectedLevel;

                  return ChoiceChip(
                    label: Text(level),
                    selected: selected,
                    selectedColor: const Color(0xFFD4AF37),
                    backgroundColor: const Color(0xFF1E1E1E),
                    labelStyle: TextStyle(
                      color: selected ? Colors.black : const Color(0xFFE6C65C),
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide(
                      color: selected
                          ? const Color(0xFFD4AF37)
                          : const Color(0x66D4AF37),
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedLevel = level;
                      });
                    },
                  );
                },
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredRoutines.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final routine = _filteredRoutines[index];

                  return Card(
                    child: ListTile(
                      leading: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2008),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0x66D4AF37)),
                        ),
                        child: const Icon(
                          Icons.fitness_center,
                          color: Color(0xFFD4AF37),
                        ),
                      ),
                      title: Text(
                        routine.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${routine.level} • ${routine.durationMinutes} min',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      isThreeLine: false,
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFFD4AF37),
                        size: 18,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RoutineDetailScreen(routine: routine),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
