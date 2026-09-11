import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_assignments/main.dart';

void main() {
  testWidgets('Initial tasks and progress display correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TodoListApp());

    // Verify initial tasks exist
    expect(find.text('Explore Flutter widgets'), findsOneWidget);
    expect(
      find.text('Build Todo List app with StatefulWidget'),
      findsOneWidget,
    );
    expect(find.text('Write comprehensive widget tests'), findsOneWidget);

    // Verify progress text
    expect(find.text('1 of 3 completed'), findsOneWidget);
  });

  testWidgets('Add a new todo task', (WidgetTester tester) async {
    await tester.pumpWidget(const TodoListApp());

    // Tap FloatingActionButton to open the Add Task modal
    await tester.tap(find.byKey(const Key('add_todo_fab')));
    await tester.pumpAndSettle();

    // Verify modal bottom sheet appeared
    expect(find.text('Add New Task'), findsOneWidget);

    // Enter new task title
    await tester.enterText(
      find.byKey(const Key('todo_input_field')),
      'Drink 2 liters of water',
    );
    await tester.pump();

    // Tap Add Task button
    await tester.tap(find.byKey(const Key('submit_todo_button')));
    await tester.pumpAndSettle();

    // Verify the new task is now in the list
    expect(find.text('Drink 2 liters of water'), findsOneWidget);
    expect(find.text('1 of 4 completed'), findsOneWidget);
  });

  testWidgets('Mark-complete toggles task status', (WidgetTester tester) async {
    await tester.pumpWidget(const TodoListApp());

    // Task '2' ("Build Todo List app with StatefulWidget") starts incomplete
    final checkboxFinder = find.byKey(const Key('checkbox_2'));
    expect(checkboxFinder, findsOneWidget);
    expect(tester.widget<Checkbox>(checkboxFinder).value, isFalse);

    // Tap the checkbox to mark complete
    await tester.tap(checkboxFinder);
    await tester.pumpAndSettle();

    // Verify checkbox is now true
    expect(tester.widget<Checkbox>(checkboxFinder).value, isTrue);
    expect(find.text('2 of 3 completed'), findsOneWidget);

    // Tap again to unmark
    await tester.tap(checkboxFinder);
    await tester.pumpAndSettle();

    expect(tester.widget<Checkbox>(checkboxFinder).value, isFalse);
    expect(find.text('1 of 3 completed'), findsOneWidget);
  });

  testWidgets('Delete task removes item and shows undo snackbar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TodoListApp());

    // Initial check
    expect(find.text('Explore Flutter widgets'), findsOneWidget);

    // Delete the first task (id: 1)
    await tester.tap(find.byKey(const Key('delete_1')));
    await tester.pumpAndSettle();

    // Item should be removed
    expect(find.text('Explore Flutter widgets'), findsNothing);
    expect(find.text('Deleted "Explore Flutter widgets"'), findsOneWidget);

    // Tap Undo
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();

    // Item should be restored
    expect(find.text('Explore Flutter widgets'), findsOneWidget);
  });

  testWidgets('Filters work as expected', (WidgetTester tester) async {
    await tester.pumpWidget(const TodoListApp());

    // Initial state: All (3 items)
    expect(find.text('Explore Flutter widgets'), findsOneWidget); // completed
    expect(
      find.text('Build Todo List app with StatefulWidget'),
      findsOneWidget,
    ); // active

    // Switch to Active filter
    await tester.tap(find.text('Active'));
    await tester.pumpAndSettle();

    expect(find.text('Explore Flutter widgets'), findsNothing);
    expect(
      find.text('Build Todo List app with StatefulWidget'),
      findsOneWidget,
    );

    // Switch to Completed filter
    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle();

    expect(find.text('Explore Flutter widgets'), findsOneWidget);
    expect(find.text('Build Todo List app with StatefulWidget'), findsNothing);
  });
}
