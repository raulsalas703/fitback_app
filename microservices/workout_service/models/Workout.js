const mongoose = require('mongoose');

const exerciseSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true
    },

    sets: {
      type: Number,
      required: true,
      min: 1
    },

    reps: {
      type: Number,
      required: true,
      min: 1
    },

    weight: {
      type: Number,
      default: 0,
      min: 0
    }
  },
  {
    _id: false
  }
);

const workoutSchema = new mongoose.Schema(
  {
    userId: {
      type: String,
      required: true
    },

    name: {
      type: String,
      required: true,
      trim: true
    },

    exercises: {
      type: [exerciseSchema],
      required: true,
      default: []
    },

    durationMinutes: {
      type: Number,
      default: 0,
      min: 0
    },

    notes: {
      type: String,
      trim: true,
      default: ''
    },

    workoutDate: {
      type: Date,
      default: Date.now
    }
  },
  {
    timestamps: true
  }
);

module.exports = mongoose.model(
  'Workout',
  workoutSchema
);