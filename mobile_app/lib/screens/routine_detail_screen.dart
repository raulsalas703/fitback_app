import 'package:flutter/material.dart';

import '../models/routine.dart';
import '../services/workout_api.dart';
import '../widgets/fitback_background.dart';

class RoutineDetailScreen extends StatefulWidget {
  final Routine routine;

  const RoutineDetailScreen({super.key, required this.routine});

  @override
  State<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  bool _isSaving = false;

  Future<void> _completeRoutine() async {
    final durationController = TextEditingController(
      text: widget.routine.durationMinutes.toString(),
    );

    final int? duration = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF151515),
        title: const Text(
          'Entrenamiento completado',
          style: TextStyle(
            color: Color(0xFFE6C65C),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: durationController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Duración (minutos)',
            prefixIcon: Icon(Icons.timer),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(durationController.text);

              if (value == null || value <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ingresa una duración válida')),
                );
                return;
              }

              Navigator.pop(context, value);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (duration == null || !mounted) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await WorkoutApi.createWorkout(
        name: widget.routine.name,
        exercises: widget.routine.exercises
            .map(
              (exercise) => {
                'name': exercise.name,
                'sets': exercise.sets,
                'reps': exercise.reps,
                'weight': exercise.weight,
              },
            )
            .toList(),
        durationMinutes: duration,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Entrenamiento registrado! 💪')),
      );

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final routine = widget.routine;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de rutina')),
      body: FitBackBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.fitness_center,
                size: 56,
                color: Color(0xFFD4AF37),
              ),

              const SizedBox(height: 12),

              Text(
                routine.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE6C65C),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                routine.description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 16),

              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: [
                  Chip(
                    label: Text(routine.level),
                    backgroundColor: const Color(0xFF2A2008),
                    side: const BorderSide(color: Color(0x66D4AF37)),
                    labelStyle: const TextStyle(
                      color: Color(0xFFE6C65C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Chip(
                    label: Text('${routine.durationMinutes} min'),
                    backgroundColor: const Color(0xFF2A2008),
                    side: const BorderSide(color: Color(0x66D4AF37)),
                    labelStyle: const TextStyle(
                      color: Color(0xFFE6C65C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Ejercicios',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE6C65C),
                ),
              ),

              const SizedBox(height: 12),

              ...routine.exercises.map(
                (exercise) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: Color(0xFFD4AF37),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                exercise.weight > 0
                                    ? '${exercise.sets} series x ${exercise.reps} reps • ${exercise.weight} kg'
                                    : '${exercise.sets} series x ${exercise.reps} reps',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _completeRoutine,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : const Icon(Icons.check),
                  label: const Text('Marcar como completada'),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Al marcar la rutina como completada se guardará en tu historial con la fecha de hoy.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
