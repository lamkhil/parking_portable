import 'package:get/get.dart';
import 'package:parking_portable/app/controllers/app_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AppController>(AppController());
  }
}
