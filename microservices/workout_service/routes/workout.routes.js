const express = require('express');

const {
  createWorkout,
  getWorkouts,
  getWeeklyWorkouts
} = require('../controllers/workout.controller');

const verifyToken = require(
  '../middleware/auth.middleware'
);

const router = express.Router();

router.post(
  '/',
  verifyToken,
  createWorkout
);

router.get(
  '/',
  verifyToken,
  getWorkouts
);

router.get(
  '/weekly',
  verifyToken,
  getWeeklyWorkouts
);

module.exports = router;