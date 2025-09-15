import 'package:get/get.dart';

import '../controllers/rekap_detail_controller.dart';

class RekapDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RekapDetailController>(
      () => RekapDetailController(),
    );
  }
}
