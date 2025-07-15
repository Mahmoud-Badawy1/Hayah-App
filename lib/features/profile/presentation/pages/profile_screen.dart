import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/animations/app_animations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _avatarAnimation;
  late Animation<double> _infoAnimation;
  late Animation<double> _settingsAnimation;
  late Animation<double> _logoutAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.longDuration,
    );

    _avatarAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );

    _infoAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
    );

    _settingsAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
    );

    _logoutAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
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
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/edit-profile');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ScaleTransition(
                scale: _avatarAnimation,
                child: FadeTransition(
                  opacity: _avatarAnimation,
                  child: _buildProfileHeader(theme),
                ),
              ),
              const SizedBox(height: 24),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-0.2, 0),
                  end: Offset.zero,
                ).animate(_infoAnimation),
                child: FadeTransition(
                  opacity: _infoAnimation,
                  child: _buildPersonalInfo(theme),
                ),
              ),
              const SizedBox(height: 24),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.2, 0),
                  end: Offset.zero,
                ).animate(_settingsAnimation),
                child: FadeTransition(
                  opacity: _settingsAnimation,
                  child: _buildSettings(theme),
                ),
              ),
              const SizedBox(height: 24),
              FadeTransition(
                opacity: _logoutAnimation,
                child: _buildLogoutButton(context, theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: theme.primaryColor.withAlpha(25),
          child: Icon(Icons.person, size: 50, color: theme.primaryColor),
        ),
        const SizedBox(height: 16),
        Text(
          'John Doe',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Patient ID: #123456',
          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildPersonalInfo(ThemeData theme) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              theme,
              icon: Icons.email,
              label: 'Email',
              value: 'john.doe@example.com',
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              theme,
              icon: Icons.phone,
              label: 'Phone',
              value: '+1 234 567 890',
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              theme,
              icon: Icons.cake,
              label: 'Date of Birth',
              value: 'January 1, 1990',
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              theme,
              icon: Icons.location_on,
              label: 'Address',
              value: '123 Main St, New York, NY 10001',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettings(ThemeData theme) {
    return Card(
      child: Column(
        children: [
          _buildSettingsItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildNotificationsSheet(context, theme),
              );
            },
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            icon: Icons.payment,
            title: 'Billing & Payments',
            onTap: () => Navigator.pushNamed(context, '/billing'),
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            icon: Icons.lock_outline,
            title: 'Privacy & Security',
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildPrivacySheet(context, theme),
              );
            },
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            icon: Icons.language,
            title: 'Language',
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildLanguageSheet(context, theme),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildInfoRow(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              Text(value, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () {
          context.read<AuthBloc>().add(SignOutRequested());
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        },
        icon: const Icon(Icons.logout),
        label: const Text('Log Out'),
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.error,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsSheet(BuildContext context, ThemeData theme) {
    return _buildSettingsSheet(
      title: 'Notifications',
      children: [
        SwitchListTile(
          title: const Text('Push Notifications'),
          subtitle: const Text('Receive alerts and reminders'),
          value: true,
          onChanged: (value) {
            // Implement push notifications toggle
          },
        ),
        SwitchListTile(
          title: const Text('Email Notifications'),
          subtitle: const Text('Receive updates via email'),
          value: true,
          onChanged: (value) {
            // Implement email notifications toggle
          },
        ),
        SwitchListTile(
          title: const Text('Appointment Reminders'),
          subtitle: const Text('Get notified about upcoming appointments'),
          value: true,
          onChanged: (value) {
            // Implement appointment reminders toggle
          },
        ),
      ],
    );
  }

  Widget _buildPrivacySheet(BuildContext context, ThemeData theme) {
    return _buildSettingsSheet(
      title: 'Privacy & Security',
      children: [
        ListTile(
          title: const Text('Change Password'),
          leading: const Icon(Icons.lock_outline),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Implement change password
          },
        ),
        ListTile(
          title: const Text('Two-Factor Authentication'),
          leading: const Icon(Icons.security),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Implement 2FA
          },
        ),
        ListTile(
          title: const Text('Privacy Policy'),
          leading: const Icon(Icons.policy),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Show privacy policy
          },
        ),
      ],
    );
  }

  Widget _buildLanguageSheet(BuildContext context, ThemeData theme) {
    return _buildSettingsSheet(
      title: 'Language',
      children: [
        RadioListTile<String>(
          title: const Text('English'),
          value: 'en',
          groupValue: 'en',
          onChanged: (value) {
            // Implement language change
            Navigator.pop(context);
          },
        ),
        RadioListTile<String>(
          title: const Text('Arabic'),
          value: 'ar',
          groupValue: 'en',
          onChanged: (value) {
            // Implement language change
            Navigator.pop(context);
          },
        ),
        RadioListTile<String>(
          title: const Text('French'),
          value: 'fr',
          groupValue: 'en',
          onChanged: (value) {
            // Implement language change
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildSettingsSheet({
    required String title,
    required List<Widget> children,
  }) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
}
