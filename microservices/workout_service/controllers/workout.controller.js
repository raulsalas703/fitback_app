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

    if (!name || name.trim().isEmpty) {
      return res.status(400).json({
        message: 'El nombre del entrenamiento es obligatorio'
      });
    }

    if (!Array.isArray(exercises) || exercises.length === 0) {
      return res.status(400).json({
        message: 'Debes agregar al menos un ejercicio'
      });
    }

    const workout = await Workout.create({
      userId: req.user.userId,
      name: name.trim(),
      exercises,
      durationMinutes: durationMinutes || 0,
      notes: notes || '',
      workoutDate: workoutDate || new Date()
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

module.exports = {
  createWorkout
};