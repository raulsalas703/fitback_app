class RoutineExercise {
  final String name;
  final int sets;
  final int reps;
  final double weight;

  const RoutineExercise({
    required this.name,
    required this.sets,
    required this.reps,
    this.weight = 0,
  });
}

class Routine {
  final String name;
  final String level;
  final String description;
  final int durationMinutes;
  final List<RoutineExercise> exercises;

  const Routine({
    required this.name,
    required this.level,
    required this.description,
    required this.durationMinutes,
    required this.exercises,
  });
}

const List<Routine> defaultRoutines = [
  Routine(
    name: 'Full Body Inicial',
    level: 'Principiante',
    description: 'Rutina completa de cuerpo entero para empezar a moverse.',
    durationMinutes: 30,
    exercises: [
      RoutineExercise(name: 'Sentadillas al aire', sets: 3, reps: 12),
      RoutineExercise(name: 'Lagartijas en rodillas', sets: 3, reps: 10),
      RoutineExercise(name: 'Plancha frontal', sets: 3, reps: 20),
      RoutineExercise(name: 'Zancadas', sets: 3, reps: 10),
    ],
  ),
  Routine(
    name: 'Cardio Básico',
    level: 'Principiante',
    description:
        'Sesión ligera de cardio para activar el cuerpo y ganar resistencia.',
    durationMinutes: 25,
    exercises: [
      RoutineExercise(name: 'Marcha en el lugar', sets: 3, reps: 60),
      RoutineExercise(name: 'Rodillas al pecho', sets: 3, reps: 30),
      RoutineExercise(name: 'Saltos de tijera', sets: 3, reps: 20),
      RoutineExercise(name: 'Caminata rápida', sets: 3, reps: 120),
    ],
  ),
  Routine(
    name: 'Cuerpo Completo Intermedio',
    level: 'Intermedio',
    description: 'Rutina equilibrada que combina fuerza y resistencia.',
    durationMinutes: 45,
    exercises: [
      RoutineExercise(
        name: 'Sentadillas con peso',
        sets: 4,
        reps: 12,
        weight: 10,
      ),
      RoutineExercise(name: 'Lagartijas', sets: 4, reps: 12),
      RoutineExercise(
        name: 'Remo con mancuernas',
        sets: 4,
        reps: 10,
        weight: 8,
      ),
      RoutineExercise(name: 'Press de hombro', sets: 3, reps: 10, weight: 6),
      RoutineExercise(name: 'Plancha lateral', sets: 3, reps: 30),
    ],
  ),
  Routine(
    name: 'Fuerza Superior',
    level: 'Intermedio',
    description: 'Enfocada en pecho, espalda, hombros y brazos.',
    durationMinutes: 40,
    exercises: [
      RoutineExercise(name: 'Press de banca', sets: 4, reps: 10, weight: 12),
      RoutineExercise(name: 'Dominadas asistidas', sets: 3, reps: 8),
      RoutineExercise(name: 'Curl de bíceps', sets: 3, reps: 12, weight: 6),
      RoutineExercise(
        name: 'Extensiones de tríceps',
        sets: 3,
        reps: 12,
        weight: 5,
      ),
    ],
  ),
  Routine(
    name: 'Pierna Fuerte',
    level: 'Intermedio',
    description: 'Rutina de pierna y glúteo para desarrollar fuerza inferior.',
    durationMinutes: 40,
    exercises: [
      RoutineExercise(
        name: 'Sentadilla profunda',
        sets: 4,
        reps: 12,
        weight: 12,
      ),
      RoutineExercise(
        name: 'Peso muerto rumano',
        sets: 4,
        reps: 10,
        weight: 15,
      ),
      RoutineExercise(name: 'Zancadas con peso', sets: 3, reps: 12, weight: 8),
      RoutineExercise(
        name: 'Elevación de talones',
        sets: 3,
        reps: 20,
        weight: 10,
      ),
    ],
  ),
  Routine(
    name: 'HIIT Quema Calorías',
    level: 'Avanzado',
    description: 'Entrenamiento de alta intensidad por intervalos.',
    durationMinutes: 30,
    exercises: [
      RoutineExercise(name: 'Burpees', sets: 5, reps: 15),
      RoutineExercise(name: 'Saltos en caja', sets: 5, reps: 12),
      RoutineExercise(name: 'Mountain climbers', sets: 5, reps: 40),
      RoutineExercise(name: 'Sentadillas con salto', sets: 5, reps: 15),
    ],
  ),
  Routine(
    name: 'Fuerza Avanzada',
    level: 'Avanzado',
    description: 'Rutina intensa de fuerza con pesos libres.',
    durationMinutes: 60,
    exercises: [
      RoutineExercise(name: 'Sentadilla frontal', sets: 5, reps: 8, weight: 30),
      RoutineExercise(
        name: 'Press de banca pesado',
        sets: 5,
        reps: 6,
        weight: 25,
      ),
      RoutineExercise(name: 'Peso muerto', sets: 5, reps: 6, weight: 40),
      RoutineExercise(name: 'Remo con barra', sets: 4, reps: 8, weight: 20),
      RoutineExercise(name: 'Press militar', sets: 4, reps: 8, weight: 15),
    ],
  ),
  Routine(
    name: 'Reto Full Body',
    level: 'Avanzado',
    description: 'El reto definitivo: cuerpo completo a máxima intensidad.',
    durationMinutes: 50,
    exercises: [
      RoutineExercise(name: 'Thruster', sets: 5, reps: 10, weight: 12),
      RoutineExercise(name: 'Flexiones explosivas', sets: 4, reps: 12),
      RoutineExercise(name: 'Peso muerto sumo', sets: 4, reps: 10, weight: 30),
      RoutineExercise(name: 'Plancha con toque de hombro', sets: 4, reps: 30),
      RoutineExercise(name: 'Burpees con salto', sets: 4, reps: 12),
    ],
  ),
];
