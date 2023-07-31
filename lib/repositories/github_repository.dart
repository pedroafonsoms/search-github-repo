import 'package:dio/dio.dart';
import 'package:search_github_repo/models/repository.dart';

import '../models/account.dart';

class GithubRepository {
  Dio? _dio;

  GithubRepository([Dio? dio]) {
    _dio = dio ?? Dio();
  }

  Future<Account?> search(String name) async {
    try {
      final response = await _dio?.get('https://api.github.com/users/$name');

      if (response?.statusCode == 200) {
        return Account(
          username: response?.data['login'],
          avatarUrl: response?.data['avatar_url'],
          repositories: await _getOwnRepositories(response?.data['login']),
          starRepositories: await _getStarRepositories(response?.data['login']),
        );
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Repository not found!');
      } else {
        throw Exception('Problems with user! Message: ${e.message}');
      }
    }
  }

  Future<List<Repository>> _getOwnRepositories(String username) async {
    return await _getRepositories(username, 'repos');
  }

  Future<List<Repository>> _getStarRepositories(String username) async {
    return await _getRepositories(username, 'starred');
  }

  Future<List<Repository>> _getRepositories(
      String username, String type) async {
    try {
      final response =
          await _dio?.get('https://api.github.com/users/$username/$type');
      List<dynamic> data = response?.data;

      List<Repository> repositories = data.map((repo) {
        return Repository(
          name: repo['name'],
          language: repo['language'] ?? 'N/A',
          forksCount: repo['forks_count'],
          openIssuesCount: repo['open_issues_count'],
        );
      }).toList();

      return repositories;
    } on DioError catch (e) {
      throw Exception('Problems with $type! Message: ${e.message}');
    }
  }
}
