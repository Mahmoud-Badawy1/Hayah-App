# Appointments Feature

## Overview
The Appointments feature handles all appointment-related functionality in the Hayah Health application, including booking, viewing, managing appointments, and conducting video calls.

## Architecture
This feature follows Clean Architecture principles with the following layers:
- **Domain**: Contains business logic, entities, and use cases
- **Data**: Handles data sources and repositories
- **Presentation**: UI components, screens, and state management

## Features

### 📅 Appointment Management
- **View Appointments**: Display list of upcoming and past appointments
- **Book Appointments**: Schedule new appointments with doctors
- **Appointment Details**: View detailed information about specific appointments
- **Appointment Status**: Track appointment status (upcoming, completed, cancelled)

### 🎥 Video Calling
- **Video Call Screen**: Conduct video consultations with healthcare providers
- **Real-time Communication**: Audio and video streaming capabilities
- **Call Controls**: Mute, camera toggle, end call functionality

### 📱 User Interface
- **Responsive Design**: Adaptable to different screen sizes
- **Smooth Animations**: Enhanced user experience with Flutter animations
- **State Management**: Uses BLoC pattern for state management

## Screens

### AppointmentsScreen
- **Location**: `presentation/pages/appointments_screen.dart`
- **Purpose**: Main screen displaying list of appointments
- **Features**:
  - Filter appointments by status
  - Search functionality
  - Appointment cards with quick actions
  - Pull-to-refresh capability

### BookAppointmentScreen
- **Location**: `presentation/pages/book_appointment_screen.dart`
- **Purpose**: Allow users to schedule new appointments
- **Features**:
  - Doctor selection
  - Date and time picker
  - Appointment type selection
  - Form validation

### AppointmentDetailsScreen
- **Location**: `presentation/pages/appointment_details_screen.dart`
- **Purpose**: Show detailed information about a specific appointment
- **Features**:
  - Appointment information display
  - Doctor details
  - Action buttons (join call, reschedule, cancel)
  - Medical notes section

### VideoCallScreen
- **Location**: `presentation/pages/video_call_screen.dart`
- **Purpose**: Conduct video consultations
- **Features**:
  - Video streaming
  - Audio controls
  - Chat functionality
  - Screen sharing capabilities
  - Call recording (if enabled)

### VideoCallScreenNew
- **Location**: `presentation/pages/video_call_screen_new.dart`
- **Purpose**: Enhanced video call interface
- **Features**:
  - Improved UI/UX
  - Better performance
  - Additional call features

## State Management

### AppointmentsBloc
- **Events**:
  - `LoadAppointments`: Fetch appointments from repository
  - `BookAppointment`: Create new appointment
  - `UpdateAppointment`: Modify existing appointment
  - `CancelAppointment`: Cancel an appointment

- **States**:
  - `AppointmentsInitial`: Initial state
  - `AppointmentsLoading`: Loading data
  - `AppointmentsLoaded`: Successfully loaded appointments
  - `AppointmentsError`: Error occurred

## Models

### Appointment
Key properties:
- `id`: Unique identifier
- `doctorName`: Name of the attending doctor
- `dateTime`: Appointment date and time
- `status`: Current status (upcoming, completed, cancelled)
- `type`: Type of appointment (consultation, follow-up, etc.)
- `duration`: Appointment duration
- `notes`: Additional notes

## Dependencies
- `flutter_bloc`: State management
- `intl`: Date formatting
- `webrtc_interface`: Video calling functionality

## Usage Example

```dart
// Navigate to appointments screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AppointmentsScreen(),
  ),
);

// Book a new appointment
context.read<AppointmentsBloc>().add(
  BookAppointment(appointment: newAppointment),
);
```

## Future Enhancements
- [ ] Integration with calendar apps
- [ ] Push notifications for appointment reminders
- [ ] Prescription sharing during video calls
- [ ] Multi-language support
- [ ] Offline appointment viewing
- [ ] Insurance verification integration
