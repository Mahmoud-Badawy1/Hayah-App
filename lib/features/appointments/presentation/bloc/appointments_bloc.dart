import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import '../../domain/models/appointment.dart';
import '../../domain/repositories/appointments_repository.dart';
import '../../data/repositories/mock_appointments_repository.dart';

part 'appointments_event.dart';
part 'appointments_state.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final AppointmentsRepository _repository;

  AppointmentsBloc({AppointmentsRepository? repository})
    : _repository = repository ?? MockAppointmentsRepository(),
      super(AppointmentsInitial()) {
    on<LoadAppointments>(_onLoadAppointments);
    on<RescheduleAppointment>(_onRescheduleAppointment);
    on<JoinVideoCall>(_onJoinVideoCall);
  }

  Future<void> _onLoadAppointments(
    LoadAppointments event,
    Emitter<AppointmentsState> emit,
  ) async {
    try {
      emit(AppointmentsLoading());
      final appointments = await _repository.getAppointments();
      emit(AppointmentsLoaded(appointments));
    } catch (e) {
      emit(AppointmentsError('Failed to load appointments. Please try again.'));
    }
  }

  Future<void> _onRescheduleAppointment(
    RescheduleAppointment event,
    Emitter<AppointmentsState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is AppointmentsLoaded) {
        emit(AppointmentsLoading());

        final updatedAppointment = await _repository.rescheduleAppointment(
          event.appointmentId,
          event.newDateTime,
        );

        final updatedAppointments = currentState.appointments.map((
          appointment,
        ) {
          if (appointment.id == event.appointmentId) {
            return updatedAppointment;
          }
          return appointment;
        }).toList();

        emit(AppointmentsLoaded(updatedAppointments));
      }
    } catch (e) {
      emit(
        AppointmentsError(
          'Failed to reschedule appointment. Please try again.',
        ),
      );
    }
  }

  Future<void> _onJoinVideoCall(
    JoinVideoCall event,
    Emitter<AppointmentsState> emit,
  ) async {
    try {
      // Call repository to get video call URL/token
      final videoCallUrl = await _repository.joinVideoCall(event.appointmentId);

      // TODO: Implement video call launching
      if (kDebugMode) {
        print('Launching video call with URL: $videoCallUrl');
      }

      // Update the appointment status in the UI
      final currentState = state;
      if (currentState is AppointmentsLoaded) {
        final updatedAppointments = currentState.appointments.map((
          appointment,
        ) {
          if (appointment.id == event.appointmentId) {
            return appointment.copyWith(status: AppointmentStatus.confirmed);
          }
          return appointment;
        }).toList();

        emit(AppointmentsLoaded(updatedAppointments));
      }
    } catch (e) {
      emit(AppointmentsError('Failed to join video call. Please try again.'));
    }
  }
}
