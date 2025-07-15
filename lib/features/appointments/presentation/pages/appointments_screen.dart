import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/animations/app_animations.dart';
import '../../domain/models/appointment.dart';
import '../bloc/appointments_bloc.dart';
import './video_call_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.defaultDuration,
    );
    _controller.forward();

    // Load appointments when screen initializes
    context.read<AppointmentsBloc>().add(LoadAppointments());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleReschedule(
    BuildContext context,
    String appointmentId,
    DateTime currentDateTime,
  ) async {
    if (!context.mounted) return;

    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: currentDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (newDate == null || !context.mounted) return;

    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentDateTime),
    );

    if (newTime == null || !context.mounted) return;

    final newDateTime = DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      newTime.hour,
      newTime.minute,
    );

    context.read<AppointmentsBloc>().add(
      RescheduleAppointment(
        appointmentId: appointmentId,
        newDateTime: newDateTime,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/book-appointment');
            },
          ),
        ],
      ),
      body: BlocBuilder<AppointmentsBloc, AppointmentsState>(
        builder: (context, state) {
          if (state is AppointmentsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AppointmentsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      context.read<AppointmentsBloc>().add(LoadAppointments());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is AppointmentsLoaded) {
            if (state.appointments.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 64,
                      color: theme.primaryColor.withAlpha(125),
                    ),
                    const SizedBox(height: 16),
                    Text('No Appointments', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'Book your first appointment',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/book-appointment');
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Book Appointment'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.appointments.length,
              itemBuilder: (BuildContext context, int index) {
                final appointment = state.appointments[index];
                final animation = CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    (index * 0.1).clamp(0.0, 1.0),
                    ((index + 1) * 0.1).clamp(0.0, 1.0),
                    curve: AppAnimations.smoothCurve,
                  ),
                );

                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.5, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: theme.primaryColor.withAlpha(
                                    25,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appointment.doctorName,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Text(
                                        appointment.doctorSpecialty,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      appointment.status,
                                    ).withAlpha(25),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _getStatusText(appointment.status),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: _getStatusColor(
                                        appointment.status,
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                _buildAppointmentDetail(
                                  theme,
                                  icon: Icons.calendar_today,
                                  label: 'Date',
                                  value: DateFormat(
                                    'MMM d, yyyy',
                                  ).format(appointment.dateTime),
                                ),
                                const SizedBox(width: 24),
                                _buildAppointmentDetail(
                                  theme,
                                  icon: Icons.access_time,
                                  label: 'Time',
                                  value: DateFormat(
                                    'h:mm a',
                                  ).format(appointment.dateTime),
                                ),
                              ],
                            ),
                            if (appointment.status !=
                                    AppointmentStatus.cancelled &&
                                appointment.status !=
                                    AppointmentStatus.completed) ...[
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => _handleReschedule(
                                        context,
                                        appointment.id,
                                        appointment.dateTime,
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: const Text('Reschedule'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: FilledButton(
                                      onPressed:
                                          appointment.dateTime
                                                  .difference(DateTime.now())
                                                  .inMinutes <=
                                              30
                                          ? () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    _buildJoinCallDialog(
                                                      context,
                                                      theme,
                                                      appointment,
                                                    ),
                                              );
                                            }
                                          : null,
                                      style: FilledButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: const Text('Join Call'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return Colors.orange;
      case AppointmentStatus.confirmed:
        return Colors.green;
      case AppointmentStatus.completed:
        return Colors.blue;
      case AppointmentStatus.cancelled:
        return Colors.red;
      case AppointmentStatus.noShow:
        return Colors.grey;
    }
  }

  String _getStatusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'Scheduled';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.noShow:
        return 'No Show';
    }
  }

  Widget _buildAppointmentDetail(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryColor.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: theme.primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJoinCallDialog(
    BuildContext context,
    ThemeData theme,
    Appointment appointment,
  ) {
    return AlertDialog(
      title: const Text('Join Video Call'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You are about to join a video call with:',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.primaryColor.withAlpha(25),
                child: Icon(Icons.person, color: theme.primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctorName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      appointment.doctorSpecialty,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Please ensure:', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          _buildChecklistItem('Your camera and microphone are working'),
          _buildChecklistItem('You have a stable internet connection'),
          _buildChecklistItem('You are in a quiet environment'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.pop(context);
            // Join video call with unique call ID based on appointment
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoCallScreen(
                  callId: 'call_${appointment.id}',
                  appointment: appointment,
                ),
              ),
            );
            // Notify the bloc that we're joining the call
            context.read<AppointmentsBloc>().add(
              JoinVideoCall(appointmentId: appointment.id),
            );
          },
          icon: const Icon(Icons.video_call),
          label: const Text('Join Now'),
        ),
      ],
    );
  }

  Widget _buildChecklistItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 20, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
