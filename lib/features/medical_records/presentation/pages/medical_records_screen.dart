import 'package:flutter/material.dart';
import '../../../../core/animations/app_animations.dart';
import '../../../../core/navigation/app_router.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.longDuration,
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

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Medical Records'),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Reports'),
              Tab(text: 'Prescriptions'),
              Tab(text: 'Tests'),
            ],
            indicatorColor: theme.primaryColor,
            labelColor: theme.primaryColorLight,
            unselectedLabelColor: Colors.grey,
            onTap: (index) {
              _controller.reset();
              _controller.forward();
            },
          ),
        ),
        body: TabBarView(
          children: [
            _buildReportsTab(theme),
            _buildPrescriptionsTab(theme),
            _buildTestsTab(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedList(
    ThemeData theme,
    BuildContext context,
    Widget Function(BuildContext, int) itemBuilder,
    int itemCount,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final animation = CurvedAnimation(
          parent: _controller,
          curve: Interval(
            (index * 0.1).clamp(0, 1),
            ((index + 1) * 0.1).clamp(0, 1),
            curve: AppAnimations.smoothCurve,
          ),
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.3, 0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: itemBuilder(context, index),
          ),
        );
      },
    );
  }

  Widget _buildReportsTab(ThemeData theme) {
    return Builder(
      builder: (context) => _buildAnimatedList(
        theme,
        context,
        (context, index) => _buildRecordCard(
          theme,
          context,
          title: 'Annual Health Checkup Report',
          date: 'May 10, 2024',
          doctor: 'Dr. Michael Brown',
          type: 'Report',
          icon: Icons.description,
        ),
        5,
      ),
    );
  }

  Widget _buildPrescriptionsTab(ThemeData theme) {
    return Builder(
      builder: (context) => _buildAnimatedList(
        theme,
        context,
        (context, index) => _buildRecordCard(
          theme,
          context,
          title: 'Medication Prescription',
          date: 'April 25, 2024',
          doctor: 'Dr. Sarah Wilson',
          type: 'Prescription',
          icon: Icons.medical_information,
        ),
        3,
      ),
    );
  }

  Widget _buildTestsTab(ThemeData theme) {
    return Builder(
      builder: (context) => _buildAnimatedList(
        theme,
        context,
        (context, index) => _buildRecordCard(
          theme,
          context,
          title: 'Blood Test Results',
          date: 'March 15, 2024',
          doctor: 'Dr. James Smith',
          type: 'Test',
          icon: Icons.science,
        ),
        4,
      ),
    );
  }

  Widget _buildRecordCard(
    ThemeData theme,
    BuildContext context, {
    required String title,
    required String date,
    required String doctor,
    required String type,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.medicalRecordDetails,
            arguments: {
              'record': {
                'title': title,
                'date': date,
                'doctorName': doctor,
                'type': type,
                'specialty': 'General Medicine',
                'description':
                    'Detailed medical record description would appear here.',
                'diagnosis': type == 'Report'
                    ? 'Patient shows good overall health with normal vital signs.'
                    : null,
                'treatment': type == 'Prescription'
                    ? 'Follow prescribed medication for 7 days.'
                    : null,
                'medications': type == 'Prescription'
                    ? [
                        'Medicine A - 1 tablet daily',
                        'Medicine B - 2 tablets twice daily',
                      ]
                    : null,
              },
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withAlpha(
                    25,
                  ), // 0.1 opacity = 25.5 alpha, rounded to 25
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: theme.primaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Date: $date',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Doctor: $doctor',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withAlpha(
                          25,
                        ), // 0.1 opacity = 25.5 alpha, rounded to 25
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        type,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
