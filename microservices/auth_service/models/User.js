const db = require('../config/db');

const User = {
  findByEmail(email) {
    return db
      .prepare('SELECT * FROM users WHERE email = ?')
      .get(email) || null;
  },

  findById(id) {
    return db
      .prepare('SELECT * FROM users WHERE id = ?')
      .get(id) || null;
  },

  create({ name, email, passwordHash }) {
    const info = db
      .prepare(
        'INSERT INTO users (name, email, passwordHash) VALUES (?, ?, ?)'
      )
      .run(name, email, passwordHash);

    return User.findById(info.lastInsertRowid);
  }
};

module.exports = User;