const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3002;

app.use(cors());
app.use(express.json());

// Ruta de prueba
app.get('/health', (req, res) => {
  res.status(200).json({
    service: 'workout_service',
    status: 'OK',
    message: 'Microservicio de entrenamientos funcionando'
  });
});

app.listen(PORT, () => {
  console.log(
    `Workout Service ejecutandose en http://localhost:${PORT}`
  );
});