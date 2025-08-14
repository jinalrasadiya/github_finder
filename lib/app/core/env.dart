class Env {
  static const githubApiBase = 'https://api.github.com';
  static const githubToken = String.fromEnvironment('GITHUB_TOKEN', defaultValue: '');
}
