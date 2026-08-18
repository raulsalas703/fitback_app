const Workout = require('../models/Workout');

const createWorkout = async (req, res) => {
  try {
    const {
      name,
      exercises,
      durationMinutes,
      notes,
      workoutDate
    } = req.body;

    if (!name || name.trim().length === 0) {
      return res.status(400).json({
        message: 'El nombre del entrenamiento es obligatorio'
      });
    }

    if (!Array.isArray(exercises) || exercises.length === 0) {
      return res.status(400).json({
        message: 'Debes agregar al menos un ejercicio'
      });
    }

    const workout = Workout.create({
      userId: req.user.userId,
      name: name.trim(),
      exercises,
      durationMinutes: durationMinutes || 0,
      notes: notes || '',
      workoutDate: workoutDate
        ? new Date(workoutDate)
        : new Date()
    });

    return res.status(201).json({
      message: 'Entrenamiento registrado correctamente',
      workout
    });

  } catch (error) {
    console.error(
      'Error al registrar entrenamiento:',
      error
    );

    return res.status(500).json({
      message: 'Error interno del servidor'
    });
  }
};

// ==========================================
// LISTAR ENTRENAMIENTOS (HISTORIAL)
// ==========================================

const getWorkouts = async (req, res) => {
  try {
    const workouts = Workout.findByUser(
      req.user.userId
    );

    return res.status(200).json({
      message: 'Entrenamientos obtenidos correctamente',
      workouts
    });

  } catch (error) {
    console.error(
      'Error al obtener entrenamientos:',
      error
    );

    return res.status(500).json({
      message: 'Error interno del servidor'
    });
  }
};

// ==========================================
// ENTRENAMIENTOS DE LA SEMANA ACTUAL
// ==========================================

const getWeeklyWorkouts = async (req, res) => {
  try {
    const now = new Date();

    const startOfWeek = new Date(now);
    const day = startOfWeek.getDay() || 7;
    startOfWeek.setDate(startOfWeek.getDate() - day + 1);
    startOfWeek.setHours(0, 0, 0, 0);

    const endOfWeek = new Date(startOfWeek);
    endOfWeek.setDate(endOfWeek.getDate() + 7);

    const workouts = Workout.findByUserInRange(
      req.user.userId,
      startOfWeek,
      endOfWeek
    );

    return res.status(200).json({
      message: 'Entrenamientos semanales obtenidos correctamente',
      total: workouts.length,
      workouts
    });

  } catch (error) {
    console.error(
      'Error al obtener entrenamientos semanales:',
      error
    );

    return res.status(500).json({
      message: 'Error interno del servidor'
    });
  }
};

module.exports = {
  createWorkout,
  getWorkouts,
  getWeeklyWorkouts
};