# Home Feature

## Overview
The Home feature serves as the main navigation hub and dashboard for the Hayah Health application, providing users with an overview of their health information and quick access to all app features.

## Architecture
This feature follows Clean Architecture principles:
- **Presentation**: UI screens and navigation components
- **Domain**: Business logic for dashboard data
- **Data**: Health metrics and user data sources

## Features

### 🏠 Main Dashboard
- **Health Overview**: Quick view of key health metrics
- **Quick Actions**: Fast access to common features
- **Recent Activity**: Latest appointments, records, and notifications
- **Health Insights**: Personalized health recommendations
- **Emergency Access**: Quick emergency contact and services

### 🧭 Navigation Hub
- **Bottom Navigation**: Primary app navigation
- **Feature Cards**: Visual access to main app features
- **Search Functionality**: Quick search across all features
- **Profile Access**: User profile and settings

## Screens

### DashboardScreen
- **Location**: `presentation/pages/dashboard_screen.dart`
- **Purpose**: Main application dashboard with health overview
- **Features**:
  - Welcome message with user personalization
  - Health metrics cards (heart rate, steps, weight, etc.)
  - Quick action buttons for common tasks
  - Recent appointments display
  - Health tips and recommendations
  - Emergency services access
  - Responsive layout for different screen sizes
  - Smooth animations and transitions

### MainNavigationScreen
- **Location**: `presentation/pages/main_navigation_screen.dart`
- **Purpose**: Main navigation wrapper with bottom navigation
- **Features**:
  - Bottom navigation bar with 5 main sections
  - Screen state management
  - Navigation animations
  - Badge notifications for unread items
  - Persistent navigation state

## Dashboard Components

### Health Metrics Cards
- **Heart Rate**: Current and average heart rate
- **Steps**: Daily step count and goals
- **Weight**: Current weight and trends
- **Sleep**: Sleep quality and duration
- **Blood Pressure**: Recent readings and trends

### Quick Action Cards
- **Book Appointment**: Direct access to appointment booking
- **Emergency**: Emergency services and contacts
- **Medical Records**: View recent medical records
- **Prescriptions**: Active prescriptions and refills
- **Health Tips**: Personalized health recommendations

### Recent Activity Section
- **Upcoming Appointments**: Next scheduled appointments
- **Recent Lab Results**: Latest test results
- **Medication Reminders**: Upcoming medication schedules
- **Health Alerts**: Important health notifications

## UI/UX Features

### Responsive Design
- **Mobile-first**: Optimized for mobile devices
- **Tablet Support**: Adaptive layout for larger screens
- **Dynamic Layout**: Adjusts based on screen size using LayoutBuilder
- **Accessibility**: Screen reader support and high contrast options

### Animations
- **Fade Animations**: Smooth screen transitions
- **Card Animations**: Staggered card appearances
- **Slide Transitions**: Navigation animations
- **Loading States**: Skeleton screens and progress indicators

### Visual Design
- **Material Design 3**: Modern Google design principles
- **Custom Color Scheme**: Health-focused color palette
- **Typography**: Clear, readable font hierarchy
- **Icons**: Consistent iconography throughout

## Navigation Structure

### Bottom Navigation Tabs
1. **Home** (Dashboard)
2. **Appointments** 
3. **Records**
4. **Profile**
5. **More** (Additional features)

### Navigation State Management
- Persistent tab selection
- Deep linking support
- Back button handling
- Navigation history tracking

## Data Integration

### Health Data Sources
- **Fitness Trackers**: Integration with wearable devices
- **Manual Input**: User-entered health metrics
- **Medical Devices**: Connected health monitoring devices
- **Healthcare Providers**: Synced medical records

### Real-time Updates
- **Live Data**: Real-time health metric updates
- **Push Notifications**: Important health alerts
- **Background Sync**: Automatic data synchronization
- **Offline Support**: Local data caching

## Customization

### Personalization
- **Dashboard Layout**: Customizable card arrangements
- **Health Goals**: Personal health target setting
- **Notification Preferences**: Customizable alert settings
- **Theme Options**: Light/dark mode support

### User Preferences
- **Quick Actions**: Customizable shortcut buttons
- **Widget Selection**: Choose displayed health metrics
- **Layout Options**: Grid vs. list view preferences
- **Language Settings**: Multi-language support

## Dependencies
- `flutter/material.dart`: Material Design components
- `core/animations/app_animations.dart`: Custom animations
- Health data providers and APIs

## Usage Example

```dart
// Navigate to dashboard
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => const MainNavigationScreen(),
  ),
  (route) => false,
);

// Access specific tab
Navigator.pushNamed(context, '/appointments');
```

## Performance Optimizations
- **Lazy Loading**: Load cards as needed
- **Image Caching**: Efficient image loading
- **State Persistence**: Maintain scroll positions
- **Memory Management**: Efficient widget disposal

## Accessibility Features
- **Screen Reader Support**: Comprehensive accessibility labels
- **High Contrast**: Support for users with visual impairments
- **Font Scaling**: Respect system font size settings
- **Voice Navigation**: Voice command support

## Future Enhancements
- [ ] Widget customization drag-and-drop
- [ ] Advanced health analytics dashboard
- [ ] Integration with more health devices
- [ ] AI-powered health insights
- [ ] Social features for family health sharing
- [ ] Gamification elements for health goals
- [ ] Advanced data visualization charts
- [ ] Voice assistant integration
