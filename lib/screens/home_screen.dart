import 'package:flutter/material.dart';

import '../app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-Screen Portal'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Hero Card
              Card(
                elevation: 0,
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.layers_rounded,
                        size: 64,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Welcome to Multi-Screen App',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'A 3-screen demonstration using Flutter Named Routes, '
                        'Input Validation, and Route Arguments.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Application Workflow',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Route Cards
              _buildRouteCard(
                context,
                step: '1',
                title: 'Home Screen',
                route: AppRoutes.home,
                description: 'Landing screen and navigation launchpad.',
                icon: Icons.home_outlined,
                isActive: true,
              ),
              const SizedBox(height: 10),
              _buildRouteCard(
                context,
                step: '2',
                title: 'Registration Form',
                route: AppRoutes.register,
                description: 'Form with validation for email, password, and required inputs.',
                icon: Icons.app_registration_rounded,
                isActive: false,
              ),
              const SizedBox(height: 10),
              _buildRouteCard(
                context,
                step: '3',
                title: 'Detail Screen',
                route: AppRoutes.detail,
                description: 'Displays passed registration arguments with confirmation badges.',
                icon: Icons.badge_outlined,
                isActive: false,
              ),

              const SizedBox(height: 32),

              // Navigation Action Button
              FilledButton.icon(
                key: const Key('open_registration_button'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.register);
                },
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text(
                  'Go to Registration Form',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteCard(
    BuildContext context, {
    required String step,
    required String title,
    required String route,
    required String description,
    required IconData icon,
    required bool isActive,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          foregroundColor: isActive
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurfaceVariant,
          child: Text(
            step,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Row(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer.withValues(
                  alpha: 0.6,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                route,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(description),
        ),
        trailing: Icon(icon, color: theme.colorScheme.outline),
      ),
    );
  }
}
