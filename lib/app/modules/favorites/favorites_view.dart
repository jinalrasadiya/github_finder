import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../favorites/favorites_controller.dart';
import '../../routes/app_routes.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Obx(() {
        final list = controller.favUsers;
        if (list.isEmpty) {
          return const Center(child: Text('No favorite users yet'));
        }
        return ListView.separated(
          itemCount: list.length,
          separatorBuilder: (_, __) => const Divider(height: 0),
          itemBuilder: (_, i) {
            final login = list[i];
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(login),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => controller.remove(login),
              ),
              onTap: () => Get.toNamed('${Routes.profile}/$login'),
            );
          },
        );
      }),
    );
  }
}
