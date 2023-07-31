import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search_github_repo/models/account.dart';
import 'package:search_github_repo/repositories/github_repository.dart';

import '../../mocks/github_services_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  group('Github Services', () {
    final mockDio = MockDio();

    final account = Account(
      username: 'username',
      avatarUrl: 'https://api.com.br/avatar',
      repositories: [],
      starRepositories: [],
    );

    String getUrl(String type) {
      return type.isEmpty
          ? 'https://api.github.com/users/${account.username}'
          : 'https://api.github.com/users/${account.username}/$type';
    }

    void mockSuccess(int statusCode, dynamic data, {String type = ''}) {
      when(mockDio.get(getUrl(type))).thenAnswer((inv) => Future.value(
            Response(
                statusCode: statusCode,
                data: data,
                requestOptions: RequestOptions(path: '')),
          ));
    }

    void mockError(int statusCode, dynamic data, {String type = ''}) {
      when(mockDio.get(getUrl(type)))
          .thenThrow(DioError(requestOptions: RequestOptions(path: '')));
    }

    final GithubRepository service = GithubRepository(mockDio);

    group('#search', () {
      group('fetch a user exists', () {
        const statusCode = 200;
        final dataUser = {
          'login': account.username,
          'avatar_url': account.avatarUrl,
        };

        setUp(() async {
          mockSuccess(statusCode, dataUser);
          mockSuccess(statusCode, [], type: 'repos');
          mockSuccess(statusCode, [], type: 'starred');
        });

        test('returns a Account object', () async {
          expect(
              (await service.search('username'))?.username, account.username);
        });
      });

      group('fetch a user does not exist', () {
        const statusCode = 404;
        const data = {'message': 'Not Found'};

        setUp(() async => mockError(statusCode, data));

        test('returns a message exception', () async {
          expect(
              service.search('username'),
              throwsA(predicate(
                  (e) => e.toString().contains('Problems with user!'))));
        });
      });
    });
  });
}
