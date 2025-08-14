import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../utils/formatters.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      appBar: AppBar(title: Obx(() => Text(c.username.value))),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            await c.fetchUser();
            c.repoPage.value = 1;
            await c.fetchRepos();
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (c.errorUser.value != null)
                Column(
                  children: [
                    Text(c.errorUser.value!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                    ElevatedButton(onPressed: c.fetchUser, child: const Text('Retry')),
                  ],
                )
              else if (c.isLoadingUser.value && c.user.value == null)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (c.user.value != null)
                  const _UserHeader(),

              const SizedBox(height: 16),
              const Text('Repositories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              if (c.errorRepos.value != null)
                Column(
                  children: [
                    Text(c.errorRepos.value!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                        onPressed: () => c.fetchRepos(), child: const Text('Retry')),
                  ],
                )
              else if (c.repos.isEmpty && c.isLoadingRepos.value)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (c.repos.isEmpty)
                  const Text('No repositories found'),
              ...c.repos.map(
                    (r) => Card(
                  child: ListTile(
                    title: Text(r.name),
                    subtitle: Text(r.description ?? 'No description'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('★ ${compactNumber(r.stargazersCount)}'),
                        Text('⑂ ${compactNumber(r.forksCount)}'),
                      ],
                    ),
                    onTap: () =>
                        launchUrlString(r.htmlUrl, mode: LaunchMode.externalApplication),
                  ),
                ),
              ),
              if (c.hasMoreRepos.value)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: c.isLoadingRepos.value
                        ? const CircularProgressIndicator()
                        : OutlinedButton(
                      onPressed: () => c.fetchRepos(loadMore: true),
                      child: const Text('Load more'),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _UserHeader extends GetView<ProfileController> {
  const _UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final u = controller.user.value!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 36, backgroundImage: NetworkImage(u.avatarUrl)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(u.name ?? u.login,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              if (u.bio != null) Text(u.bio!),
              const SizedBox(height: 8),
              Wrap(spacing: 12, children: [
                Text('Followers: ${compactNumber(u.followers)}'),
                Text('Following: ${compactNumber(u.following)}'),
                Text('Repos: ${compactNumber(u.publicRepos)}'),
              ]),
            ],
          ),
        )
      ],
    );
  }
}
