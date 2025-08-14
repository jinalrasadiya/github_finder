import 'package:get/get.dart';
import '../data/services/github_api_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GitHubApiService>(GitHubApiService(), permanent: true);
  }
}
