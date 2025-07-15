# Authentication Feature

## Overview
The Authentication feature handles user authentication and authorization in the Hayah Health application, providing secure login, registration, and password management functionality.

## Architecture
This feature follows Clean Architecture principles with:
- **Domain**: Authentication business logic and use cases
- **Data**: Repository implementations and data sources
- **Presentation**: UI screens and state management

## Features

### 🔐 User Authentication
- **Login**: Secure user login with email and password
- **Registration**: New user account creation
- **Password Recovery**: Forgot password functionality with email reset
- **Session Management**: Automatic login state persistence
- **Input Validation**: Form validation for all input fields

### 🛡️ Security Features
- **Secure Storage**: Encrypted storage of authentication tokens
- **Password Visibility Toggle**: Show/hide password functionality
- **Form Validation**: Real-time input validation
- **Error Handling**: Comprehensive error messages and handling

## Screens

### LoginScreen
- **Location**: `presentation/pages/login_screen.dart`
- **Purpose**: User authentication entry point
- **Features**:
  - Email and password input fields
  - Password visibility toggle
  - Form validation with error messages
  - Smooth animations and transitions
  - "Remember me" functionality
  - Navigation to signup and forgot password screens

### SignupScreen
- **Location**: `presentation/pages/signup_screen.dart`
- **Purpose**: New user registration
- **Features**:
  - User information collection
  - Password confirmation
  - Terms and conditions acceptance
  - Email verification
  - Input validation
  - Account creation process

### ForgotPasswordScreen
- **Location**: `presentation/pages/forgot_password_screen.dart`
- **Purpose**: Password recovery process
- **Features**:
  - Email input for password reset
  - Reset link sending
  - Success confirmation
  - Navigation back to login

## State Management

### AuthBloc
- **Events**:
  - `LoginRequested`: User attempts to log in
  - `SignupRequested`: User attempts to create account
  - `LogoutRequested`: User logs out
  - `PasswordResetRequested`: User requests password reset
  - `CheckAuthStatus`: Check current authentication state

- **States**:
  - `AuthInitial`: Initial authentication state
  - `AuthLoading`: Authentication process in progress
  - `AuthAuthenticated`: User successfully authenticated
  - `AuthUnauthenticated`: User not authenticated
  - `AuthError`: Authentication error occurred

## Repository

### MockAuthRepository
- **Location**: `data/repositories/mock_auth_repository.dart`
- **Purpose**: Mock implementation for development and testing
- **Features**:
  - Simulated authentication flows
  - Mock user data
  - Configurable delays and responses
  - Error simulation for testing

## Models

### User
Key properties:
- `id`: Unique user identifier
- `email`: User email address
- `name`: User display name
- `profilePicture`: User avatar URL
- `isVerified`: Email verification status
- `createdAt`: Account creation date

### AuthToken
Key properties:
- `accessToken`: JWT access token
- `refreshToken`: Token for refreshing access
- `expiresAt`: Token expiration time

## UI Components

### Custom Form Fields
- Email input with validation
- Password input with visibility toggle
- Styled form buttons
- Error message displays
- Loading indicators

### Animations
- Fade-in animations for screen transitions
- Slide animations for form elements
- Loading spinners and progress indicators
- Success/error state animations

## Validation Rules

### Email Validation
- Valid email format
- Required field validation
- Duplicate email checking during signup

### Password Validation
- Minimum 8 characters
- At least one uppercase letter
- At least one lowercase letter
- At least one number
- Special character requirement

## Dependencies
- `flutter_bloc`: State management
- `shared_preferences`: Local storage for session persistence
- `email_validator`: Email format validation

## Usage Example

```dart
// Login user
context.read<AuthBloc>().add(
  LoginRequested(
    email: 'user@example.com',
    password: 'password123',
  ),
);

// Check authentication status
context.read<AuthBloc>().add(CheckAuthStatus());

// Logout user
context.read<AuthBloc>().add(LogoutRequested());
```

## Navigation Flow
1. **App Launch** → Check auth status
2. **Unauthenticated** → Login Screen
3. **Login Screen** → Signup/Forgot Password
4. **Successful Auth** → Main Navigation
5. **Logout** → Return to Login Screen

## Security Considerations
- Secure token storage
- Session timeout handling
- Network security for API calls
- Input sanitization
- HTTPS enforcement

## Future Enhancements
- [ ] Biometric authentication (fingerprint/face ID)
- [ ] Two-factor authentication (2FA)
- [ ] Social media login (Google, Facebook)
- [ ] Single Sign-On (SSO) integration
- [ ] Advanced password policies
- [ ] Account lockout mechanisms
- [ ] OAuth 2.0 implementation
