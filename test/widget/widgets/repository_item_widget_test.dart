import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search_github_repo/models/repository.dart';
import 'package:search_github_repo/widgets/repository_item_widget.dart';

void main() {
  group('RepositoryItem', () {
    final Repository repository = Repository(
      name: 'Repositório Dart',
      language: 'Dart',
      forksCount: 4,
      openIssuesCount: 4,
    );

    testWidgets('create starred widget successfully', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RepositoryItem(repository, 'STAR'),
          ),
        ),
      );

      final icon = find.byIcon(Icons.star_border);
      final repositoryNameFinder = find.text(repository.name);
      final languageFinder = find.text(repository.language);

      expect(repositoryNameFinder, findsOneWidget);
      expect(languageFinder, findsOneWidget);
      expect(icon, findsOneWidget);
    });

    testWidgets('create repos widget successfully', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RepositoryItem(repository, 'REPOSITÓRIOS'),
          ),
        ),
      );

      final icon = find.byIcon(Icons.check_circle_outlined);
      final repositoryNameFinder = find.text(repository.name);
      final languageFinder = find.text(repository.language);

      expect(repositoryNameFinder, findsOneWidget);
      expect(languageFinder, findsOneWidget);
      expect(icon, findsOneWidget);
    });
  });
}
