import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/models/repo_model.dart';
import '../../data/services/github_api_service.dart';

class ProfileController extends GetxController {
  final GitHubApiService api;
  ProfileController(this.api);

  final username = ''.obs;
  final user = Rxn<GhUser>();
  final repos = <GhRepo>[].obs;
  final isLoadingUser = false.obs;
  final isLoadingRepos = false.obs;
  final errorUser = RxnString();
  final errorRepos = RxnString();
  final repoPage = 1.obs;
  final hasMoreRepos = false.obs;

  @override
  void onInit() {
    super.onInit();
    username.value = Get.parameters['username'] ?? '';
    _load();
  }

  Future<void> _load() async {
    await Future.wait([fetchUser(), fetchRepos()]);
  }

  Future<void> fetchUser() async {
    try {
      isLoadingUser.value = true;
      errorUser.value = null;
      user.value = await api.fetchUser(username.value);
    } catch (e) {
      errorUser.value = e.toString();
    } finally {
      isLoadingUser.value = false;
    }
  }

  Future<void> fetchRepos({bool loadMore = false}) async {
    if (loadMore) repoPage.value++;
    try {
      isLoadingRepos.value = true;
      errorRepos.value = null;
      final list = await api.fetchRepos(username.value, page: repoPage.value);
      if (loadMore) {
        repos.addAll(list);
      } else {
        repos.assignAll(list);
      }
      hasMoreRepos.value = list.length >= 20; // heuristic
    } catch (e) {
      errorRepos.value = e.toString();
    } finally {
      isLoadingRepos.value = false;
    }
  }
}
