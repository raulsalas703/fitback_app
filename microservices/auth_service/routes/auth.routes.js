const express = require('express');

const {
  register,
  login,
  getProfile
} = require('../controllers/auth.controller');

const verifyToken = require('../middleware/auth.middleware');

const router = express.Router();

router.post('/register', register);

router.post('/login', login);

router.get('/verify', verifyToken, (req, res) => {
  res.status(200).json({
    message: 'Token válido',
    user: req.user
  });
});

router.get('/profile', verifyToken, getProfile);

module.exports = router;