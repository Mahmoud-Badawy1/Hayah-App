import '../models/appointment.dart';

abstract class AppointmentsRepository {
  Future<List<Appointment>> getAppointments();
  Future<Appointment> rescheduleAppointment(String id, DateTime newDateTime);
  Future<String> joinVideoCall(String appointmentId);
  Future<Appointment> bookAppointment(Appointment appointment);
  Future<void> cancelAppointment(String appointmentId);
}
