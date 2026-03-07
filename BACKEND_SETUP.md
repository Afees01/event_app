# Backend API Implementation (Node.js + Express)

This guide shows how to implement the backend API that your Flutter app will connect to.

## 📦 Backend Setup

### **1. Install Dependencies**

```bash
npm init -y
npm install express cors bcryptjs jsonwebtoken dotenv mysql2
npm install --save-dev nodemon
```

### **2. Create .env File**

```env
PORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=event_management
JWT_SECRET=your_secret_key_here
JWT_EXPIRE=24h
```

### **3. Database Schema (MySQL/Oracle)**

```sql
-- Users Table
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  fullName VARCHAR(255) NOT NULL,
  userType ENUM('admin', 'user') DEFAULT 'user',
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Events Table
CREATE TABLE events (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  date DATETIME NOT NULL,
  location VARCHAR(255),
  capacity INT,
  adminId INT NOT NULL,
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (adminId) REFERENCES users(id)
);

-- Event Registrations Table
CREATE TABLE event_registrations (
  id INT PRIMARY KEY AUTO_INCREMENT,
  eventId INT NOT NULL,
  userId INT NOT NULL,
  fullName VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  registeredAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (eventId) REFERENCES events(id),
  FOREIGN KEY (userId) REFERENCES users(id),
  UNIQUE KEY unique_registration (eventId, userId)
);
```

---

## 🔐 Authentication API Endpoints

### **User Login**
```http
POST /api/auth/user-login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}

Response 200:
{
  "success": true,
  "message": "Login successful",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "fullName": "John Doe",
    "userType": "user"
  },
  "token": "eyJhbGc..."
}
```

### **User Signup**
```http
POST /api/auth/user-signup
Content-Type: application/json

{
  "email": "newuser@example.com",
  "password": "password123",
  "fullName": "Jane Doe"
}

Response 201:
{
  "success": true,
  "message": "Signup successful",
  "user": {
    "id": 2,
    "email": "newuser@example.com",
    "fullName": "Jane Doe",
    "userType": "user"
  },
  "token": "eyJhbGc..."
}
```

### **Admin Login**
```http
POST /api/auth/admin-login
Content-Type: application/json

{
  "email": "admin@example.com",
  "password": "admin123"
}
```

### **Admin Signup**
```http
POST /api/auth/admin-signup
Content-Type: application/json

{
  "email": "newadmin@example.com",
  "password": "admin123",
  "fullName": "Admin User"
}

Note: In production, only create admin accounts through secure admin panel
```

---

## 📅 Event Management API Endpoints

### **Get All Events**
```http
GET /api/events
Authorization: Bearer {token}

Response 200:
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "Flutter Workshop",
      "description": "Learn Flutter development",
      "date": "2024-04-15T10:00:00Z",
      "location": "New York",
      "capacity": 100,
      "registrations": 45
    }
  ]
}
```

### **Get Event Details**
```http
GET /api/events/{eventId}
Authorization: Bearer {token}

Response 200:
{
  "success": true,
  "data": {
    "id": 1,
    "title": "Flutter Workshop",
    "description": "Learn Flutter development",
    "date": "2024-04-15T10:00:00Z",
    "location": "New York",
    "capacity": 100,
    "registrations": [
      {
        "id": 1,
        "fullName": "User Name",
        "email": "user@example.com",
        "phone": "1234567890"
      }
    ]
  }
}
```

### **Admin: Create Event**
```http
POST /api/admin/events
Authorization: Bearer {admin_token}
Content-Type: application/json

{
  "title": "React Workshop",
  "description": "Learn React development",
  "date": "2024-05-15T10:00:00Z",
  "location": "San Francisco",
  "capacity": 80
}

Response 201:
{
  "success": true,
  "message": "Event created successfully",
  "data": {
    "id": 3,
    "title": "React Workshop",
    ...
  }
}
```

### **Admin: Update Event**
```http
PUT /api/admin/events/{eventId}
Authorization: Bearer {admin_token}
Content-Type: application/json

{
  "title": "React Workshop - Updated",
  "description": "...",
  "date": "...",
  "location": "...",
  "capacity": 100
}
```

### **Admin: Delete Event**
```http
DELETE /api/admin/events/{eventId}
Authorization: Bearer {admin_token}

Response 200:
{
  "success": true,
  "message": "Event deleted successfully"
}
```

### **User: Register for Event**
```http
POST /api/events/{eventId}/register
Authorization: Bearer {user_token}
Content-Type: application/json

{
  "fullName": "John Doe",
  "email": "john@example.com",
  "phone": "1234567890"
}

Response 201:
{
  "success": true,
  "message": "Registered successfully",
  "data": {
    "id": 1,
    "eventId": 1,
    "userId": 1,
    "registeredAt": "2024-04-10T12:00:00Z"
  }
}
```

### **User: Get My Events**
```http
GET /api/my-events
Authorization: Bearer {user_token}

Response 200:
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "Flutter Workshop",
      "date": "2024-04-15T10:00:00Z",
      "location": "New York",
      "registeredAt": "2024-04-10T12:00:00Z"
    }
  ]
}
```

---

## 💻 Sample Backend Code (Express.js)

### **app.js**
```javascript
const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const authRoutes = require('./routes/auth');
const eventRoutes = require('./routes/events');

dotenv.config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/events', eventRoutes);
app.use('/api/admin', eventRoutes);

// Error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    message: 'Internal server error'
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

### **routes/auth.js**
```javascript
const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../config/database');

const router = express.Router();

// User Login
router.post('/user-login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Validate input
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Email and password required'
      });
    }

    // Check user exists
    const [users] = await db.query(
      'SELECT * FROM users WHERE email = ? AND userType = "user"',
      [email]
    );

    if (users.length === 0) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials'
      });
    }

    const user = users[0];

    // Compare password
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials'
      });
    }

    // Generate token
    const token = jwt.sign(
      { id: user.id, email: user.email, userType: 'user' },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRE }
    );

    res.json({
      success: true,
      message: 'Login successful',
      user: {
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        userType: user.userType
      },
      token
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Login failed: ' + error.message
    });
  }
});

// User Signup
router.post('/user-signup', async (req, res) => {
  try {
    const { email, password, fullName } = req.body;

    // Validate input
    if (!email || !password || !fullName) {
      return res.status(400).json({
        success: false,
        message: 'Email, password, and full name required'
      });
    }

    // Check if user exists
    const [existingUsers] = await db.query(
      'SELECT * FROM users WHERE email = ?',
      [email]
    );

    if (existingUsers.length > 0) {
      return res.status(400).json({
        success: false,
        message: 'Email already registered'
      });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create user
    const [result] = await db.query(
      'INSERT INTO users (email, password, fullName, userType) VALUES (?, ?, ?, "user")',
      [email, hashedPassword, fullName]
    );

    // Generate token
    const token = jwt.sign(
      { id: result.insertId, email, userType: 'user' },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRE }
    );

    res.status(201).json({
      success: true,
      message: 'Signup successful',
      user: {
        id: result.insertId,
        email,
        fullName,
        userType: 'user'
      },
      token
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Signup failed: ' + error.message
    });
  }
});

// Admin Login
router.post('/admin-login', async (req, res) => {
  // Similar to user login but check userType = 'admin'
  try {
    const { email, password } = req.body;

    const [users] = await db.query(
      'SELECT * FROM users WHERE email = ? AND userType = "admin"',
      [email]
    );

    if (users.length === 0) {
      return res.status(401).json({
        success: false,
        message: 'Invalid admin credentials'
      });
    }

    const user = users[0];
    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      return res.status(401).json({
        success: false,
        message: 'Invalid admin credentials'
      });
    }

    const token = jwt.sign(
      { id: user.id, email: user.email, userType: 'admin' },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRE }
    );

    res.json({
      success: true,
      message: 'Admin login successful',
      user: {
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        userType: user.userType
      },
      token
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Admin login failed: ' + error.message
    });
  }
});

module.exports = router;
```

### **config/database.js**
```javascript
const mysql = require('mysql2/promise');
const dotenv = require('dotenv');

dotenv.config();

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

module.exports = pool;
```

---

## 🔧 Middleware for Authentication

```javascript
// middleware/auth.js
const jwt = require('jsonwebtoken');

const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({
      success: false,
      message: 'Token required'
    });
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({
        success: false,
        message: 'Invalid or expired token'
      });
    }
    req.user = user;
    next();
  });
};

const requireAdmin = (req, res, next) => {
  if (req.user.userType !== 'admin') {
    return res.status(403).json({
      success: false,
      message: 'Admin access required'
    });
  }
  next();
};

module.exports = { authenticateToken, requireAdmin };
```

---

## 🚀 Running the Backend

```bash
# Development with nodemon
npm run dev

# Production
npm start
```

---

## 📝 Environment Configuration

Make sure to:
1. Update `api_service.dart` with your backend URL
2. Create admin accounts through the admin-signup endpoint or directly in DB
3. Test endpoints using Postman before connecting to Flutter

## ✅ Testing Checklist

- [ ] User signup works
- [ ] User login works
- [ ] Admin login works
- [ ] Tokens are returned
- [ ] Protected routes require valid token
- [ ] Event CRUD operations work for admin
- [ ] User can register for events
- [ ] User can view their registered events

---

For complete implementation, refer to [Event Management App Repository](https://github.com/your-repo)
