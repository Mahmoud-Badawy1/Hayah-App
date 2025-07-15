part of 'appointments_bloc.dart';

abstract class AppointmentsEvent extends Equatable {
  const AppointmentsEvent();

  @override
  List<Object> get props => [];
}

class LoadAppointments extends AppointmentsEvent {}

class RescheduleAppointment extends AppointmentsEvent {
  final String appointmentId;
  final DateTime newDateTime;

  const RescheduleAppointment({
    required this.appointmentId,
    required this.newDateTime,
  });

  @override
  List<Object> get props => [appointmentId, newDateTime];
}

class JoinVideoCall extends AppointmentsEvent {
  final String appointmentId;

  const JoinVideoCall({required this.appointmentId});

  @override
  List<Object> get props => [appointmentId];
}
