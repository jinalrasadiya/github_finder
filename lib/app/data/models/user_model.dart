class GhUser {
  final String login;
  final int id;
  final String avatarUrl;
  final String? name;
  final String? bio;
  final int? followers;
  final int? following;
  final int? publicRepos;

  GhUser({
    required this.login,
    required this.id,
    required this.avatarUrl,
    this.name,
    this.bio,
    this.followers,
    this.following,
    this.publicRepos,
  });

  factory GhUser.fromSearchJson(Map<String, dynamic> j) => GhUser(
    login: j['login'] ?? '',
    id: j['id'] ?? 0,
    avatarUrl: j['avatar_url'] ?? '',
  );

  factory GhUser.fromProfileJson(Map<String, dynamic> j) => GhUser(
    login: j['login'] ?? '',
    id: j['id'] ?? 0,
    avatarUrl: j['avatar_url'] ?? '',
    name: j['name'],
    bio: j['bio'],
    followers: j['followers'],
    following: j['following'],
    publicRepos: j['public_repos'],
  );

  Map<String, dynamic> toJson() => {
    'login': login,
    'id': id,
    'avatar_url': avatarUrl,
    'name': name,
    'bio': bio,
    'followers': followers,
    'following': following,
    'public_repos': publicRepos,
  };
}
