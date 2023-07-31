import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:search_github_repo/models/account.dart';
import 'package:search_github_repo/models/repository.dart';
import 'package:search_github_repo/views/repository_list_screen.dart';

void main() {
  group('RepositoryListScreen', () {
    group('when build screen', () {
      testWidgets('render avatar icon', (tester) async {
        mockNetworkImagesFor(() async {
          await _makeTestableWidget(tester);

          expect(find.byType(CircleAvatar), findsOneWidget);
        });
      });

      testWidgets('render widget with name', (tester) async {
        mockNetworkImagesFor(() async {
          const name = 'testname';
          await _makeTestableWidget(tester, name: name);

          expect(find.text(name), findsOneWidget);
        });
      });

      testWidgets('render search button', (tester) async {
        mockNetworkImagesFor(() async {
          await _makeTestableWidget(tester);

          expect(find.byIcon(Icons.search), findsOneWidget);
        });
      });

      testWidgets('render repository tab', (tester) async {
        mockNetworkImagesFor(() async {
          await _makeTestableWidget(tester);

          expect(find.text('REPOSITÓRIOS'), findsOneWidget);
        });
      });

      testWidgets('render starred tab', (tester) async {
        mockNetworkImagesFor(() async {
          await _makeTestableWidget(tester);

          expect(find.text('FAVORITOS'), findsOneWidget);
        });
      });

      testWidgets('render list widget', (tester) async {
        List<Repository> repositories = [];
        List<Repository> starRepositories = [];

        for (var i = 0; i < 4; i++) {
          repositories.add(Repository(
              name: 'Repository$i',
              language: 'Language$i',
              forksCount: i,
              openIssuesCount: i));
        }

        for (var i = 0; i < 4; i++) {
          starRepositories.add(Repository(
              name: 'Star$i',
              language: 'Language$i',
              forksCount: i,
              openIssuesCount: i));
        }

        mockNetworkImagesFor(() async {
          await _makeTestableWidget(
            tester,
            repositories: repositories,
            starRepositories: starRepositories,
          );

          expect(find.byType(ListView), findsOneWidget);
        });
      });
    });

    group('when no exists repositories', () {
      testWidgets('show message "Poxa! Sua lista está vazia."', (tester) async {
        mockNetworkImagesFor(() async {
          await _makeTestableWidget(tester);

          expect(find.text('Poxa! Sua lista está vazia.'), findsOneWidget);
        });
      });
    });

    group('when no exists starred repositories', () {
      testWidgets('show message "Poxa! Sua lista está vazia."', (tester) async {
        mockNetworkImagesFor(() async {
          await _makeTestableWidget(tester);

          final Finder tabStarred = find.text('FAVORITOS');
          await tester.tap(tabStarred);
          await tester.pump();

          expect(find.text('Poxa! Sua lista está vazia.'), findsOneWidget);
        });
      });
    });

    group('when exists repositories', () {
      testWidgets('show list of your repositories', (tester) async {
        List<Repository> repositories = [];

        for (var i = 0; i < 2; i++) {
          repositories.add(Repository(
              name: 'Repository$i',
              language: 'Language$i',
              forksCount: i,
              openIssuesCount: i));
        }

        mockNetworkImagesFor(() async {
          await _makeTestableWidget(tester, repositories: repositories);

          for (var element in repositories) {
            expect(find.text(element.name), findsOneWidget);
          }
        });
      });
    });

    group('when exists starred repositories', () {
      testWidgets('show list of your starred repositories', (tester) async {
        List<Repository> starRepositories = [];

        for (var i = 0; i < 2; i++) {
          starRepositories.add(Repository(
              name: 'Star$i',
              language: 'Language$i',
              forksCount: i,
              openIssuesCount: i));
        }

        mockNetworkImagesFor(() async {
          await _makeTestableWidget(tester, starRepositories: starRepositories);

          final Finder tabStarred = find.text('FAVORITOS');
          await tester.tap(tabStarred);
          await tester.pump();

          for (var element in starRepositories) {
            expect(find.text(element.name), findsOneWidget);
          }
        });
      });
    });
  });
}

Future _makeTestableWidget(
  WidgetTester tester, {
  String name = '',
  List<Repository> repositories = const [],
  List<Repository> starRepositories = const [],
}) async {
  Account account = Account(
    username: name.isEmpty ? 'myusername' : name,
    avatarUrl: 'https://avatars.githubusercontent.com/u/12244642?v=4',
    repositories: repositories,
    starRepositories: starRepositories,
  );

  await tester.pumpWidget(
    MaterialApp(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const RepositoryListScreen(),
          settings: RouteSettings(arguments: account),
        );
      },
    ),
  );
}
