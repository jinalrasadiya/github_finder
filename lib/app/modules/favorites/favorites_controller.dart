import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FavoritesController extends GetxController {
  final _box = GetStorage();
  final favUsers = <String>[].obs;

  static const _favUsersKey = 'fav_users';

  @override
  void onInit() {
    super.onInit();
    favUsers.assignAll((_box.read<List>('$_favUsersKey')?.cast<String>()) ?? const []);
    ever(favUsers, (_) => _box.write(_favUsersKey, favUsers.toList()));
  }

  void remove(String login) => favUsers.remove(login);
}
