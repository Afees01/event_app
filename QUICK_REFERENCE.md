# 🎯 Quick Reference Card

## File Structure at a Glance

```
lib/
├── main.dart ......................... App entry point
├── models/ ........................... Data structures
│   ├── user_model.dart
│   ├── auth_response_model.dart
│   └── exports.dart
├── blocs/ ............................ State management
│   ├── auth_bloc.dart
│   ├── auth_event.dart
│   ├── auth_state.dart
│   └── exports.dart
├── services/ ......................... API & business logic
│   ├── api_service.dart
│   ├── auth_service.dart
│   └── exports.dart
├── views/screens/ .................... UI screens
│   ├── welcome_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── home_screen.dart
│   └── exports.dart
└── utils/ ............................ Helpers
    ├── constants.dart
    ├── service_locator.dart
    ├── theme.dart
    └── exports.dart
```

---

## Events & States Reference

### **AuthBloc - Events**
```dart
LoginEvent(email, password, isAdmin)      // User login request
SignupEvent(email, password, fullName)    // User registration
LogoutEvent()                             // User logout
CheckAuthStatusEvent()                    // Check if already logged in
ClearErrorEvent()                         // Clear error messages
```

### **AuthBloc - States**
```dart
AuthInitial()                    // Initial state
AuthLoading()                    // Loading during API call
AuthSuccess(user, token, msg)    // Login/signup successful
AuthFailure(error)               // Login/signup failed
AuthAuthenticated(user, token)   // User already authenticated
AuthUnauthenticated()            // No active session
```

---

## BLoC Usage in Views

### **Trigger Event**
```dart
context.read<AuthBloc>().add(
  LoginEvent(
    email: 'user@example.com',
    password: 'password123',
    isAdmin: false,
  ),
);
```

### **Listen to State Changes**
```dart
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthLoading) {
      return CircularProgressIndicator();
    } else if (state is AuthSuccess) {
      // Show success & navigate
    } else if (state is AuthFailure) {
      // Show error
    }
    return Container();
  },
);
```

### **One-time Actions**
```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  },
  child: // UI widget
);
```

---

## API Endpoints

### **Authentication**
| Endpoint | Method | Body |
|----------|--------|------|
| `/auth/user-signup` | POST | email, password, fullName |
| `/auth/user-login` | POST | email, password |
| `/auth/admin-signup` | POST | email, password, fullName |
| `/auth/admin-login` | POST | email, password |

### **Response Format**
```json
{
  "success": true,
  "message": "Login successful",
  "user": {
    "id": "1",
    "email": "user@example.com",
    "fullName": "John Doe",
    "userType": "user"
  },
  "token": "jwt_token_here"
}
```

---

## Setup Quick Commands

```bash
# Get dependencies
flutter pub get

# Run app
flutter run

# Build APK
flutter build apk --release

# Build for iOS
flutter build ios --release

# Run tests
flutter test

# Check for errors
flutter analyze
```

---

## Common Code Patterns

### **Form Validation**
```dart
TextFormField(
  controller: emailController,
  validator: (value) {
    if (value?.isEmpty ?? true) return 'Email required';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
      return 'Invalid email';
    }
    return null;
  },
)
```

### **Show Loading**
```dart
if (state is AuthLoading) {
  return const SizedBox(
    height: 24,
    width: 24,
    child: CircularProgressIndicator(),
  );
}
```

### **Show Error SnackBar**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(state.error),
    backgroundColor: Colors.red,
  ),
);
```

### **Save Token**
```dart
await authService.saveToken(response.token!);
```

### **Logout**
```dart
context.read<AuthBloc>().add(const LogoutEvent());
Navigator.pushReplacementNamed(context, '/welcome');
```

---

## Color Palette

```dart
Primary:     Color(0xFF6366F1)  // Indigo
Secondary:   Color(0xFF8B5CF6)  // Purple
Accent:      Color(0xFFEC4899)  // Pink
Error:       Color(0xFFEF4444)  // Red
Success:     Color(0xFF10B981)  // Green
```

---

## Global Constants

```dart
const String emailRequired = 'Email is required';
const String passwordRequired = 'Password is required';
const String fullNameRequired = 'Full name is required';
const String emailInvalid = 'Email is invalid';
const String passwordMinLength = 'Password must be at least 6 characters';
const String passwordMismatch = 'Passwords do not match';
```

---

## Database Schema (Quick)

```sql
-- Users
CREATE TABLE users (
  id INT PRIMARY KEY,
  email VARCHAR(255) UNIQUE,
  password VARCHAR(255),
  fullName VARCHAR(255),
  userType ENUM('admin', 'user') DEFAULT 'user'
);

-- Events (Admin)
CREATE TABLE events (
  id INT PRIMARY KEY,
  title VARCHAR(255),
  date DATETIME,
  location VARCHAR(255),
  description TEXT,
  capacity INT,
  adminId INT FOREIGN KEY
);

-- Registrations (User)
CREATE TABLE event_registrations (
  id INT PRIMARY KEY,
  eventId INT FOREIGN KEY,
  userId INT FOREIGN KEY,
  fullName VARCHAR(255),
  email VARCHAR(255),
  phone VARCHAR(20)
);
```

---

## Directory Navigation

```
Project Root (event_app/)
├── lib/
│   ├── Dart code here
│   └── Structure: models → blocs → services → views
├── test/
│   └── Unit and widget tests
├── pubspec.yaml
│   └── Dependencies here
├── BLOC_ARCHITECTURE.md
│   └── Detailed architecture guide
├── BACKEND_SETUP.md
│   └── Backend implementation
├── QUICKSTART.md
│   └── Setup instructions
├── TESTING_GUIDE.md
│   └── Test examples
└── PROJECT_SUMMARY.md
    └── Overview of everything
```

---

## When to Use Each Pattern

| Situation | Use |
|-----------|-----|
| Need to trigger login | `context.read<AuthBloc>().add(LoginEvent(...))` |
| Show UI based on state | `BlocBuilder<AuthBloc, AuthState>` |
| Navigate on state change | `BlocListener<AuthBloc, AuthState>` |
| One-time notification | `ScaffoldMessenger.showSnackBar()` |
| Check current state | `context.read<AuthBloc>().state` |
| Save persistent data | Use `SharedPreferences` in AuthService |
| Make API call | `ApiService.post()` from AuthService |

---

## Debugging Checklist

- [ ] Backend running on port 3000?
- [ ] Database connected and migrated?
- [ ] API URL correct in api_service.dart?
- [ ] All dependencies installed (`flutter pub get`)?
- [ ] BLoC initialized in service_locator?
- [ ] MultiBlocProvider in main.dart?
- [ ] StateEmitted from BLoC?
- [ ] Widget listening to state?
- [ ] Token being saved correctly?
- [ ] API headers include token?
- [ ] Error logs showing what failed?

---

## Before You Submit

✅ Test login with valid credentials
✅ Test signup with new email
✅ Test error cases (wrong password, existing email)
✅ Test logout/login cycle
✅ Verify token persists across sessions
✅ Check for any console errors
✅ Verify phone formatting if needed
✅ Test on both andorid and iOS (if possible)
✅ Test with different screen sizes
✅ Check offline handling

---

## Key Interview Talking Points

1. **BLoC Pattern**: "I separate business logic from UI using BLoC. Events trigger state changes that the UI listens to."

2. **Data Flow**: "Data flows from UI → Event → BLoC → Service → API. Results come back as States."

3. **Error Handling**: "Every operation handles errors. Failed states show helpful messages to users."

4. **Security**: "Tokens are JWT-based, stored securely, and validated on every request."

5. **Scalability**: "Adding new features is easy - create a new BLoC following the same pattern."

6. **Testing**: "I've included unit, widget, and integration tests with mocking."

---

## One-Minute Explanation

*"This is a complete event management app using BLoC architecture. Users can sign up, log in, and view events. Admins can create and manage events. The data flows through Events to the BLoC, which calls Services for API calls, emits States, and the UI updates automatically. Everything is tested and documented."*

---

## Files to Never Edit Without Reason

- ❌ `pubspec.yaml` - Only add dependencies if needed
- ❌ `main.dart` - Already fully configured
- ❌ `service_locator.dart` - DI is set up
- ❌ `auth_bloc.dart` - Core logic, test before changing

---

## Files You'll Need to Modify

- ✏️ `api_service.dart` - Update backend URL
- ✏️ `login_screen.dart` - Add validation or styling
- ✏️ `signup_screen.dart` - Add validation or styling
- ✏️ `home_screen.dart` - Extend with event features
- ✏️ `constants.dart` - Add more app constants

---

## Emergency Fixes

### App crashes on startup
```
→ Check: setupServiceLocator() called in main()
→ Check: All imports are correct
→ Run: flutter pub get
```

### Can't connect to backend
```
→ Check: Backend is running (npm run dev)
→ Check: Port 3000 is accessible
→ Check: baseUrl in api_service.dart
```

### State not updating UI
```
→ Check: Using BlocBuilder, not just context.read()
→ Check: BLoC emitting states
→ Check: State types match in listeners
```

### Form validation not working
```
→ Check: Using TextFormField, not TextField
→ Check: GlobalKey<FormState> assigned
→ Check: validate() called before submit
```

---

## Next Feature Checklist

- [ ] EventBLoC for event management
- [ ] EventListScreen to display events
- [ ] EventDetailScreen for full details
- [ ] EventRegistrationScreen for signup
- [ ] AdminDashboardScreen for admin
- [ ] MyEventsScreen for user's registered events
- [ ] ProfileScreen for user settings
- [ ] NotificationsScreen for alerts

---

**Print this page for quick reference! ✨**

Keep it handy during development and interviews. All details are covered in the comprehensive documentation files.
