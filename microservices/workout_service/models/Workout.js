const db = require('../config/db');

const parseWorkout = (row) => {
  if (!row) return null;

  return {
    ...row,
    id: String(row.id),
    userId: String(row.userId),
    exercises: JSON.parse(row.exercises || '[]')
  };
};

const Workout = {
  create({
    userId,
    name,
    exercises,
    durationMinutes,
    notes,
    workoutDate
  }) {
    const info = db
      .prepare(
        `INSERT INTO workouts
          (userId, name, exercises, durationMinutes, notes, workoutDate)
         VALUES (?, ?, ?, ?, ?, ?)`
      )
      .run(
        userId,
        name,
        JSON.stringify(exercises),
        durationMinutes,
        notes,
        workoutDate.toISOString()
      );

    const row = db
      .prepare('SELECT * FROM workouts WHERE id = ?')
      .get(info.lastInsertRowid);

    return parseWorkout(row);
  },

  findByUser(userId) {
    const rows = db
      .prepare(
        `SELECT * FROM workouts
         WHERE userId = ?
         ORDER BY workoutDate DESC`
      )
      .all(userId);

    return rows.map(parseWorkout);
  },

  findByUserInRange(userId, start, end) {
    const rows = db
      .prepare(
        `SELECT * FROM workouts
         WHERE userId = ? AND workoutDate >= ? AND workoutDate < ?
         ORDER BY workoutDate DESC`
      )
      .all(userId, start.toISOString(), end.toISOString());

    return rows.map(parseWorkout);
  }
};

module.exports = Workout;