const connectDB = require('./config/db');
const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

const authRoutes = require('./routes/auth.routes');

dotenv.config();

connectDB();

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());
app.use('/auth', authRoutes);

app.get('/health', (req, res) => {
  res.status(200).json({
    service: 'auth_service',
    status: 'OK',
    message: 'Microservicio de autenticacion funcionando'
  });
});

// Rutas de autenticación
app.use('/auth', authRoutes);

app.listen(PORT, () => {
  console.log(`Auth Service ejecutandose en http://localhost:${PORT}`);
});