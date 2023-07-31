import 'repository.dart';

class Account {
  String username;
  String avatarUrl;
  List<Repository> repositories;
  List<Repository> starRepositories;

  Account({
    required this.username,
    required this.avatarUrl,
    required this.repositories,
    required this.starRepositories,
  });
}
