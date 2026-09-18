import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/user_profile.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedRole = 'Flutter Developer';
  bool _acceptTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> _roles = [
    'Flutter Developer',
    'Full Stack Engineer',
    'UI/UX Designer',
    'Product Manager',
    'QA Engineer',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final profile = UserProfile(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        role: _selectedRole ?? 'General Member',
        registeredAt: DateTime.now(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Successful! Navigating to details...'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );

      // Navigate to Detail screen using named route and pass profile as argument
      Navigator.pushNamed(context, AppRoutes.detail, arguments: profile);
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _selectedRole = 'Flutter Developer';
      _acceptTerms = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Registration Form')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Info
                Text(
                  'Create an Account',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'All fields with * are required. Please enter valid information.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                // Full Name Field
                TextFormField(
                  key: const Key('name_field'),
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Full Name *',
                    hintText: 'e.g. Jane Doe',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Full name is required';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email Field
                TextFormField(
                  key: const Key('email_field'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address *',
                    hintText: 'e.g. jane.doe@example.com',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    );
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Enter a valid email address (e.g. user@domain.com)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Role Dropdown Field
                DropdownButtonFormField<String>(
                  key: const Key('role_dropdown'),
                  initialValue: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Professional Role *',
                    prefixIcon: Icon(Icons.work_outline),
                    border: OutlineInputBorder(),
                  ),
                  items: _roles.map((role) {
                    return DropdownMenuItem(value: role, child: Text(role));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a role';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  key: const Key('password_field'),
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password *',
                    hintText: 'Minimum 6 characters with letters & numbers',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      key: const Key('toggle_password_visibility'),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
                    final hasDigit = RegExp(r'[0-9]').hasMatch(value);
                    if (!hasLetter || !hasDigit) {
                      return 'Password must contain both letters and numbers';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password Field
                TextFormField(
                  key: const Key('confirm_password_field'),
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password *',
                    hintText: 'Re-enter your password',
                    prefixIcon: const Icon(Icons.lock_clock_outlined),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      key: const Key('toggle_confirm_password_visibility'),
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Terms and Conditions FormField Checkbox
                FormField<bool>(
                  key: const Key('terms_field'),
                  initialValue: _acceptTerms,
                  validator: (value) {
                    if (_acceptTerms != true) {
                      return 'You must accept the terms & conditions to proceed';
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckboxListTile(
                          key: const Key('terms_checkbox'),
                          value: _acceptTerms,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'I agree to the Terms and Conditions and Privacy Policy *',
                            style: theme.textTheme.bodyMedium,
                          ),
                          onChanged: (val) {
                            setState(() {
                              _acceptTerms = val ?? false;
                              state.didChange(val);
                            });
                          },
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(left: 12, top: 4),
                            child: Text(
                              state.errorText ?? '',
                              style: TextStyle(
                                color: theme.colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Submit Button
                FilledButton.icon(
                  key: const Key('submit_registration_button'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _submitForm,
                  icon: const Icon(Icons.how_to_reg_rounded),
                  label: const Text(
                    'Submit Registration',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),

                // Reset Button
                OutlinedButton.icon(
                  key: const Key('reset_form_button'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _resetForm,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Clear / Reset Form'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
