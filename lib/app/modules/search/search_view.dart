import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import 'search_controller.dart' as my;

class SearchView extends GetView<my.SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Finder'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.favorites),
            icon: const Icon(Icons.favorite_outline),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search GitHub users…',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => c.query.value = v,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (c.error.value != null) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(c.error.value!, textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      ElevatedButton(onPressed: c.retry, child: const Text('Retry')),
                    ],
                  ),
                );
              }
              if (c.isLoading.value && c.users.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (c.users.isEmpty) {
                return const Center(child: Text('Type to search users'));
              }
              return NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n.metrics.pixels >= n.metrics.maxScrollExtent - 120) {
                    c.loadMore();
                  }
                  return false;
                },
                child: ListView.separated(
                  itemCount: c.users.length + (c.hasMore.value ? 1 : 0),
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (_, i) {
                    if (i >= c.users.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final u = c.users[i];
                    final fav = c.favUsers.contains(u.login);
                    return ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(u.avatarUrl)),
                      title: Text(u.login),
                      subtitle: Text('#${u.id}'),
                      trailing: IconButton(
                        icon: Icon(fav ? Icons.favorite : Icons.favorite_border),
                        onPressed: () => c.toggleFav(u.login),
                      ),
                      onTap: () => Get.toNamed('${Routes.profile}/${u.login}'),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
