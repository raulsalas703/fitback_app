const express = require('express');

const {
  createWorkout
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

module.exports = router;