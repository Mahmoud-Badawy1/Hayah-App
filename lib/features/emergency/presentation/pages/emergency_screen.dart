import 'package:flutter/material.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.emergency, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Emergency Contacts',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                // TODO: Implement emergency call
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.all(20),
              ),
              icon: const Icon(Icons.phone),
              label: const Text('Call Emergency Services'),
            ),
            const SizedBox(height: 24),
            Text('Nearby Hospitals', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  _buildHospitalCard(
                    context,
                    name: 'City General Hospital',
                    distance: '2.5 km',
                    isOpen: true,
                  ),
                  _buildHospitalCard(
                    context,
                    name: 'St. Mary\'s Hospital',
                    distance: '3.8 km',
                    isOpen: true,
                  ),
                  _buildHospitalCard(
                    context,
                    name: 'Central Medical Center',
                    distance: '5.1 km',
                    isOpen: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalCard(
    BuildContext context, {
    required String name,
    required String distance,
    required bool isOpen,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.local_hospital)),
        title: Text(name),
        subtitle: Text(distance),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isOpen ? Colors.green.shade100 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            isOpen ? 'Open' : 'Closed',
            style: TextStyle(
              color: isOpen ? Colors.green.shade700 : Colors.grey.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          // TODO: Implement navigation to hospital
        },
      ),
    );
  }
}
