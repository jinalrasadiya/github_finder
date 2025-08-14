import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/models/user_model.dart';
import '../../data/services/github_api_service.dart';
import '../../utils/debouncer.dart';

class SearchController extends GetxController {
  final GitHubApiService api;
  SearchController(this.api);

  final query = ''.obs;
  final users = <GhUser>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  final page = 1.obs;
  final total = RxnInt();
  final hasMore = false.obs;
  final _debouncer = Debouncer(milliseconds: 500);

  final _box = GetStorage();
  final favUsers = <String>{}.obs; // store by login

  static const _favUsersKey = 'fav_users';

  @override
  void onInit() {
    super.onInit();
    favUsers.addAll((_box.read<List>('$_favUsersKey')?.cast<String>()) ?? const []);
    ever(query, (_) => _debouncer(_searchFresh));
  }

  void toggleFav(String login) {
    if (favUsers.contains(login)) {
      favUsers.remove(login);
    } else {
      favUsers.add(login);
    }
    _box.write(_favUsersKey, favUsers.toList());
  }

  Future<void> _searchFresh() async {
    final q = query.value.trim();
    if (q.isEmpty) {
      users.clear();
      total.value = null;
      hasMore.value = false;
      return;
    }
    page.value = 1;
    users.clear();
    await _fetch();
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) return;
    page.value++;
    await _fetch(append: true);
  }

  Future<void> retry() async => _fetch();

  Future<void> _fetch({bool append = false}) async {
    try {
      isLoading.value = true;
      error.value = null;
      final (list, totalCount) =
      await api.searchUsers(query: query.value, page: page.value);
      total.value = totalCount;
      hasMore.value = (users.length + list.length) < (totalCount ?? 0);
      if (append) {
        users.addAll(list);
      } else {
        users.assignAll(list);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
