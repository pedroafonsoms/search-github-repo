import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:search_github_repo/main.dart' as app;

void main() {
  Future _fillAndSearchRepository(WidgetTester tester, String username) async {
    final searchRepositoryField =
        find.byKey(const Key('repository_search_screen-repository_field'));
    await tester.pumpAndSettle();
    await tester.tap(searchRepositoryField);
    await tester.enterText(searchRepositoryField, username);

    final searchRepositoryButton =
        find.byKey(const Key('repository_search_screen-button'));
    await tester.pumpAndSettle();
    await tester.tap(searchRepositoryButton);
    await tester.pumpAndSettle();
  }

  group('Search GitHub Repository', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    group('when repository exists', () {
      testWidgets('show informations about repository', (tester) async {
        app.main();

        const repositoryName = 'pedroafonsoms';

        await _fillAndSearchRepository(tester, repositoryName);

        final repositoriesItems =
            find.byKey(const Key('repository_item-repositórios'));
        final respositoryName =
            find.byKey(const Key('repository_list_screen-username'));

        expect(
          (respositoryName.evaluate().single.widget as Text).data,
          contains(repositoryName),
        );
        expect(repositoriesItems.evaluate().length, greaterThan(0));
      });
    });

    group('when repository not exists', () {
      testWidgets('show dialog error', (tester) async {
        app.main();

        await _fillAndSearchRepository(tester, 'nonexistrepository');

        final repositoryNotFoundDialog = find
            .byKey(const Key('repository_search_screen-repository_not_found'));

        expect(repositoryNotFoundDialog, findsOneWidget);
      });
    });
  });
}
