import '../../domain/models/appointment.dart';
import '../../domain/repositories/appointments_repository.dart';

class MockAppointmentsRepository implements AppointmentsRepository {
  final List<Appointment> _appointments = [
    Appointment(
      id: '1',
      doctorName: 'Dr. John Smith',
      doctorSpecialty: 'Cardiologist',
      dateTime: DateTime.now().add(const Duration(minutes: 15)),
      status: AppointmentStatus.confirmed,
    ),
    Appointment(
      id: '2',
      doctorName: 'Dr. Sarah Johnson',
      doctorSpecialty: 'Dermatologist',
      dateTime: DateTime.now().add(const Duration(days: 2)),
      status: AppointmentStatus.scheduled,
    ),
    Appointment(
      id: '3',
      doctorName: 'Dr. Michael Brown',
      doctorSpecialty: 'Pediatrician',
      dateTime: DateTime.now().add(const Duration(days: -1)),
      status: AppointmentStatus.completed,
      notes: 'Regular checkup completed. Follow-up in 3 months.',
    ),
  ];

  @override
  Future<List<Appointment>> getAppointments() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return _appointments;
  }

  @override
  Future<Appointment> rescheduleAppointment(
    String id,
    DateTime newDateTime,
  ) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    final index = _appointments.indexWhere((a) => a.id == id);
    if (index == -1) {
      throw Exception('Appointment not found');
    }

    final updatedAppointment = _appointments[index].copyWith(
      dateTime: newDateTime,
      status: AppointmentStatus.scheduled,
    );

    _appointments[index] = updatedAppointment;
    return updatedAppointment;
  }

  @override
  Future<String> joinVideoCall(String appointmentId) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    final appointment = _appointments.firstWhere(
      (a) => a.id == appointmentId,
      orElse: () => throw Exception('Appointment not found'),
    );

    if (appointment.dateTime.difference(DateTime.now()).inMinutes > 30) {
      throw Exception('Video call is not available yet');
    }

    // In a real app, this would return a video call URL or token
    return 'https://video-call-service.com/room/${appointment.id}';
  }

  @override
  Future<Appointment> bookAppointment(Appointment appointment) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    final newAppointment = appointment.copyWith(
      id: (int.parse(_appointments.last.id) + 1).toString(),
      status: AppointmentStatus.scheduled,
    );

    _appointments.add(newAppointment);
    return newAppointment;
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index == -1) {
      throw Exception('Appointment not found');
    }

    _appointments[index] = _appointments[index].copyWith(
      status: AppointmentStatus.cancelled,
    );
  }
}
