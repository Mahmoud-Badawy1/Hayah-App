import 'package:flutter/material.dart';

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Billing & Payments')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment Methods', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16),
                  _buildPaymentMethod(
                    icon: Icons.credit_card,
                    title: '**** **** **** 4242',
                    subtitle: 'Expires 12/25',
                  ),
                  const Divider(),
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Implement add payment method
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Payment Method'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Recent Transactions', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                _buildTransactionItem(
                  date: 'July 10, 2025',
                  description: 'Video Consultation',
                  amount: 50.00,
                  status: 'Paid',
                ),
                const Divider(height: 1),
                _buildTransactionItem(
                  date: 'July 5, 2025',
                  description: 'Lab Tests',
                  amount: 125.00,
                  status: 'Paid',
                ),
                const Divider(height: 1),
                _buildTransactionItem(
                  date: 'June 28, 2025',
                  description: 'Regular Checkup',
                  amount: 75.00,
                  status: 'Paid',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            child: const Text('Set as Default'),
            onTap: () {
              // TODO: Implement set as default
            },
          ),
          PopupMenuItem(
            child: const Text('Remove'),
            onTap: () {
              // TODO: Implement remove payment method
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String date,
    required String description,
    required double amount,
    required String status,
  }) {
    return ListTile(
      title: Text(description),
      subtitle: Text(date),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            status,
            style: TextStyle(
              color: status == 'Paid' ? Colors.green : Colors.orange,
              fontSize: 12,
            ),
          ),
        ],
      ),
      onTap: () {
        // TODO: Show transaction details
      },
    );
  }
}
