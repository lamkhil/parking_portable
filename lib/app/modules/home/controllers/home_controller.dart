import 'package:flutter/src/widgets/editable_text.dart';
import 'package:get/get.dart';
import 'package:parking_portable/app/data/models/vehicle_type.dart';
import 'package:parking_portable/app/data/services/parking_services.dart';
import 'package:parking_portable/app/widgets/app_loading.dart';

class HomeController extends GetxController with StateMixin<List<VehicleType>> {
  final RxList<VehicleType> vehicleType = <VehicleType>[].obs;

  TextEditingController vehicleNumber = TextEditingController();
  @override
  void onInit() {
    getVehicleType();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getVehicleType() async {
    change([], status: RxStatus.loading());
    final result = await ParkingServices.getVehicleType();
    if (!result.success) {
      change(null, status: RxStatus.error(result.message));
      return;
    }
    if (result.data?.isEmpty ?? true) {
      change([], status: RxStatus.empty());
      return;
    }
    change(result.data, status: RxStatus.success());
  }
}
