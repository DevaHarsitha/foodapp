# CraveX — Smart Food Ordering System

> A full-stack food ordering web application built with HTML, CSS, JavaScript, Node.js, Express.js, and MySQL.

**Live Demo:** https://foodapp-yuy4.onrender.com/

**Source Code:** https://github.com/DevaHarsitha/foodapp

---

## Overview

CraveX is a full-stack food ordering application that provides an online platform for users to browse available food items, manage their cart, place orders, and track their order information.

The application follows a client-server architecture with a frontend interface connected to a RESTful backend API. User authentication is implemented using JSON Web Tokens (JWT), while MySQL is used for persistent data storage.

The system also includes administrative functionality for managing food items, users, orders, and application statistics.

---

## Features

### User Features

* User registration and login
* JWT-based authentication
* Browse available food items
* Filter food items by category
* Add and manage items in the cart
* Place food orders
* View previous orders
* View individual order details
* Order status tracking

### Admin Features

* Admin authentication
* View all registered users
* View and manage orders
* Update order status
* Add new food items
* Edit existing food items
* Remove food items
* View dashboard statistics

### Additional Features

* Password hashing using bcrypt
* RESTful API architecture
* MySQL relational database
* Responsive web interface
* Backend serving of frontend static files
* Category-based food filtering

---

## System Architecture

```text
                         CraveX
                           |
              ┌────────────┴────────────┐
              |                         |
          Frontend                  Backend API
      HTML / CSS / JavaScript      Node.js / Express
              |                         |
              |                    JWT Authentication
              |                         |
              └────────────┬────────────┘
                           |
                         MySQL
                           |
              ┌────────────┼────────────┐
              |            |            |
            Users        Foods        Orders
```

---

## Technology Stack

| Category          | Technologies            |
| ----------------- | ----------------------- |
| Frontend          | HTML5, CSS3, JavaScript |
| Backend           | Node.js, Express.js     |
| Database          | MySQL                   |
| Authentication    | JWT                     |
| Password Security | bcryptjs                |
| API               | REST API                |
| Database Driver   | mysql2                  |
| Development       | Nodemon                 |
| Deployment        | Render                  |

The backend dependencies and scripts are defined in the project's `package.json`, including Express, MySQL2, JWT, bcryptjs, CORS, and Nodemon.

---

## Project Structure

```text
foodapp/
│
├── backend/
│   ├── server.js
│   ├── database.sql
│   ├── package.json
│   ├── package-lock.json
│   └── README.md
│
├── frontend/
│   └── index.html
│
└── README.md
```

The repository is organized into separate frontend and backend components, with the backend containing the Express server and MySQL database setup.

---

## API Endpoints

### Authentication

| Method | Endpoint             | Description                        |
| ------ | -------------------- | ---------------------------------- |
| POST   | `/api/auth/register` | Register a new user                |
| POST   | `/api/auth/login`    | Authenticate user and generate JWT |
| GET    | `/api/auth/me`       | Retrieve authenticated user        |

### Food

| Method | Endpoint         | Description                   |
| ------ | ---------------- | ----------------------------- |
| GET    | `/api/foods`     | Retrieve available food items |
| GET    | `/api/foods/:id` | Retrieve a specific food item |
| POST   | `/api/foods`     | Add a food item               |
| PUT    | `/api/foods/:id` | Update a food item            |
| DELETE | `/api/foods/:id` | Delete a food item            |

### Orders

| Method | Endpoint          | Description                |
| ------ | ----------------- | -------------------------- |
| POST   | `/api/orders`     | Place a new order          |
| GET    | `/api/orders`     | Retrieve the user's orders |
| GET    | `/api/orders/:id` | Retrieve a specific order  |

### Admin

| Method | Endpoint                       | Description                   |
| ------ | ------------------------------ | ----------------------------- |
| GET    | `/api/admin/orders`            | Retrieve all orders           |
| PATCH  | `/api/admin/orders/:id/status` | Update order status           |
| GET    | `/api/admin/users`             | Retrieve all users            |
| GET    | `/api/admin/stats`             | Retrieve dashboard statistics |

---

## Authentication Flow

```text
User Registration
       |
       v
Password Hashing
       |
       v
Store User in MySQL
       |
       v
User Login
       |
       v
Validate Credentials
       |
       v
Generate JWT
       |
       v
Authenticated API Requests
```

Passwords are hashed using bcrypt before being stored, and authenticated requests use JWT tokens for authorization.

---

## Order Processing

```text
Select Food
     |
     v
Add to Cart
     |
     v
Review Cart
     |
     v
Place Order
     |
     v
Validate JWT
     |
     v
Create Order
     |
     v
Store Order Items
     |
     v
Order Status: Placed
```

The backend calculates the order total and stores the order and its individual items in MySQL.

---

## Database

CraveX uses MySQL as its relational database.

The database contains the core entities required for the food ordering workflow:

```text
Users
  |
  └── Orders
        |
        └── Order Items
                |
                └── Foods
```

The repository includes `database.sql` for database creation and initial data setup.

---

## Getting Started

### Prerequisites

* Node.js 18+
* MySQL
* Git
* npm


### Start the Backend

For development:

```bash
npm run dev
```

For production:

```bash
npm start
```

The application runs on:

```text
http://localhost:5000
```

---

## Deployment

CraveX is deployed using Render.

**Live Application:**
https://foodapp-yuy4.onrender.com/

The Express backend serves the frontend application and handles API requests for authentication, food items, and orders.

---

## Future Enhancements

* Online payment integration
* Real-time order tracking
* Delivery address management
* Email/SMS order notifications
* Improved admin dashboard
* Customer reviews and ratings
* Advanced food search and filtering
* Order cancellation and refund management

---

## Author

### Deva Harsitha B V

Computer Science Engineering Student

**GitHub:** https://github.com/DevaHarsitha\
