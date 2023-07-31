class Repository {
  String name;
  String language;
  int forksCount;
  int openIssuesCount;

  Repository({
    required this.name,
    required this.language,
    required this.forksCount,
    required this.openIssuesCount,
  });
}
