import 'package:get/get.dart';
import '../../data/services/github_api_service.dart';
import 'profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController(Get.find<GitHubApiService>()));
  }
}
