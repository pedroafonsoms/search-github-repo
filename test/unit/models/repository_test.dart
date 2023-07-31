import 'package:flutter_test/flutter_test.dart';
import 'package:search_github_repo/models/repository.dart';

void main() {
  group('Repository', () {
    test('constructor', () {
      final Repository repository = Repository(
        name: 'repository',
        language: 'language',
        forksCount: 10,
        openIssuesCount: 1,
      );
      expect(repository, isNotNull);
    });
  });
}
