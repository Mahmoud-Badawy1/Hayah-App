import 'package:flutter/material.dart';
import '../../../../core/animations/app_animations.dart';
import '../../../../core/navigation/app_router.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.longDuration,
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: AppAnimations.smoothCurve,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildNotificationsSheet(context, theme),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  // For wider screens, show cards side by side
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Expanded(
                      //   flex: 2,
                      //   child: SlideTransition(
                      //     position: Tween<Offset>(
                      //       begin: const Offset(-0.2, 0),
                      //       end: Offset.zero,
                      //     ).animate(_fadeInAnimation),
                      //     child: FadeTransition(
                      //       opacity: _fadeInAnimation,
                      //       // child: _buildWelcomeCard(theme),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(width: 16),
                      Expanded(
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.2, 0),
                            end: Offset.zero,
                          ).animate(_fadeInAnimation),
                          child: FadeTransition(
                            opacity: _fadeInAnimation,
                            child: _buildEmergencyCard(theme),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // For mobile screens, stack cards vertically
                  return Column(
                    children: [
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, -0.2),
                          end: Offset.zero,
                        ).animate(_fadeInAnimation),
                        child: FadeTransition(
                          opacity: _fadeInAnimation,
                          // child: _buildWelcomeCard(theme),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(_fadeInAnimation),
                        child: FadeTransition(
                          opacity: _fadeInAnimation,
                          child: _buildEmergencyCard(theme),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(-0.2, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Interval(
                        0.2,
                        0.7,
                        curve: AppAnimations.smoothCurve,
                      ),
                    ),
                  ),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _controller,
                  curve: const Interval(0.2, 0.7),
                ),
                child: _buildUpcomingAppointments(theme, context),
              ),
            ),
            const SizedBox(height: 24),
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.2, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Interval(
                        0.4,
                        0.9,
                        curve: AppAnimations.smoothCurve,
                      ),
                    ),
                  ),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _controller,
                  curve: const Interval(0.4, 0.9),
                ),
                child: _buildQuickActions(theme, context),
              ),
            ),
            const SizedBox(height: 24),
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Interval(
                        0.6,
                        1.0,
                        curve: AppAnimations.smoothCurve,
                      ),
                    ),
                  ),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _controller,
                  curve: const Interval(0.6, 1.0),
                ),
                child: _buildHealthSummary(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildWelcomeCard(ThemeData theme) {
  //   return Card(
  //     elevation: 2,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text('Welcome back,', style: theme.textTheme.titleLarge),
  //           Text(
  //             'John Doe',
  //             style: theme.textTheme.headlineSmall?.copyWith(
  //               fontWeight: FontWeight.bold,
  //               color: theme.primaryColor,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildEmergencyCard(ThemeData theme) {
    return Card(
      color: theme.colorScheme.error.withAlpha(25),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/emergency'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.emergency, color: theme.colorScheme.error, size: 32),
              const SizedBox(height: 16),
              Text(
                'Emergency',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Get immediate medical assistance',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/emergency'),
                icon: const Icon(Icons.phone),
                label: const Text('Call Now'),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointments(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Appointments',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.primaryColor.withAlpha(25),
              child: Icon(Icons.calendar_today, color: theme.primaryColor),
            ),
            title: Text(
              'Dr. Sarah Wilson',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Tomorrow at 10:00 AM',
              style: theme.textTheme.bodyMedium,
            ),
            trailing: Icon(Icons.chevron_right, color: theme.primaryColor),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.appointmentDetails,
                arguments: {
                  'appointment': {
                    'doctorName': 'Dr. Sarah Wilson',
                    'specialty': 'Cardiologist',
                    'date': 'Tomorrow',
                    'time': '10:00 AM',
                    'location': 'Video Consultation',
                  },
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(ThemeData theme, [BuildContext? context]) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(0.4, 1.0, curve: AppAnimations.smoothCurve),
            ),
          ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Actions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickActionButton(
                    theme,
                    icon: Icons.calendar_today,
                    label: 'Book\nAppointment',
                    onTap: () => Navigator.pushNamed(context!, '/appointments'),
                  ),
                  _buildQuickActionButton(
                    theme,
                    icon: Icons.medication,
                    label: 'View\nPrescriptions',
                    onTap: () =>
                        Navigator.pushNamed(context!, '/prescriptions'),
                  ),
                  _buildQuickActionButton(
                    theme,
                    icon: Icons.description,
                    label: 'Medical\nRecords',
                    onTap: () =>
                        Navigator.pushNamed(context!, '/medical-records'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(icon, color: theme.primaryColor),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(height: 1.2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthSummary(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Health Summary',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildHealthMetric(
                  theme,
                  icon: Icons.favorite,
                  title: 'Heart Rate',
                  value: '72 BPM',
                ),
                const Divider(height: 24),
                _buildHealthMetric(
                  theme,
                  icon: Icons.bloodtype,
                  title: 'Blood Pressure',
                  value: '120/80',
                ),
                const Divider(height: 24),
                _buildHealthMetric(
                  theme,
                  icon: Icons.timeline,
                  title: 'Blood Sugar',
                  value: '100 mg/dL',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthMetric(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: theme.primaryColor, size: 24),
        const SizedBox(width: 16),
        Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsSheet(BuildContext context, ThemeData theme) {
    final notifications = [
      {
        'title': 'Upcoming Appointment',
        'message':
            'You have an appointment with Dr. Sarah Wilson tomorrow at 10:00 AM',
        'time': '1h ago',
        'isRead': false,
      },
      {
        'title': 'Test Results Available',
        'message': 'Your recent blood test results are now available',
        'time': '2h ago',
        'isRead': false,
      },
      {
        'title': 'Prescription Reminder',
        'message': 'Don\'t forget to take your evening medication',
        'time': '5h ago',
        'isRead': true,
      },
      {
        'title': 'Health Tip',
        'message':
            'Remember to stay hydrated and drink plenty of water throughout the day',
        'time': '1d ago',
        'isRead': true,
      },
    ];

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Mark all as read
                  },
                  child: const Text('Mark all as read'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: notification['isRead'] as bool
                        ? theme.primaryColor.withAlpha(25)
                        : theme.primaryColor,
                    child: Icon(
                      Icons.notifications,
                      color: notification['isRead'] as bool
                          ? theme.primaryColor
                          : Colors.white,
                    ),
                  ),
                  title: Text(
                    notification['title'] as String,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: notification['isRead'] as bool
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        notification['message'] as String,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['time'] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Handle notification tap
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
