# 🚀 EventFlow - Quick Start Guide

## Project Overview

**EventFlow** is a complete Flutter + Node.js event management application implementing:
- ✅ BLoC Pattern for state management
- ✅ MVC Architecture
- ✅ Separate Admin & User workflows
- ✅ JWT authentication
- ✅ Event CRUD operations
- ✅ Event registration system

---

## 📋 Setup Instructions

### **1. Flutter Frontend Setup**

#### Prerequisites
```bash
# Check your environment
flutter --version
dart --version
```

#### Get Dependencies
```bash
cd event_app
flutter pub get
```

#### Run the App
```bash
# Run on connected device or emulator
flutter run

# Run with specific device
flutter devices
flutter run -d <device_id>
```

#### Build for Production
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

### **2. Node.js Backend Setup**

#### Install Node.js
```bash
# Download from nodejs.org
node --version
npm --version
```

#### Create Backend Project
```bash
mkdir event_management_backend
cd event_management_backend
npm init -y
npm install express cors bcryptjs jsonwebtoken dotenv mysql2
npm install --save-dev nodemon
```

#### Setup Environment
Create `.env` file:
```env
PORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=event_management
JWT_SECRET=your_super_secret_key_12345
JWT_EXPIRE=24h
```

#### Setup Database
```bash
# MySQL
mysql -u root -p
CREATE DATABASE event_management;
SOURCE /path/to/schema.sql;

# Or use the schema from BACKEND_SETUP.md
```

#### Run Backend Server
```bash
# Development with auto-reload
npm run dev

# Production
npm start
```

---

## 🔌 API Configuration

Update the backend URL in [lib/services/api_service.dart](lib/services/api_service.dart):

```dart
static const String baseUrl = 'http://localhost:3000/api'; // Local testing
// static const String baseUrl = 'http://192.168.x.x:3000/api'; // Device testing
// static const String baseUrl = 'https://your-backend.com/api'; // Production
```

---

## 📱 App Flow

### **Welcome Screen**
```
┌─────────────────────────┐
│    EventFlow            │
│                         │
│  [User Login Button]    │
│  [Admin Login Button]   │
└─────────────────────────┘
```

### **User Workflow**
```
[Welcome] → [User Login/Signup] → [Home] → [Events] → [Register] → [My Events]
```

### **Admin Workflow**
```
[Welcome] → [Admin Login] → [Admin Dashboard] → [Add/Edit/Delete Events]
```

---

## 🧪 Testing

### **1. Test with Postman**

Import API endpoints from [BACKEND_SETUP.md](BACKEND_SETUP.md)

#### Test User Signup
```
POST http://localhost:3000/api/auth/user-signup
Body:
{
  "email": "test@example.com",
  "password": "Test123456",
  "fullName": "Test User"
}
```

#### Test User Login
```
POST http://localhost:3000/api/auth/user-login
Body:
{
  "email": "test@example.com",
  "password": "Test123456"
}
```

### **2. Test Flutter App**

1. Start backend server: `npm run dev`
2. Run Flutter app: `flutter run`
3. Create test account on welcome screen
4. Check console for API responses
5. Verify data persists with logout/login

---

## 📁 Project Structure Summary

```
event_app/
├── lib/
│   ├── models/              # Data models
│   ├── blocs/               # BLoC business logic
│   ├── services/            # API & data services
│   ├── views/screens/       # UI screens
│   ├── utils/               # Helpers & constants
│   └── main.dart            # Entry point
├── test/                    # Unit & widget tests
├── pubspec.yaml             # Dependencies
├── BLOC_ARCHITECTURE.md     # Architecture guide
└── BACKEND_SETUP.md         # Backend implementation

backend/
├── routes/                  # API endpoints
├── middleware/              # Auth middleware
├── config/                  # Database config
├── .env                     # Environment variables
└── app.js                   # Express server
```

---

## 🔑 Test Credentials

### **Default Admin Account**
```
Email: admin@example.com
Password: admin123
Type: Admin
```

### **Default User Account**
```
Email: user@example.com
Password: user123
Type: User
```

*Create these in database or through signup endpoint*

---

## 🛠️ Troubleshooting

### Issue: "Connection refused"
```
✅ Solution: Ensure backend is running on port 3000
✅ Check: Have you run `npm run dev` in backend folder?
```

### Issue: "Invalid API URL"
```
✅ Solution: Update baseUrl in lib/services/api_service.dart
✅ Check: Backend URL matches your server address
```

### Issue: "CORS error"
```
✅ Solution: Ensure cors() middleware is in app.js
✅ Check: Backend allows requests from your Flutter app origin
```

### Issue: "Table doesn't exist"
```
✅ Solution: Run the SQL schema from BACKEND_SETUP.md
✅ Check: Database is created and migrations ran
```

### Issue: "Token invalid"
```
✅ Solution: Ensure JWT_SECRET is same in .env and verify()
✅ Check: Token hasn't expired
```

### Issue: "Port 3000 already in use"
```bash
# Find and kill process
lsof -i :3000
kill -9 <PID>

# Or use different port
PORT=3001 npm run dev
```

---

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| [BLOC_ARCHITECTURE.md](BLOC_ARCHITECTURE.md) | Complete Flutter architecture guide |
| [BACKEND_SETUP.md](BACKEND_SETUP.md) | Backend API implementation guide |
| [README.md](README.md) | Project overview |

---

## 🚀 Next Steps for Interview

1. **Complete Backend**: Implement all endpoints from BACKEND_SETUP.md
2. **Add Event Features**: Extend BLoC for event management
3. **Database**: Use Oracle or SQL as specified
4. **Security**: Implement proper JWT validation
5. **UI Polish**: Add animations and better UX
6. **Testing**: Write unit tests for BLoC
7. **Documentation**: Add code comments
8. **Deployment**: Deploy to cloud service

---

## 📦 Submission Checklist

- [ ] Flutter project files
- [ ] Node.js backend files
- [ ] Database schema (SQL/Oracle)
- [ ] .env file example
- [ ] README with setup instructions
- [ ] API documentation
- [ ] Architecture diagrams (if requested)
- [ ] Test credentials
- [ ] Demo video (optional)

---

## 🎓 Learning Resources

- [BLoC Pattern](https://bloclibrary.dev/)
- [Flutter Documentation](https://flutter.dev/docs)
- [Express.js Guide](https://expressjs.com/)
- [JWT Authentication](https://jwt.io/)
- [SQL Fundamentals](https://www.w3schools.com/sql/)

---

## 💡 Tips for Success

1. **Clean Code** - Use clear variable names and comments
2. **Error Handling** - Handle all edge cases gracefully
3. **User Feedback** - Show loading, success, and error states
4. **Testing** - Test with Postman before using Flutter
5. **Documentation** - Document API endpoints and code flow
6. **Security** - Never store sensitive data in code
7. **Performance** - Optimize database queries
8. **Responsive Design** - Test on different screen sizes

---

**Good luck with your interview! 🎉**

For questions, refer to the detailed documentation in:
- `BLOC_ARCHITECTURE.md` - Flutter architecture
- `BACKEND_SETUP.md` - Backend implementation
- Original `README.md` - Project overview
