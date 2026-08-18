const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

dotenv.config();

const db = require('./config/db');
const authRoutes = require('./routes/auth.routes');

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

app.get('/health', (req, res) => {
  res.status(200).json({
    service: 'auth_service',
    status: 'OK',
    message: 'Microservicio de autenticacion funcionando'
  });
});

app.use('/auth', authRoutes);

const startServer = () => {
  try {
    db.exec('SELECT 1');

    app.listen(PORT, () => {
      console.log(
        `Auth Service ejecutandose en http://localhost:${PORT}`
      );
    });
  } catch (error) {
    console.error(
      'No se pudo iniciar auth_service:',
      error.message
    );

    process.exit(1);
  }
};

startServer();