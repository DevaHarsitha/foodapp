const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const path = require('path');

const app = express();

// ── MIDDLEWARE ──


app.use(cors({ origin: '*'}));
app.use(express.json());

// ✅ SERVE FRONTEND (IMPORTANT FIX)
app.use(express.static(path.join(__dirname, '../frontend')));

// Default route → open index.html
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '../frontend/index.html'));
});

const JWT_SECRET = 'cravex_secret_2025';

// ── DATABASE CONFIG ──
const dbConfig = {
  host: 'localhost',
  user: 'root',
  password: 'yourpassword', // 🔴 CHANGE THIS
  database: 'cravex_db',
};

async function getDB() {
  return mysql.createConnection(dbConfig);
}

// ── AUTH MIDDLEWARE ──
function authMiddleware(req, res, next) {
  const token = req.headers['authorization']?.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'No token provided' });

  try {
    req.user = jwt.verify(token, JWT_SECRET);
    next();
  } catch {
    res.status(401).json({ error: 'Invalid token' });
  }
}

// ════════════════════════════════
// AUTH ROUTES
// ════════════════════════════════

app.post('/api/auth/register', async (req, res) => {
  const { name, email, password } = req.body;

  if (!name || !email || !password)
    return res.status(400).json({ error: 'All fields required' });

  const db = await getDB();
  try {
    const [existing] = await db.execute(
      'SELECT id FROM users WHERE email = ?',
      [email]
    );

    if (existing.length > 0)
      return res.status(409).json({ error: 'Email already exists' });

    const hash = await bcrypt.hash(password, 10);

    await db.execute(
      'INSERT INTO users (name, email, password) VALUES (?, ?, ?)',
      [name, email, hash]
    );

    res.json({ message: 'Registered successfully' });
  } finally {
    db.end();
  }
});

// LOGIN
app.post('/api/auth/login', async (req, res) => {
  const { email, password } = req.body;

  const db = await getDB();
  try {
    const [rows] = await db.execute(
      'SELECT * FROM users WHERE email = ?',
      [email]
    );

    if (rows.length === 0)
      return res.status(401).json({ error: 'Invalid credentials' });

    const user = rows[0];
    const match = await bcrypt.compare(password, user.password);

    if (!match)
      return res.status(401).json({ error: 'Invalid credentials' });

    const token = jwt.sign(
      { id: user.id, role: user.role },
      JWT_SECRET,
      { expiresIn: '7d' }
    );

    res.json({ token, user });
  } finally {
    db.end();
  }
});

// ════════════════════════════════
// FOOD ROUTES
// ════════════════════════════════

app.get('/api/foods', async (req, res) => {
  const db = await getDB();
  try {
    const [rows] = await db.execute(
      'SELECT * FROM foods WHERE is_available = 1'
    );
    res.json(rows);
  } finally {
    db.end();
  }
});

// ════════════════════════════════
// ORDER ROUTES
// ════════════════════════════════

app.post('/api/orders', authMiddleware, async (req, res) => {
  const { items } = req.body;

  if (!items || items.length === 0)
    return res.status(400).json({ error: 'Cart empty' });

  const total = items.reduce(
    (sum, i) => sum + i.price * i.quantity,
    0
  );

  const db = await getDB();
  try {
    const [orderResult] = await db.execute(
      'INSERT INTO orders (user_id, total_amount, status) VALUES (?, ?, ?)',
      [req.user.id, total, 'placed']
    );

    const orderId = orderResult.insertId;

    for (const item of items) {
      await db.execute(
        'INSERT INTO order_items (order_id, food_id, quantity, price) VALUES (?, ?, ?, ?)',
        [orderId, item.food_id, item.quantity, item.price]
      );
    }

    res.json({
      message: 'Order placed',
      orderId,
      total,
    });
  } finally {
    db.end();
  }
});

// ════════════════════════════════
// START SERVER
// ════════════════════════════════

const PORT = 5000;

app.listen(PORT, () => {
  console.log(`✅ CraveX running at https://foodapp-yuy4.onrender.com`);
});
