-- ════════════════════════════════════════
--  CraveX Database Schema
--  Run this file in MySQL to set up the DB
-- ════════════════════════════════════════

CREATE DATABASE IF NOT EXISTS cravex_db;
USE cravex_db;

-- ── USERS ──
CREATE TABLE IF NOT EXISTS users (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(100) NOT NULL,
  email      VARCHAR(150) NOT NULL UNIQUE,
  password   VARCHAR(255) NOT NULL,
  role       ENUM('user', 'admin') DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ── FOODS ──
CREATE TABLE IF NOT EXISTS foods (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(150) NOT NULL,
  description  TEXT,
  price        DECIMAL(8, 2) NOT NULL,
  category     ENUM('popular', 'veg', 'nonveg', 'dessert') NOT NULL,
  food_type    ENUM('veg', 'nonveg') NOT NULL,
  emoji        VARCHAR(10) DEFAULT '🍽️',
  badge        VARCHAR(50) DEFAULT NULL,
  rating       DECIMAL(2,1) DEFAULT 4.5,
  is_popular   TINYINT(1) DEFAULT 0,
  is_available TINYINT(1) DEFAULT 1,
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ── ORDERS ──
CREATE TABLE IF NOT EXISTS orders (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  user_id      INT NOT NULL,
  total_amount DECIMAL(10, 2) NOT NULL,
  status       ENUM('placed','preparing','out_for_delivery','delivered','cancelled') DEFAULT 'placed',
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ── ORDER ITEMS ──
CREATE TABLE IF NOT EXISTS order_items (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  order_id  INT NOT NULL,
  food_id   INT NOT NULL,
  quantity  INT NOT NULL DEFAULT 1,
  price     DECIMAL(8, 2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (food_id)  REFERENCES foods(id)  ON DELETE CASCADE
);

-- ════════════════════════════════════════
--  SEED DATA — Admin user & Food items
-- ════════════════════════════════════════

-- Admin user (password: admin123)
INSERT INTO users (name, email, password, role) VALUES
('Admin', 'admin@cravex.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHHi', 'admin');

-- Food items
INSERT INTO foods (name, description, price, category, food_type, emoji, badge, rating, is_popular) VALUES
('CraveX Classic Burger',  'Smashed double patty, special sauce, pickles',        149, 'popular', 'nonveg', '🍔', NULL,    4.8, 1),
('Margherita Pizza',        'San Marzano tomato, fresh mozzarella, basil',          249, 'popular', 'veg',    '🍕', 'veg',   4.7, 1),
('Spicy Ramen Bowl',        'Rich tonkotsu broth, soft-boiled egg, chashu',         199, 'popular', 'nonveg', '🍜', 'spicy', 4.9, 1),
('Garden Buddha Bowl',      'Quinoa, roasted veggies, tahini dressing',             179, 'veg',     'veg',    '🥗', 'veg',   4.6, 0),
('Grilled Chicken Wrap',    'Harissa chicken, avocado, herb yoghurt',               169, 'nonveg',  'nonveg', '🍗', NULL,    4.7, 0),
('Street Tacos (3pc)',      'Al pastor, salsa verde, pickled onion',                139, 'popular', 'nonveg', '🌮', '🔥 Hot',4.8, 1),
('Mango Kulfi Sundae',      'House-made kulfi, rose compote, pistachios',           99,  'dessert', 'veg',    '🍦', 'veg',   4.9, 0),
('Masala French Toast',     'Brioche, spiced egg custard, chutney',                 129, 'popular', 'veg',    '🧇', 'veg',   4.5, 1),
('Bento Box Special',       'Rice, miso soup, teriyaki, edamame',                   219, 'veg',     'veg',    '🍱', 'veg',   4.6, 0),
('Dark Choco Lava Cake',    'Warm valrhona centre, vanilla ice cream',              119, 'dessert', 'veg',    '🍰', 'veg',   4.9, 0),
('Butter Garlic Prawns',    'Tiger prawns, lemon butter, micro herbs',              349, 'nonveg',  'nonveg', '🦞', NULL,    4.8, 0),
('Falafel Pita',            'Crispy falafel, hummus, cucumber, sumac',              159, 'veg',     'veg',    '🥙', 'veg',   4.5, 0);