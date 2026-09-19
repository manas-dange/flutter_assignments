import 'package:flutter/material.dart';

import 'models/api_response.dart';
import 'models/post.dart';
import 'services/post_repository.dart';

void main() {
  runApp(const ApiDataFetcherApp());
}

class ApiDataFetcherApp extends StatelessWidget {
  final PostRepository? repository;

  const ApiDataFetcherApp({super.key, this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REST API & Local Cache',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: PostsScreen(repository: repository),
    );
  }
}

class PostsScreen extends StatefulWidget {
  final PostRepository? repository;

  const PostsScreen({super.key, this.repository});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late final PostRepository _repository;
  late Future<FetchResult> _postsFuture;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? PostRepository();
    _postsFuture = _repository.fetchPosts();
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _postsFuture = _repository.fetchPosts();
    });
  }

  Future<void> _clearCache() async {
    await _repository.clearCache();
    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Local SharedPreferences cache cleared!'),
        backgroundColor: Colors.teal,
        duration: Duration(seconds: 2),
      ),
    );

    // Refresh state to reflect cache status
    setState(() {});
  }

  void _showPostDetailModal(Post post) {
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Post #${post.id} (User ${post.userId})',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(sheetContext),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  post.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                Text(
                  post.body,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: const Center(child: Text('Close')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('API Posts & Local Cache'),
        centerTitle: true,
        actions: [
          IconButton(
            key: const Key('refresh_appbar_button'),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh from API',
            onPressed: _refreshPosts,
          ),
          IconButton(
            key: const Key('clear_cache_button'),
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear Local Cache',
            onPressed: _clearCache,
          ),
        ],
      ),
      body: FutureBuilder<FetchResult>(
        key: const Key('posts_future_builder'),
        future: _postsFuture,
        builder: (context, snapshot) {
          // 1. ConnectionState.waiting: Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    key: Key('loading_indicator'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Fetching posts from REST API...',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Checking cache fallback in SharedPreferences',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            );
          }

          // 2. Error state
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_off_rounded,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to Load Data',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString().replaceAll('Exception: ', ''),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      key: const Key('retry_button'),
                      onPressed: _refreshPosts,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry Fetch'),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. Success state (Data retrieved from network or local cache)
          if (snapshot.hasData) {
            final result = snapshot.data!;
            final posts = result.posts;
            final isFromNetwork = result.isFromNetwork;
            final formattedTime =
                '${result.timestamp.hour.toString().padLeft(2, '0')}:${result.timestamp.minute.toString().padLeft(2, '0')}:${result.timestamp.second.toString().padLeft(2, '0')}';

            return RefreshIndicator(
              key: const Key('posts_refresh_indicator'),
              onRefresh: _refreshPosts,
              child: Column(
                children: [
                  // Cache & Network Status Header Card
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Card(
                      key: const Key('status_banner_card'),
                      elevation: 0,
                      color: isFromNetwork
                          ? Colors.green.withValues(alpha: 0.12)
                          : Colors.amber.withValues(alpha: 0.15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isFromNetwork
                              ? Colors.green.withValues(alpha: 0.4)
                              : Colors.amber.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isFromNetwork
                                      ? Icons.wifi_rounded
                                      : Icons.storage_rounded,
                                  color: isFromNetwork
                                      ? Colors.green.shade800
                                      : Colors.amber.shade900,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isFromNetwork
                                            ? 'Live Network Data'
                                            : 'Cached Data (SharedPreferences)',
                                        key: const Key('data_source_badge'),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isFromNetwork
                                              ? Colors.green.shade900
                                              : Colors.amber.shade900,
                                        ),
                                      ),
                                      Text(
                                        isFromNetwork
                                            ? 'Synced & cached to SharedPreferences'
                                            : 'Offline fallback • Last synced at $formattedTime',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: theme.colorScheme.outlineVariant,
                                    ),
                                  ),
                                  child: Text(
                                    '${posts.length} items',
                                    key: const Key('posts_count_badge'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (result.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      size: 14,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        result.errorMessage!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.brown,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Posts List or Empty State
                  Expanded(
                    child: posts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 64,
                                  color: theme.colorScheme.outline,
                                ),
                                const SizedBox(height: 12),
                                const Text('No posts found.'),
                              ],
                            ),
                          )
                        : ListView.separated(
                            key: const Key('posts_list_view'),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            itemCount: posts.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final post = posts[index];
                              return Card(
                                key: Key('post_card_${post.id}'),
                                elevation: 0,
                                color: theme.colorScheme.surface,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: BorderSide(
                                    color: theme.colorScheme.outlineVariant
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () => _showPostDetailModal(post),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // ID Badge
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor: theme
                                              .colorScheme
                                              .primaryContainer,
                                          foregroundColor: theme
                                              .colorScheme
                                              .onPrimaryContainer,
                                          child: Text(
                                            '${post.id}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),

                                        // Title and Body excerpt
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                post.title,
                                                style: theme
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                post.body,
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: theme
                                                          .colorScheme
                                                          .onSurfaceVariant,
                                                    ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.chevron_right,
                                          color: theme.colorScheme.outline,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }

          // Fallback state
          return const Center(child: Text('Unexpected state.'));
        },
      ),
    );
  }
}
