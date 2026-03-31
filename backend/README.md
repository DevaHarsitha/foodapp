# CraveX Backend – Setup Guide

## Tech Stack
- **Runtime:** Node.js
- **Framework:** Express.js
- **Database:** MySQL
- **Auth:** JWT (JSON Web Tokens)
- **Password:** bcryptjs

---

## Prerequisites
- Node.js v18+ installed
- MySQL installed and running
- (Optional) Postman to test APIs

---

## Setup Steps

### 1. Install dependencies
```bash
cd cravex-backend
npm install
```

### 2. Set up the database
Open MySQL and run:
```bash
mysql -u root -p < database.sql
```
This creates the `cravex_db` database, all tables, and seeds food data + admin account.

### 3. Configure database password
Open `server.js` and edit line 12:
```js
password: 'yourpassword',   // ← replace with your MySQL root password
```

### 4. Start the server
```bash
npm start          # production
npm run dev        # development with auto-reload
```
Server runs at: **http://localhost:5000**

---

## API Endpoints

### Auth
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | Register new user |
| POST | `/api/auth/login` | Login & get JWT token |
| GET | `/api/auth/me` | Get current user (auth required) |

**Register body:**
```json
{ "name": "Rahul", "email": "rahul@email.com", "password": "pass123" }
```

**Login body:**
```json
{ "email": "rahul@email.com", "password": "pass123" }
```

**Login response:**
```json
{ "token": "eyJhb...", "user": { "id": 1, "name": "Rahul", "role": "user" } }
```

---

### Foods (Public)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/foods` | Get all foods |
| GET | `/api/foods?category=veg` | Filter by category |
| GET | `/api/foods/:id` | Get single food item |

**Categories:** `all`, `popular`, `veg`, `nonveg`, `dessert`

---

### AI Recommendations (Public)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/recommendations?time=morning` | Get AI food suggestions |

**Time values:** `morning`, `afternoon`, `evening`, `night`

---

### Orders (Auth Required)
Send header: `Authorization: Bearer <your_jwt_token>`

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/orders` | Place an order |
| GET | `/api/orders` | Get my orders |
| GET | `/api/orders/:id` | Get single order |

**Place order body:**
```json
{
  "items": [
    { "food_id": 1, "quantity": 2, "price": 149 },
    { "food_id": 3, "quantity": 1, "price": 199 }
  ]
}
```

---

### Admin Routes (Admin JWT Required)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/admin/orders` | All orders |
| PATCH | `/api/admin/orders/:id/status` | Update order status |
| GET | `/api/admin/users` | All users |
| GET | `/api/admin/stats` | Dashboard stats |
| POST | `/api/foods` | Add food item |
| PUT | `/api/foods/:id` | Edit food item |
| DELETE | `/api/foods/:id` | Remove food item |

**Admin login:**
- Email: `admin@cravex.com`
- Password: `admin123`

**Update order status body:**
```json
{ "status": "preparing" }
```
Valid statuses: `placed`, `preparing`, `out_for_delivery`, `delivered`, `cancelled`

---

## Connecting Frontend to Backend

In your `index.html`, replace static food data and cart with API calls.

**Example – Load foods from backend:**
```js
async function loadFoods(category = 'all') {
  const res = await fetch(`http://localhost:5000/api/foods?category=${category}`);
  const foods = await res.json();
  renderMenu(foods);
}
```

**Example – Place order:**
```js
async function placeOrder(cartItems) {
  const token = localStorage.getItem('token');
  const items = cartItems.map(c => ({
    food_id: c.id, quantity: c.qty, price: c.price
  }));
  const res = await fetch('http://localhost:5000/api/orders', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    },
    body: JSON.stringify({ items })
  });
  const data = await res.json();
  console.log('Order placed!', data.order_id);
}
```

---

## Project Structure
```
cravex-backend/
├── server.js        ← Main Express server (all routes)
├── database.sql     ← MySQL schema + seed data
├── package.json     ← Dependencies
└── README.md        ← This file
```
