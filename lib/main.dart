import 'package:flutter/material.dart';

void main() {
  runApp(const ProfileApp());
}

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Custom theme colors
    const primaryColor = Color(0xFF6C5CE7);
    const secondaryColor = Color(0xFFA29BFE);
    const backgroundColor = Color(0xFFF4F6F9);
    const cardBackgroundColor = Colors.white;
    const textColor = Color(0xFF2D3436);
    const subtitleColor = Color(0xFF636E72);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile UI',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
          surface: cardBackgroundColor,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          titleMedium: TextStyle(
            color: subtitleColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(color: textColor, fontSize: 14),
        ),
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Profile Avatar Section using CircleAvatar, Container, and Icon
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 3.0,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: theme.colorScheme.secondary.withValues(
                        alpha: 0.3,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name & Title using Text and Column
                  Text('Alex Morgan', style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Flutter & Mobile Developer',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),

                  // Location Tag using Row, Icon, Text, and Container
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'San Francisco, CA',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Statistics Section using Container, Row, Column, Text, and Icon
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          context,
                          count: '128',
                          label: 'Projects',
                          icon: Icons.code,
                        ),
                        _buildDivider(theme),
                        _buildStatItem(
                          context,
                          count: '14.5k',
                          label: 'Followers',
                          icon: Icons.people,
                        ),
                        _buildDivider(theme),
                        _buildStatItem(
                          context,
                          count: '4.9',
                          label: 'Rating',
                          icon: Icons.star,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Contact Details Section using Column, Container, Row, Icon, and Text
                  Column(
                    children: [
                      _buildInfoTile(
                        context,
                        icon: Icons.email_outlined,
                        title: 'Email',
                        subtitle: 'alex.morgan@example.com',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoTile(
                        context,
                        icon: Icons.phone_outlined,
                        title: 'Phone',
                        subtitle: '+1 (555) 234-5678',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoTile(
                        context,
                        icon: Icons.language,
                        title: 'Portfolio',
                        subtitle: 'alexmorgan.dev',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons Section using Row, Container, Icon, and Text
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.message,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Message',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary.withValues(
                            alpha: 0.2,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.share,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildStatItem(
    BuildContext context, {
    required String count,
    required String label,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              count,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: theme.textTheme.headlineMedium?.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
      ],
    );
  }

  static Widget _buildDivider(ThemeData theme) {
    return Container(
      height: 30,
      width: 1,
      color: theme.colorScheme.primary.withValues(alpha: 0.2),
    );
  }

  static Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.headlineMedium?.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
