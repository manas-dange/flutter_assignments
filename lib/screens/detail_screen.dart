import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/user_profile.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Retrieve arguments passed via named route
    final profile = ModalRoute.of(context)?.settings.arguments as UserProfile?;

    if (profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Registration Details')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 64,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'No Registration Data Found',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please fill out the registration form first.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.register);
                  },
                  child: const Text('Go to Registration Form'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final formattedDate =
        '${profile.registeredAt.year}-${profile.registeredAt.month.toString().padLeft(2, '0')}-${profile.registeredAt.day.toString().padLeft(2, '0')} at ${profile.registeredAt.hour.toString().padLeft(2, '0')}:${profile.registeredAt.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Details'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar & Name Card
              Card(
                elevation: 0,
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.35,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        child: Text(
                          profile.fullName.isNotEmpty
                              ? profile.fullName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profile.fullName,
                        key: const Key('detail_name_text'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.role,
                        key: const Key('detail_role_text'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_user_rounded,
                              size: 16,
                              color: Colors.green,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Registration Validated',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Detailed Attributes
              Text(
                'Submitted Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              _buildInfoTile(
                context,
                icon: Icons.person_outline,
                label: 'Full Name',
                value: profile.fullName,
              ),
              const SizedBox(height: 10),
              _buildInfoTile(
                context,
                icon: Icons.email_outlined,
                label: 'Email Address',
                value: profile.email,
                valueKey: 'detail_email_text',
              ),
              const SizedBox(height: 10),
              _buildInfoTile(
                context,
                icon: Icons.work_outline,
                label: 'Professional Role',
                value: profile.role,
              ),
              const SizedBox(height: 10),
              _buildInfoTile(
                context,
                icon: Icons.calendar_today_outlined,
                label: 'Registered On',
                value: formattedDate,
                valueKey: 'detail_date_text',
              ),

              const SizedBox(height: 32),

              // Action Buttons
              FilledButton.icon(
                key: const Key('back_to_home_button'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Named navigation back to Home screen and clear stack
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home_rounded),
                label: const Text(
                  'Back to Home Screen',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                key: const Key('register_another_button'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Register Another User'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    String? valueKey,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        subtitle: Text(
          value,
          key: valueKey != null ? Key(valueKey) : null,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
