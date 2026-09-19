class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final rawTitle = json['title'] as String? ?? '';
    final rawBody = json['body'] as String? ?? '';
    final id = json['id'] as int? ?? 1;
    final userId = json['userId'] as int? ?? 1;

    // Convert Latin placeholder text from JSONPlaceholder into readable English
    final englishTitle = _isLatinPlaceholder(rawTitle)
        ? _getEnglishTitle(id)
        : rawTitle;
    final englishBody = _isLatinPlaceholder(rawBody)
        ? _getEnglishBody(id)
        : rawBody;

    return Post(id: id, userId: userId, title: englishTitle, body: englishBody);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'userId': userId, 'title': title, 'body': body};
  }

  // Detects if the string is pseudo-Latin / Lorem Ipsum placeholder text
  static bool _isLatinPlaceholder(String text) {
    final lower = text.toLowerCase();
    const latinKeywords = [
      'sunt',
      'facere',
      'repellat',
      'quia',
      'suscipit',
      'recusandae',
      'molestias',
      'occaecati',
      'excepturi',
      'reprehenderit',
      'qui est',
      'dolor',
      'amet',
      'lorem',
      'ipsum',
      'ullam',
      'consequuntur',
      'adipisci',
      'eum et',
      'nesciunt',
      'autem',
    ];

    for (final word in latinKeywords) {
      if (lower.contains(word)) {
        return true;
      }
    }
    return false;
  }

  static final List<String> _englishTitles = [
    'Getting Started with Flutter and Dart',
    'Understanding Reactive UI with StatefulWidget and setState',
    'How to Fetch Data from REST APIs in Flutter',
    'Local Caching and Offline Persistence with SharedPreferences',
    'Mastering FutureBuilder for Asynchronous Operations',
    'Building Responsive Layouts for Mobile and Web',
    'Effective Error Handling and Network Retries',
    'Optimizing App Performance and Widget Rebuilds',
    'Clean Architecture and Repository Pattern in Flutter',
    'State Management Options: Provider, Riverpod, and Bloc',
    'Implementing Pull-to-Refresh with RefreshIndicator',
    'Working with JSON Serialization and Deserialization',
    'Creating Custom Modals and Bottom Sheets',
    'Material 3 Theming and Dark Mode Integration',
    'Automated Testing: Unit, Widget, and Integration Tests',
    'Secure Storage and Best Practices for Mobile Keys',
    'Deep Linking and Named Routes Navigation',
    'Handling Offline First Applications Gracefully',
    'Animations and Micro-Interactions for Modern UI',
    'Deploying Flutter Apps to Web and Mobile Platforms',
  ];

  static final List<String> _englishBodies = [
    'Learn how to architect your Flutter application with clean code practices, modular folder structures, and reactive state management.',
    'Discover how to connect your mobile client to public REST endpoints, parse incoming JSON structures, and gracefully handle network exceptions.',
    'Explore SharedPreferences key-value caching strategies to ensure your users have instantaneous access to their data even when offline.',
    'FutureBuilder allows widgets to rebuild reactively as network futures resolve through waiting, active, error, and completed states.',
    'Modern UI development requires responsive layouts that adapt seamlessly across phone screens, tablets, and desktop browsers.',
    'Keep your codebase maintainable by separating data fetching logic into dedicated repositories and decoupled service classes.',
    'Implement user-friendly indicators such as pull-to-refresh gestures, error retry buttons, and real-time network status chips.',
    'Ensure application stability across all device form factors with automated widget testing and rigorous lint analysis.',
    'Deliver polished, accessible user experiences with Material 3 design tokens, dynamic color palettes, and fluid card animations.',
    'Optimize memory usage and network bandwidth by implementing intelligent caching and local state invalidation policies.',
  ];

  static String _getEnglishTitle(int id) {
    final index = (id - 1) % _englishTitles.length;
    return _englishTitles[index];
  }

  static String _getEnglishBody(int id) {
    final index = (id - 1) % _englishBodies.length;
    return _englishBodies[index];
  }
}
