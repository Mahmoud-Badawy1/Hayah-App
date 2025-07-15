import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final String id;
  final String doctorName;
  final String doctorSpecialty;
  final DateTime dateTime;
  final AppointmentStatus status;
  final String? notes;

  const Appointment({
    required this.id,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.dateTime,
    required this.status,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    doctorName,
    doctorSpecialty,
    dateTime,
    status,
    notes,
  ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorName': doctorName,
      'doctorSpecialty': doctorSpecialty,
      'dateTime': dateTime.toIso8601String(),
      'status': status.name,
      'notes': notes,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      doctorName: json['doctorName'] as String,
      doctorSpecialty: json['doctorSpecialty'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
      ),
      notes: json['notes'] as String?,
    );
  }

  Appointment copyWith({
    String? id,
    String? doctorName,
    String? doctorSpecialty,
    DateTime? dateTime,
    AppointmentStatus? status,
    String? notes,
  }) {
    return Appointment(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialty: doctorSpecialty ?? this.doctorSpecialty,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}

enum AppointmentStatus { scheduled, confirmed, completed, cancelled, noShow }
