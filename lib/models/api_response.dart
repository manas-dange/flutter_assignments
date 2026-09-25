import 'post.dart';

enum DataSource { network, cache }

class FetchResult {
  final List<Post> posts;
  final DataSource source;
  final DateTime timestamp;
  final String? errorMessage;

  const FetchResult({
    required this.posts,
    required this.source,
    required this.timestamp,
    this.errorMessage,
  });

  bool get isFromCache => source == DataSource.cache;
  bool get isFromNetwork => source == DataSource.network;
}
