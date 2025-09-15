import 'package:get/get.dart';
import 'package:parking_portable/app/modules/home/controllers/rekap_controller.dart';

import '../controllers/home_controller.dart';

class RekapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RekapController>(() => RekapController());
  }
}
