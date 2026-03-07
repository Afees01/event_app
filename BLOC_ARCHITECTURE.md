# EventFlow - Event Management App
## Flutter + BLoC Architecture with MVC Pattern

This is a complete Flutter application implementing login and signup functionality using the **BLoC (Business Logic Component)** pattern combined with **MVC (Model-View-Controller)** architecture.

---

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point with routing & BLoC setup
├── models/                   # Data models (M in MVC)
│   ├── user_model.dart
│   ├── auth_response_model.dart
│   └── exports.dart
├── blocs/                    # Business Logic (BLoC pattern)
│   ├── auth_bloc.dart       # Main BLoC class
│   ├── auth_event.dart      # Events (user actions)
│   ├── auth_state.dart      # States (UI states)
│   └── exports.dart
├── services/                 # API & Business Logic Layer
│   ├── api_service.dart     # HTTP client with Dio
│   ├── auth_service.dart    # Authentication logic
│   └── exports.dart
├── views/                    # User Interface (V in MVC)
│   └── screens/
│       ├── welcome_screen.dart
│       ├── login_screen.dart
│       ├── signup_screen.dart
│       ├── home_screen.dart
│       └── exports.dart
├── utils/                    # Helper utilities
│   ├── constants.dart        # App constants
│   ├── service_locator.dart # Dependency injection with GetIt
│   ├── theme.dart           # App theming
│   └── exports.dart
└── controllers/             # Business Logic (C in MVC) - Optional
    └── [Can add controllers here for additional business logic]
```

---

## 🏗️ Architecture Explanation

### **MVC + BLoC Pattern**

```
┌─────────────────────────────────────────────────┐
│           PRESENTATION LAYER (Views)             │
│    (Flutter UI - Stateless/Stateful Widgets)    │
└────────────┬────────────────────────────────────┘
             │ BLoC Events
             ▼
┌─────────────────────────────────────────────────┐
│    BUSINESS LOGIC LAYER (BLoC)                   │
│  - Receives Events                              │
│  - Calls Services                               │
│  - Emits States                                 │
└────────────┬────────────────────────────────────┘
             │ API Calls
             ▼
┌─────────────────────────────────────────────────┐
│      DATA & SERVICE LAYER                        │
│  - API Service (HTTP calls)                     │
│  - Auth Service (Business Logic)                │
│  - Local Storage (SharedPreferences)            │
└────────────┬────────────────────────────────────┘
             │
             ▼
      ┌──────────────┐
      │   Backend    │
      │   Database   │
      └──────────────┘
```

---

## 📱 Component Details

### **1. Models (Data Layer)**

**user_model.dart**
- Represents a user object
- Contains user data (id, email, fullName, userType)
- Has `fromJson()` and `toJson()` for serialization
- Extends `Equatable` for value comparison

**auth_response_model.dart**
- API response wrapper
- Contains success flag, message, user, and token
- Used for all auth API responses

### **2. BLoC (Business Logic)**

**auth_bloc.dart**
- Main BLoC class that handles authentication
- Listens to `AuthEvent` and emits `AuthState`
- Coordinates between Services and Views

**auth_event.dart**
- `LoginEvent` - User login request
- `SignupEvent` - User registration request
- `LogoutEvent` - User logout request
- `CheckAuthStatusEvent` - Check if user is already authenticated
- `ClearErrorEvent` - Clear error messages

**auth_state.dart**
- `AuthInitial` - Initial state
- `AuthLoading` - Loading state during API call
- `AuthSuccess` - Successful authentication
- `AuthFailure` - Failed authentication
- `AuthAuthenticated` - User already authenticated
- `AuthUnauthenticated` - User not authenticated

### **3. Services (Business Logic & API)**

**api_service.dart**
- Dio HTTP client configuration
- Base URL and timeout settings
- Post and Get methods with token handling
- Token injection in request headers

**auth_service.dart**
- Login implementation
- Signup implementation
- Token management (save/get/remove)
- User persistence
- Local authentication checks

### **4. Views (UI Layer)**

**welcome_screen.dart**
- First screen users see
- Options for User or Admin login

**login_screen.dart**
- Email and password input fields
- Form validation
- BLoC integration for login
- Error handling with SnackBars
- Loading states with spinner

**signup_screen.dart**
- Full name, email, password input fields
- Password confirmation
- Form validation
- BLoC integration for signup
- Responsive error handling

**home_screen.dart**
- Post-login home page
- Displays user information
- Logout functionality

---

## 🔄 Data Flow Example: Login

```
1. User enters email & password
2. User taps "Login" button
3. View triggers: context.read<AuthBloc>().add(LoginEvent(...))
4. BLoC receives LoginEvent in _onLoginEvent handler
5. BLoC calls: authService.login(email, password, isAdmin)
6. AuthService calls: apiService.post('/auth/user-login', data)
7. Backend API responds with success and token
8. AuthService saves token locally
9. BLoC emits: AuthSuccess(user, token, message)
10. View listens to AuthSuccess state
11. SnackBar shows success message
12. Navigation to HomeScreen
```

---

## 🛠️ Setup & Dependencies

### **Required Packages**

```yaml
flutter_bloc: ^8.1.6    # BLoC framework
bloc: ^8.1.2            # Core BLoC library
dio: ^5.3.1             # HTTP client
shared_preferences: ^2.2.2  # Local storage
equatable: ^2.0.5       # Value equality
get_it: ^7.6.0          # Dependency injection
validators: ^3.0.0      # Input validation
```

### **Installation**

```bash
flutter pub get
```

---

## 🚀 How to Use

### **1. Check Authentication on App Start**

```dart
BlocProvider<AuthBloc>(
  create: (context) => getIt<AuthBloc>()
    ..add(const CheckAuthStatusEvent()),
)
```

### **2. Listen to Auth State Changes**

```dart
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthSuccess) {
      // Navigate to home
    } else if (state is AuthFailure) {
      // Show error
    }
  },
)
```

### **3. Trigger Login/Signup**

```dart
context.read<AuthBloc>().add(
  LoginEvent(
    email: 'user@example.com',
    password: 'password123',
    isAdmin: false,
  ),
);
```

---

## 🔐 Key Features

✅ **Separation of Concerns** - Clear separation between UI, BLoC, and Services
✅ **Reactive State Management** - BLoC automatically updates UI on state changes
✅ **Error Handling** - Comprehensive error handling with user feedback
✅ **Form Validation** - Client-side validation before API calls
✅ **Token Management** - Secure token storage and retrieval
✅ **Dependency Injection** - GetIt for clean dependency management
✅ **Responsive Design** - Mobile-first UI with proper spacing
✅ **Admin & User Separation** - Different login endpoints for admin/user

---

## 📋 API Integration

### **Login Endpoint**
```
POST /api/auth/user-login
{
  "email": "user@example.com",
  "password": "password123"
}

Response:
{
  "success": true,
  "message": "Login successful",
  "user": {
    "id": "123",
    "email": "user@example.com",
    "fullName": "John Doe",
    "userType": "user"
  },
  "token": "jwt_token_here"
}
```

### **Signup Endpoint**
```
POST /api/auth/user-signup
{
  "email": "user@example.com",
  "password": "password123",
  "fullName": "John Doe"
}

Response: Same as login
```

### **Admin Endpoints**
```
POST /api/auth/admin-login
POST /api/auth/admin-signup
```

---

## 🔧 Customization

### **1. Update Backend URL**
Edit in [services/api_service.dart](lib/services/api_service.dart):
```dart
static const String baseUrl = 'http://your-backend-url/api';
```

### **2. Add Custom Validators**
Edit in [utils/constants.dart](lib/utils/constants.dart)

### **3. Modify UI Theme**
Edit in [utils/theme.dart](lib/utils/theme.dart)

### **4. Add More Events/States**
Extend `AuthEvent` and `AuthState` in respective files

---

## 📚 Best Practices Implemented

1. **Single Responsibility** - Each class has one job
2. **Dependency Injection** - Services injected through constructors
3. **Immutability** - Models and States are immutable
4. **Error Handling** - Proper try-catch and state management
5. **Code Organization** - Logical folder structure
6. **Reusability** - Export files for clean imports
7. **Validation** - Form validation before submission
8. **User Feedback** - Loading, success, and error states

---

## 🚨 Common Issues & Solutions

### **Issue: BLoC not found**
**Solution:** Ensure `setupServiceLocator()` is called in `main()`

### **Issue: Token not persisting**
**Solution:** Check SharedPreferences permissions in AndroidManifest.xml

### **Issue: CORS errors**
**Solution:** Configure CORS on backend Node.js/Express server

### **Issue: State not updating in UI**
**Solution:** Ensure using `BlocBuilder` or `BlocListener` correctly

---

## 📖 Next Steps

1. **Backend Integration** - Connect to your Node.js Express server
2. **Events Management** - Add BLoC for event CRUD operations
3. **Registration System** - Implement event registration logic
4. **User Profile** - Add user profile screens and editing
5. **Admin Dashboard** - Create admin event management interface
6. **Push Notifications** - Integrate Firebase push notifications
7. **Offline Support** - Add Hive for offline event caching

---

## 📞 Support

For questions or issues, refer to:
- [BLoC Documentation](https://bloclibrary.dev/)
- [Flutter Documentation](https://flutter.dev/docs)
- [Dio HTTP Client](https://pub.dev/packages/dio)

---

**Created for Event Management App Interview Task**
