const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);

    console.log('MongoDB Atlas conectado en workout_service');
  } catch (error) {
    console.error('Error al conectar workout_service con MongoDB Atlas:');
    console.error(error.message);

    process.exit(1);
  }
};

module.exports = connectDB;