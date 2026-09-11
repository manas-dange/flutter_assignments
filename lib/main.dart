import 'package:flutter/material.dart';

import 'models/todo_item.dart';

void main() {
  runApp(const TodoListApp());
}

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const TodoListScreen(),
    );
  }
}

enum TodoFilter { all, active, completed }

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItem> _todos = [
    TodoItem(
      id: '1',
      title: 'Explore Flutter widgets',
      isCompleted: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    TodoItem(
      id: '2',
      title: 'Build Todo List app with StatefulWidget',
      isCompleted: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    TodoItem(
      id: '3',
      title: 'Write comprehensive widget tests',
      isCompleted: false,
      createdAt: DateTime.now(),
    ),
  ];

  TodoFilter _currentFilter = TodoFilter.all;

  // Add a new Todo item using setState
  void _addTodo(String title) {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      return;
    }

    setState(() {
      _todos.insert(
        0,
        TodoItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: trimmedTitle,
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  // Toggle mark-complete status using setState
  void _toggleTodo(String id) {
    setState(() {
      final index = _todos.indexWhere((item) => item.id == id);
      if (index != -1) {
        _todos[index] = _todos[index].copyWith(
          isCompleted: !_todos[index].isCompleted,
        );
      }
    });
  }

  // Delete a Todo item using setState
  void _deleteTodo(String id) {
    final index = _todos.indexWhere((item) => item.id == id);
    if (index == -1) {
      return;
    }

    final deletedItem = _todos[index];
    setState(() {
      _todos.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${deletedItem.title}"'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _todos.insert(index, deletedItem);
            });
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Show bottom sheet or dialog to enter a new task
  void _showAddTodoModal() {
    final textController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add New Task',
                    style: Theme.of(sheetContext).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(sheetContext),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                key: const Key('todo_input_field'),
                controller: textController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Task title',
                  hintText: 'e.g. Plan weekend road trip',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.task_outlined),
                ),
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    _addTodo(value);
                    Navigator.pop(sheetContext);
                  }
                },
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                key: const Key('submit_todo_button'),
                onPressed: () {
                  if (textController.text.trim().isNotEmpty) {
                    _addTodo(textController.text);
                    Navigator.pop(sheetContext);
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Task'),
              ),
            ],
          ),
        );
      },
    );
  }

  List<TodoItem> get _filteredTodos {
    switch (_currentFilter) {
      case TodoFilter.active:
        return _todos.where((item) => !item.isCompleted).toList();
      case TodoFilter.completed:
        return _todos.where((item) => item.isCompleted).toList();
      case TodoFilter.all:
        return _todos;
    }
  }

  int get _completedCount => _todos.where((item) => item.isCompleted).length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredList = _filteredTodos;
    final totalCount = _todos.length;
    final completedCount = _completedCount;
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;

    return Scaffold(
      appBar: AppBar(title: const Text('Todo List'), centerTitle: true),
      body: Column(
        children: [
          // Progress & Stats Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 0,
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Task Progress',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$completedCount of $totalCount completed',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Filter Selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: SegmentedButton<TodoFilter>(
              segments: const [
                ButtonSegment<TodoFilter>(
                  value: TodoFilter.all,
                  label: Text('All'),
                  icon: Icon(Icons.list),
                ),
                ButtonSegment<TodoFilter>(
                  value: TodoFilter.active,
                  label: Text('Active'),
                  icon: Icon(Icons.radio_button_unchecked),
                ),
                ButtonSegment<TodoFilter>(
                  value: TodoFilter.completed,
                  label: Text('Completed'),
                  icon: Icon(Icons.check_circle_outline),
                ),
              ],
              selected: {_currentFilter},
              onSelectionChanged: (Set<TodoFilter> newSelection) {
                setState(() {
                  _currentFilter = newSelection.first;
                });
              },
            ),
          ),

          const SizedBox(height: 6),

          // Todo List or Empty State
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.checklist_rtl_rounded,
                          size: 72,
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _todos.isEmpty
                              ? 'No tasks yet!'
                              : 'No ${_currentFilter.name} tasks found',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _todos.isEmpty
                              ? 'Tap the + button below to add your first task.'
                              : 'Switch filters or add more tasks.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: filteredList.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return Card(
                        key: Key('todo_item_${item.id}'),
                        elevation: item.isCompleted ? 0 : 1,
                        color: item.isCompleted
                            ? theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.4)
                            : theme.colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: item.isCompleted
                                ? Colors.transparent
                                : theme.colorScheme.outlineVariant.withValues(
                                    alpha: 0.5,
                                  ),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          leading: Checkbox(
                            key: Key('checkbox_${item.id}'),
                            value: item.isCompleted,
                            onChanged: (_) => _toggleTodo(item.id),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          title: Text(
                            item.title,
                            style: TextStyle(
                              decoration: item.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: item.isCompleted
                                  ? theme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.6)
                                  : theme.colorScheme.onSurface,
                              fontWeight: item.isCompleted
                                  ? FontWeight.normal
                                  : FontWeight.w500,
                            ),
                          ),
                          trailing: IconButton(
                            key: Key('delete_${item.id}'),
                            icon: Icon(
                              Icons.delete_outline,
                              color: theme.colorScheme.error,
                            ),
                            tooltip: 'Delete task',
                            onPressed: () => _deleteTodo(item.id),
                          ),
                          onTap: () => _toggleTodo(item.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('add_todo_fab'),
        onPressed: _showAddTodoModal,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }
}
