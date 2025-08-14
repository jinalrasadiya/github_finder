import 'package:get/get.dart';
import '../../data/services/github_api_service.dart';
import 'search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchController(Get.find<GitHubApiService>()));
  }
}
