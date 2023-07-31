import 'package:flutter_test/flutter_test.dart';
import 'package:search_github_repo/models/account.dart';

void main() {
  group('Account', () {
    test('constructor', () {
      final Account account = Account(
        username: 'username',
        avatarUrl: 'http:/api.com.br/avatar',
        repositories: [],
        starRepositories: [],
      );
      expect(account, isNotNull);
    });
  });
}
