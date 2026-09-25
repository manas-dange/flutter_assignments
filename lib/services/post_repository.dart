import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/api_response.dart';
import '../models/post.dart';

class PostRepository {
  static const String endpoint = 'https://jsonplaceholder.typicode.com/posts';
  static const String cacheKey = 'cached_posts_json';
  static const String cacheTimestampKey = 'cached_posts_timestamp';

  final http.Client _client;
  SharedPreferences? prefs;

  PostRepository({http.Client? client, this.prefs})
    : _client = client ?? http.Client();

  Future<SharedPreferences> _getPrefs() async {
    prefs ??= await SharedPreferences.getInstance();
    return prefs!;
  }

  // Fetch posts from REST API, saving to SharedPreferences, with offline fallback
  Future<FetchResult> fetchPosts({bool forceNetworkOnly = false}) async {
    final prefs = await _getPrefs();

    try {
      final response = await _client
          .get(Uri.parse(endpoint), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> decodedList =
            jsonDecode(response.body) as List<dynamic>;
        final posts = decodedList
            .map((item) => Post.fromJson(item as Map<String, dynamic>))
            .toList();

        final now = DateTime.now();
        // Cache the raw JSON payload and timestamp into SharedPreferences
        await prefs.setString(cacheKey, response.body);
        await prefs.setString(cacheTimestampKey, now.toIso8601String());

        return FetchResult(
          posts: posts,
          source: DataSource.network,
          timestamp: now,
        );
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      if (forceNetworkOnly) {
        rethrow;
      }

      // Offline fallback: Check SharedPreferences for previously cached response
      final cachedResult = await getCachedResult();
      if (cachedResult != null) {
        return FetchResult(
          posts: cachedResult.posts,
          source: DataSource.cache,
          timestamp: cachedResult.timestamp,
          errorMessage:
              'Offline fallback: ${e.toString().replaceAll('Exception: ', '')}',
        );
      }

      // No network and no cache available
      throw Exception(
        'Unable to fetch posts from REST API and no local cache was found.\n'
        'Check your connection and try again.',
      );
    }
  }

  // Read cached posts from SharedPreferences
  Future<FetchResult?> getCachedResult() async {
    final prefs = await _getPrefs();
    final cachedJson = prefs.getString(cacheKey);
    final cachedTimestampStr = prefs.getString(cacheTimestampKey);

    if (cachedJson == null || cachedJson.isEmpty) {
      return null;
    }

    try {
      final List<dynamic> decodedList = jsonDecode(cachedJson) as List<dynamic>;
      final posts = decodedList
          .map((item) => Post.fromJson(item as Map<String, dynamic>))
          .toList();

      final timestamp = cachedTimestampStr != null
          ? DateTime.tryParse(cachedTimestampStr) ?? DateTime.now()
          : DateTime.now();

      return FetchResult(
        posts: posts,
        source: DataSource.cache,
        timestamp: timestamp,
      );
    } catch (_) {
      return null;
    }
  }

  // Clear local SharedPreferences cache
  Future<void> clearCache() async {
    final prefs = await _getPrefs();
    await prefs.remove(cacheKey);
    await prefs.remove(cacheTimestampKey);
  }

  // Check if cache exists
  Future<bool> hasCachedData() async {
    final prefs = await _getPrefs();
    final cachedJson = prefs.getString(cacheKey);
    return cachedJson != null && cachedJson.isNotEmpty;
  }
}
