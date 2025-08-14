import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../../core/env.dart';
import '../../core/network_exceptions.dart';
import '../models/user_model.dart';
import '../models/repo_model.dart';

class GitHubApiService {
  final http.Client _client = http.Client();

  Map<String, String> get _headers => {
    'Accept': 'application/vnd.github+json',
    'X-GitHub-Api-Version': '2022-11-28',
    'User-Agent': 'github-finder-app',
    if (Env.githubToken.isNotEmpty) 'Authorization': 'Bearer ${Env.githubToken}',
  };

  Future<(List<GhUser>, int?)> searchUsers({
    required String query,
    int page = 1,
    int perPage = 20,
  }) async {
    final uri = Uri.parse(
      '${Env.githubApiBase}/search/users?q=$query&page=$page&per_page=$perPage',
    );
    final res = await _client.get(uri, headers: _headers);
    if (res.statusCode != 200) {
      throw NetworkException('Search failed', statusCode: res.statusCode);
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final items = (map['items'] as List).cast<Map<String, dynamic>>();
    final users = items.map(GhUser.fromSearchJson).toList();
    final totalCount = map['total_count'] as int?;
    return (users, totalCount);
  }

  Future<GhUser> fetchUser(String username) async {
    final uri = Uri.parse('${Env.githubApiBase}/users/$username');
    final res = await _client.get(uri, headers: _headers);
    if (res.statusCode != 200) {
      throw NetworkException('User fetch failed', statusCode: res.statusCode);
    }
    return GhUser.fromProfileJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<List<GhRepo>> fetchRepos(String username,
      {int page = 1, int perPage = 20}) async {
    final uri = Uri.parse(
        '${Env.githubApiBase}/users/$username/repos?sort=updated&page=$page&per_page=$perPage');
    final res = await _client.get(uri, headers: _headers);
    if (res.statusCode != 200) {
      throw NetworkException('Repos fetch failed', statusCode: res.statusCode);
    }
    final list = (jsonDecode(res.body) as List).cast<Map<String, dynamic>>();
    return list.map(GhRepo.fromJson).toList();
  }
}
