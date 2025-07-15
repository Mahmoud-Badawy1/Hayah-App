import 'package:flutter/material.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const AppointmentDetailsScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
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
                          radius: 30,
                          backgroundColor: theme.primaryColor.withAlpha(25),
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment['doctorName'] ?? '',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                appointment['specialty'] ?? '',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    _DetailItem(
                      icon: Icons.calendar_today,
                      title: 'Date',
                      value: appointment['date'] ?? '',
                      theme: theme,
                    ),
                    const SizedBox(height: 16),
                    _DetailItem(
                      icon: Icons.access_time,
                      title: 'Time',
                      value: appointment['time'] ?? '',
                      theme: theme,
                    ),
                    const SizedBox(height: 16),
                    _DetailItem(
                      icon: Icons.location_on,
                      title: 'Location',
                      value: appointment['location'] ?? 'Video Consultation',
                      theme: theme,
                    ),
                    if (appointment['notes'] != null) ...[
                      const SizedBox(height: 16),
                      _DetailItem(
                        icon: Icons.notes,
                        title: 'Notes',
                        value: appointment['notes'],
                        theme: theme,
                      ),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    _buildJoinCallDialog(context, theme),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Joining video call...'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.video_call),
                            label: const Text('Join Call'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Reschedule Appointment'),
                                  content: const Text(
                                    'Are you sure you want to reschedule this appointment?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                          context,
                                          '/book-appointment',
                                        );
                                      },
                                      child: const Text('Reschedule'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit_calendar),
                            label: const Text('Reschedule'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Cancel Appointment'),
                              content: const Text(
                                'Are you sure you want to cancel this appointment?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('No'),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Appointment cancelled successfully',
                                        ),
                                      ),
                                    );
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: theme.colorScheme.error,
                                  ),
                                  child: const Text('Yes, Cancel'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text('Cancel Appointment'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          foregroundColor: theme.colorScheme.error,
                          side: BorderSide(color: theme.colorScheme.error),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinCallDialog(BuildContext context, ThemeData theme) {
    final doctorName = appointment['doctorName'] as String;
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.video_camera_front, color: theme.primaryColor),
          const SizedBox(width: 8),
          const Text('Join Video Call'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ready to join your appointment with'),
          const SizedBox(height: 8),
          Text(
            doctorName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                'Duration: 30 minutes',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: theme.primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Make sure your camera and microphone are working properly.',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.video_camera_front, size: 18),
          label: const Text('Join Now'),
          onPressed: () {
            Navigator.pop(context);
            // Launch video call
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => _buildVideoCallScreen(context, theme),
            );
          },
        ),
      ],
    );
  }

  Widget _buildVideoCallScreen(BuildContext context, ThemeData theme) {
    final doctorName = appointment['doctorName'] as String;
    return PopScope(
      canPop: false,
      child: Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            leading: const SizedBox(),
            title: Text('Call with $doctorName'),
            actions: [
              IconButton(
                icon: const Icon(Icons.call_end, color: Colors.red),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          body: Stack(
            children: [
              Container(
                color: Colors.black87,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: theme.primaryColor.withAlpha(25),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        doctorName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Connecting...',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      heroTag: 'mic',
                      onPressed: () {},
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.mic, color: Colors.black),
                    ),
                    const SizedBox(width: 16),
                    FloatingActionButton(
                      heroTag: 'camera',
                      onPressed: () {},
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.videocam, color: Colors.black),
                    ),
                    const SizedBox(width: 16),
                    FloatingActionButton(
                      heroTag: 'end',
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.call_end),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final ThemeData theme;

  const _DetailItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.primaryColor),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            Text(value, style: theme.textTheme.titleMedium),
          ],
        ),
      ],
    );
  }
}
