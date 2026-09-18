import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_assignments/app_routes.dart';
import 'package:flutter_assignments/main.dart';
import 'package:flutter_assignments/screens/home_screen.dart';

void main() {
  testWidgets(
    'Home screen displays welcome info and navigates to Form screen',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MultiScreenApp());

      // Verify Home Screen widgets
      expect(find.text('Multi-Screen Portal'), findsOneWidget);
      expect(find.text('Welcome to Multi-Screen App'), findsOneWidget);
      expect(find.text('Registration Form'), findsOneWidget); // Route card

      // Ensure button is visible in scroll view and tap
      final openButton = find.byKey(const Key('open_registration_button'));
      await tester.ensureVisible(openButton);
      await tester.tap(openButton);
      await tester.pumpAndSettle();

      // Verify we navigated to Registration Form screen
      expect(find.text('Create an Account'), findsOneWidget);
      expect(find.byKey(const Key('name_field')), findsOneWidget);
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
    },
  );

  testWidgets('Form validation triggers on empty and invalid inputs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MultiScreenApp());

    // Go to registration form
    final openButton = find.byKey(const Key('open_registration_button'));
    await tester.ensureVisible(openButton);
    await tester.tap(openButton);
    await tester.pumpAndSettle();

    // Tap submit on empty form
    final submitButton = find.byKey(const Key('submit_registration_button'));
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Verify required field error messages
    expect(find.text('Full name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    expect(
      find.text('You must accept the terms & conditions to proceed'),
      findsOneWidget,
    );

    // Test invalid email
    final emailField = find.byKey(const Key('email_field'));
    await tester.ensureVisible(emailField);
    await tester.enterText(emailField, 'invalid-email-format');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();
    expect(
      find.text('Enter a valid email address (e.g. user@domain.com)'),
      findsOneWidget,
    );

    // Test short password
    final passwordField = find.byKey(const Key('password_field'));
    await tester.ensureVisible(passwordField);
    await tester.enterText(passwordField, '123');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();
    expect(
      find.text('Password must be at least 6 characters long'),
      findsOneWidget,
    );

    // Test password without letters
    await tester.ensureVisible(passwordField);
    await tester.enterText(passwordField, '123456');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();
    expect(
      find.text('Password must contain both letters and numbers'),
      findsOneWidget,
    );

    // Test password confirmation mismatch
    final confirmPasswordField = find.byKey(
      const Key('confirm_password_field'),
    );
    await tester.ensureVisible(passwordField);
    await tester.enterText(passwordField, 'Pass123');
    await tester.ensureVisible(confirmPasswordField);
    await tester.enterText(confirmPasswordField, 'Pass456');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();
    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets(
    'Complete flow: Home -> Form (Valid input) -> Detail screen -> Home',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MultiScreenApp());

      // 1. Navigate to Form
      final openButton = find.byKey(const Key('open_registration_button'));
      await tester.ensureVisible(openButton);
      await tester.tap(openButton);
      await tester.pumpAndSettle();

      // 2. Fill in valid inputs
      final nameField = find.byKey(const Key('name_field'));
      final emailField = find.byKey(const Key('email_field'));
      final passwordField = find.byKey(const Key('password_field'));
      final confirmPasswordField = find.byKey(
        const Key('confirm_password_field'),
      );
      final termsCheckbox = find.byKey(const Key('terms_checkbox'));
      final submitButton = find.byKey(const Key('submit_registration_button'));

      await tester.ensureVisible(nameField);
      await tester.enterText(nameField, 'Jane Doe');

      await tester.ensureVisible(emailField);
      await tester.enterText(emailField, 'jane.doe@example.com');

      await tester.ensureVisible(passwordField);
      await tester.enterText(passwordField, 'SecurePass1');

      await tester.ensureVisible(confirmPasswordField);
      await tester.enterText(confirmPasswordField, 'SecurePass1');

      // Unfocus keyboard so screen viewport is fully visible
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();

      await tester.ensureVisible(termsCheckbox);
      await tester.tap(termsCheckbox);
      await tester.pumpAndSettle();

      // 3. Submit Form
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // 4. Verify Detail Screen is displayed with submitted data
      expect(find.text('Registration Details'), findsOneWidget);
      expect(find.text('Jane Doe'), findsWidgets);
      expect(find.text('jane.doe@example.com'), findsOneWidget);
      expect(find.text('Flutter Developer'), findsWidgets);
      expect(find.text('Registration Validated'), findsOneWidget);

      // 5. Navigate back to Home screen
      final backButton = find.byKey(const Key('back_to_home_button'));
      await tester.ensureVisible(backButton);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify back on Home Screen
      expect(find.text('Welcome to Multi-Screen App'), findsOneWidget);
    },
  );

  testWidgets('Reset button clears form fields', (WidgetTester tester) async {
    await tester.pumpWidget(const MultiScreenApp());

    final openButton = find.byKey(const Key('open_registration_button'));
    await tester.ensureVisible(openButton);
    await tester.tap(openButton);
    await tester.pumpAndSettle();

    final nameField = find.byKey(const Key('name_field'));
    await tester.ensureVisible(nameField);
    await tester.enterText(nameField, 'Sample User');

    // Tap reset button
    final resetButton = find.byKey(const Key('reset_form_button'));
    await tester.ensureVisible(resetButton);
    await tester.tap(resetButton);
    await tester.pumpAndSettle();

    // Verify field is cleared
    expect(find.text('Sample User'), findsNothing);
  });

  testWidgets('Detail screen fallback when no arguments provided', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: AppRoutes.detail,
        routes: {
          AppRoutes.home: (context) => const SizedBox(),
          AppRoutes.register: (context) => const SizedBox(),
          AppRoutes.detail: (context) => const MultiScreenApp(),
        },
      ),
    );

    // Using MultiScreenApp directly to route to detail
    await tester.pumpWidget(const MultiScreenApp());
    final BuildContext context = tester.element(find.byType(HomeScreen));
    Navigator.pushNamed(context, AppRoutes.detail);
    await tester.pumpAndSettle();

    expect(find.text('No Registration Data Found'), findsOneWidget);
    expect(find.text('Go to Registration Form'), findsOneWidget);
  });
}
