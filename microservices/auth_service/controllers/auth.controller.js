const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const jwt = require('jsonwebtoken');

const users = require('../data/users');


// ==========================================
// REGISTRO
// ==========================================

const register = async (req, res) => {
  try {
    const { name, email, password } = req.body;

    // Validar campos obligatorios
    if (!name || !email || !password) {
      return res.status(400).json({
        message: 'Nombre, correo y contraseña son obligatorios'
      });
    }

    // Validar longitud de contraseña
    if (password.length < 6) {
      return res.status(400).json({
        message: 'La contraseña debe tener al menos 6 caracteres'
      });
    }

    const normalizedEmail = email.toLowerCase().trim();

    // Verificar si el correo ya está registrado
    const existingUser = users.find(
      (user) => user.email === normalizedEmail
    );

    if (existingUser) {
      return res.status(409).json({
        message: 'El correo ya está registrado'
      });
    }

    // Cifrar contraseña
    const passwordHash = await bcrypt.hash(password, 10);

    // Crear usuario
    const newUser = {
      id: crypto.randomUUID(),
      name: name.trim(),
      email: normalizedEmail,
      passwordHash,
      createdAt: new Date().toISOString()
    };

    users.push(newUser);

    return res.status(201).json({
      message: 'Usuario registrado correctamente',

      user: {
        id: newUser.id,
        name: newUser.name,
        email: newUser.email,
        createdAt: newUser.createdAt
      }
    });

  } catch (error) {

    console.error('Error al registrar usuario:', error);

    return res.status(500).json({
      message: 'Error interno del servidor'
    });
  }
};


// ==========================================
// LOGIN
// ==========================================

const login = async (req, res) => {
  try {

    const { email, password } = req.body;

    // Validar campos
    if (!email || !password) {
      return res.status(400).json({
        message: 'Correo y contraseña son obligatorios'
      });
    }

    const normalizedEmail = email.toLowerCase().trim();

    // Buscar usuario
    const user = users.find(
      (user) => user.email === normalizedEmail
    );

    if (!user) {
      return res.status(401).json({
        message: 'Correo o contraseña incorrectos'
      });
    }

    // Comparar contraseña
    const passwordCorrect = await bcrypt.compare(
      password,
      user.passwordHash
    );

    if (!passwordCorrect) {
      return res.status(401).json({
        message: 'Correo o contraseña incorrectos'
      });
    }

    // Generar token
    const token = jwt.sign(
      {
        userId: user.id,
        email: user.email
      },
      process.env.JWT_SECRET,
      {
        expiresIn: '2h'
      }
    );

    return res.status(200).json({
      message: 'Inicio de sesión exitoso',

      token,

      user: {
        id: user.id,
        name: user.name,
        email: user.email
      }
    });

  } catch (error) {

    console.error('Error al iniciar sesión:', error);

    return res.status(500).json({
      message: 'Error interno del servidor'
    });
  }
};


module.exports = {
  register,
  login
};