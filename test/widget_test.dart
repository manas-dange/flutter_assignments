import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_assignments/main.dart';
import 'package:flutter_assignments/services/post_repository.dart';

void main() {
  const samplePostsJson = '''[
    {
      "userId": 1,
      "id": 1,
      "title": "sunt aut facere repellat",
      "body": "quia et suscipit suscipit recusandae consequuntur"
    },
    {
      "userId": 1,
      "id": 2,
      "title": "qui est esse",
      "body": "est rerum tempore vitae sequi sint"
    }
  ]''';

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('FutureBuilder displays loading indicator while fetching', (
    WidgetTester tester,
  ) async {
    final mockClient = MockClient((request) async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return http.Response(samplePostsJson, 200);
    });

    final prefs = await SharedPreferences.getInstance();
    final repository = PostRepository(client: mockClient, prefs: prefs);

    await tester.pumpWidget(ApiDataFetcherApp(repository: repository));

    // Initially waiting for future
    expect(find.byKey(const Key('loading_indicator')), findsOneWidget);
    expect(find.text('Fetching posts from REST API...'), findsOneWidget);

    await tester.pumpAndSettle();

    // After completion, English-transformed posts are rendered
    expect(find.text('Getting Started with Flutter and Dart'), findsOneWidget);
    expect(
      find.text('Understanding Reactive UI with StatefulWidget and setState'),
      findsOneWidget,
    );
  });

  testWidgets('FutureBuilder renders network data and stores in cache', (
    WidgetTester tester,
  ) async {
    final mockClient = MockClient((request) async {
      return http.Response(samplePostsJson, 200);
    });

    final prefs = await SharedPreferences.getInstance();
    final repository = PostRepository(client: mockClient, prefs: prefs);

    await tester.pumpWidget(ApiDataFetcherApp(repository: repository));
    await tester.pumpAndSettle();

    // Verify posts rendered in English
    expect(find.text('Getting Started with Flutter and Dart'), findsOneWidget);
    expect(
      find.text('Understanding Reactive UI with StatefulWidget and setState'),
      findsOneWidget,
    );

    // Verify source badge indicates live network
    expect(find.text('Live Network Data'), findsOneWidget);
    expect(find.text('2 items'), findsOneWidget);

    // Verify SharedPreferences has cached the data
    expect(prefs.getString(PostRepository.cacheKey), isNotNull);
    expect(prefs.getString(PostRepository.cacheTimestampKey), isNotNull);
  });

  testWidgets(
    'FutureBuilder falls back to SharedPreferences cache when network fails',
    (WidgetTester tester) async {
      // Populate SharedPreferences with cached data
      SharedPreferences.setMockInitialValues({
        PostRepository.cacheKey: samplePostsJson,
        PostRepository.cacheTimestampKey: DateTime.now()
            .subtract(const Duration(minutes: 10))
            .toIso8601String(),
      });

      // Mock client that fails (offline / server error)
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      final prefs = await SharedPreferences.getInstance();
      final repository = PostRepository(client: mockClient, prefs: prefs);

      await tester.pumpWidget(ApiDataFetcherApp(repository: repository));
      await tester.pumpAndSettle();

      // Verify cached posts are still rendered in English
      expect(
        find.text('Getting Started with Flutter and Dart'),
        findsOneWidget,
      );
      expect(
        find.text('Understanding Reactive UI with StatefulWidget and setState'),
        findsOneWidget,
      );

      // Verify badge indicates cached data fallback
      expect(find.text('Cached Data (SharedPreferences)'), findsOneWidget);
    },
  );

  testWidgets(
    'FutureBuilder shows error state when network fails and no cache exists',
    (WidgetTester tester) async {
      // Empty cache
      SharedPreferences.setMockInitialValues({});

      final mockClient = MockClient((request) async {
        throw http.ClientException('Network connection refused');
      });

      final prefs = await SharedPreferences.getInstance();
      final repository = PostRepository(client: mockClient, prefs: prefs);

      await tester.pumpWidget(ApiDataFetcherApp(repository: repository));
      await tester.pumpAndSettle();

      // Verify error UI is displayed
      expect(find.text('Failed to Load Data'), findsOneWidget);
      expect(find.byKey(const Key('retry_button')), findsOneWidget);
    },
  );

  testWidgets('Tapping post card opens detail modal', (
    WidgetTester tester,
  ) async {
    final mockClient = MockClient((request) async {
      return http.Response(samplePostsJson, 200);
    });

    final prefs = await SharedPreferences.getInstance();
    final repository = PostRepository(client: mockClient, prefs: prefs);

    await tester.pumpWidget(ApiDataFetcherApp(repository: repository));
    await tester.pumpAndSettle();

    // Tap first post card
    await tester.tap(find.byKey(const Key('post_card_1')));
    await tester.pumpAndSettle();

    // Verify bottom sheet modal opened with English content
    expect(find.text('Post #1 (User 1)'), findsOneWidget);
    expect(
      find.text(
        'Learn how to architect your Flutter application with clean code practices, modular folder structures, and reactive state management.',
      ),
      findsWidgets,
    );
  });

  testWidgets('Clear cache removes keys from SharedPreferences', (
    WidgetTester tester,
  ) async {
    final mockClient = MockClient((request) async {
      return http.Response(samplePostsJson, 200);
    });

    final prefs = await SharedPreferences.getInstance();
    final repository = PostRepository(client: mockClient, prefs: prefs);

    await tester.pumpWidget(ApiDataFetcherApp(repository: repository));
    await tester.pumpAndSettle();

    expect(prefs.getString(PostRepository.cacheKey), isNotNull);

    // Tap clear cache button in AppBar
    await tester.tap(find.byKey(const Key('clear_cache_button')));
    await tester.pumpAndSettle();

    // Verify cache is cleared
    expect(prefs.getString(PostRepository.cacheKey), isNull);
    expect(find.text('Local SharedPreferences cache cleared!'), findsOneWidget);
  });
}
