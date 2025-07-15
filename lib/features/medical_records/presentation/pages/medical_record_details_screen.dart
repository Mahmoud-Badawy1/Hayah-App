import 'package:flutter/material.dart';

class MedicalRecordDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> record;

  const MedicalRecordDetailsScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing record...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading record...')),
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
                          radius: 24,
                          backgroundColor: theme.primaryColor.withAlpha(25),
                          child: Icon(
                            _getRecordIcon(record['type']),
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record['title'] ?? '',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Date: ${record['date']}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    _buildDetailSection(
                      theme,
                      title: 'Doctor Information',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record['doctorName'] ?? '',
                            style: theme.textTheme.titleMedium,
                          ),
                          Text(
                            record['specialty'] ?? '',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailSection(
                      theme,
                      title: 'Description',
                      content: Text(
                        record['description'] ??
                            'No description available for this record.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    if (record['diagnosis'] != null) ...[
                      const SizedBox(height: 16),
                      _buildDetailSection(
                        theme,
                        title: 'Diagnosis',
                        content: Text(
                          record['diagnosis'],
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                    if (record['treatment'] != null) ...[
                      const SizedBox(height: 16),
                      _buildDetailSection(
                        theme,
                        title: 'Treatment Plan',
                        content: Text(
                          record['treatment'],
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                    if (record['medications'] != null) ...[
                      const SizedBox(height: 16),
                      _buildDetailSection(
                        theme,
                        title: 'Medications',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var medication in record['medications'])
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  '• $medication',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getRecordIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'report':
        return Icons.description;
      case 'prescription':
        return Icons.medical_information;
      case 'test':
        return Icons.science;
      default:
        return Icons.folder;
    }
  }

  Widget _buildDetailSection(
    ThemeData theme, {
    required String title,
    required Widget content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }
}
