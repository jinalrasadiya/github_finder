class GhRepo {
  final int id;
  final String name;
  final String fullName;
  final String? description;
  final String? language;
  final int stargazersCount;
  final int forksCount;
  final String htmlUrl;

  GhRepo({
    required this.id,
    required this.name,
    required this.fullName,
    required this.stargazersCount,
    required this.forksCount,
    required this.htmlUrl,
    this.description,
    this.language,
  });

  factory GhRepo.fromJson(Map<String, dynamic> j) => GhRepo(
    id: j['id'] ?? 0,
    name: j['name'] ?? '',
    fullName: j['full_name'] ?? '',
    description: j['description'],
    language: j['language'],
    stargazersCount: j['stargazers_count'] ?? 0,
    forksCount: j['forks_count'] ?? 0,
    htmlUrl: j['html_url'] ?? '',
  );
}
