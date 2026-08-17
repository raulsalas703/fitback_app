const express = require('express');

const {
  register,
  login
} = require('../controllers/auth.controller');

const verifyToken = require('../middleware/auth.middleware');

const router = express.Router();

router.post('/register', register);

router.post('/login', login);


// Ruta protegida
router.get('/verify', verifyToken, (req, res) => {
  res.status(200).json({
    message: 'Token válido',
    user: req.user
  });
});

module.exports = router;