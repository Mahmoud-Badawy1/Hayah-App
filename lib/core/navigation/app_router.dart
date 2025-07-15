import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/auth/presentation/pages/forgot_password_screen.dart';
import '../../features/home/presentation/pages/main_navigation_screen.dart';
import '../../features/prescriptions/presentation/pages/prescriptions_screen.dart';
import '../../features/emergency/presentation/pages/emergency_screen.dart';
import '../../features/billing/presentation/pages/billing_screen.dart';
import '../../features/appointments/presentation/pages/video_call_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/profile/presentation/pages/edit_profile_screen.dart';
import '../../features/appointments/presentation/pages/appointments_screen.dart';
import '../../features/appointments/presentation/pages/book_appointment_screen.dart';
import '../../features/medical_records/presentation/pages/medical_records_screen.dart';
import '../../features/appointments/presentation/pages/appointment_details_screen.dart';
import '../../features/medical_records/presentation/pages/medical_record_details_screen.dart';

abstract class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String appointments = '/appointments';
  static const String bookAppointment = '/book-appointment';
  static const String medicalRecords = '/medical-records';
  static const String medicalRecordDetails = '/medical-record-details';
  static const String prescriptions = '/prescriptions';
  static const String videocall = '/videocall';
  static const String emergency = '/emergency';
  static const String billing = '/billing';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String appointmentDetails = '/appointment-details';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.initial:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case AppRoutes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case AppRoutes.appointments:
        return MaterialPageRoute(builder: (_) => const AppointmentsScreen());
      case AppRoutes.appointmentDetails:
        final Map<String, dynamic> args =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) =>
              AppointmentDetailsScreen(appointment: args['appointment']),
        );
      case AppRoutes.bookAppointment:
        return MaterialPageRoute(builder: (_) => const BookAppointmentScreen());
      case AppRoutes.medicalRecords:
        return MaterialPageRoute(builder: (_) => const MedicalRecordsScreen());
      case AppRoutes.medicalRecordDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || args['record'] == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(child: Text('Medical record not found')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => MedicalRecordDetailsScreen(record: args['record']),
        );
      case AppRoutes.prescriptions:
        return MaterialPageRoute(builder: (_) => const PrescriptionsScreen());
      case AppRoutes.emergency:
        return MaterialPageRoute(builder: (_) => const EmergencyScreen());
      case AppRoutes.billing:
        return MaterialPageRoute(builder: (_) => const BillingScreen());
      case AppRoutes.videocall:
        final Map<String, dynamic> args =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => VideoCallScreen(
            callId: args['callId'] as String,
            appointment: args['appointment'],
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
