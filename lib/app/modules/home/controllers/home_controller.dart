import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:parking_portable/app/controllers/app_controller.dart';
import 'package:parking_portable/app/data/models/user.dart';
import 'package:parking_portable/app/data/models/vehicle_type.dart';
import 'package:parking_portable/app/data/services/authenticate_services.dart';
import 'package:parking_portable/app/data/services/parking_services.dart';
import 'package:parking_portable/app/routes/app_pages.dart';
import 'package:parking_portable/app/widgets/app_loading.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class HomeController extends GetxController with StateMixin<List<VehicleType>> {
  TextEditingController vehicleNumber = TextEditingController();

  final Rx<bool?> bluetoothOn = Rx(null);
  final Rx<BluetoothInfo?> device = Rx(null);
  final Rx<bool?> connectDevice = Rx(null);
  final Rx<File?> imageFile = Rx(null);
  final ImagePicker _picker = ImagePicker();
  final paymentMethod = 'cash'.obs;

  Future<void> pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  final selectedVehicle = 0.obs;
  final app = Get.find<AppController>();

  @override
  void onInit() {
    refreshData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    vehicleNumber.dispose();
    super.onClose();
  }

  void refreshData() {
    loadProfile();
    getVehicleType();
    checkPrinter();
  }

  Future<void> checkPrinter() async {
    bluetoothOn.value = await PrintBluetoothThermal.bluetoothEnabled;
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;
    final BluetoothInfo? selectedDevice = listResult
        .where((e) => e.name.toLowerCase().contains("bluetoothprinter") == true)
        .firstOrNull;
    device.value = selectedDevice;
    final isConnected = await PrintBluetoothThermal.connectionStatus;
    connectDevice.value = isConnected;
    if (selectedDevice != null && isConnected == false) {
      final bool result = await PrintBluetoothThermal.connect(
        macPrinterAddress: selectedDevice.macAdress,
      );
      connectDevice.value = result;
    }
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

  Future<void> loadProfile() async {
    final result = await AuthenticateServices.me();
    if (result.success) {
      app.user.value = result.data;
    }
  }

  Future<void> save() async {
    if (vehicleNumber.text.isEmpty) {
      AppDialog.instance.basic(
        title: "Oops!",
        description: "Plat nomor belum diisi",
      );
      return;
    }
    if (bluetoothOn.value != true) {
      AppDialog.instance.basic(
        title: "Oops!",
        description: "Printer Belum Terhubung",
      );
      return;
    }
    if (!(await PrintBluetoothThermal.connectionStatus)) {
      AppDialog.instance.basic(
        title: "Oops!",
        description: "Printer Belum Terhubung",
      );
      return;
    }
    final confirm = await AppDialog.instance.basic(
      title: "Konfirmasi",
      description:
          '''
Apakah data sudah benar?
Plat Nomor: ${vehicleNumber.text}
Tipe Kendaraan: ${state![selectedVehicle.value].name}
Metode Pembayaran: ${paymentMethod.value == 'cash' ? 'Tunai' : 'QRIS'}
Tarif: ${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(state![selectedVehicle.value].parkingRateRules?.firstOrNull?.fixedPrice ?? 0)}
''',
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back(result: false);
          },
          child: Text("Tidak"),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back(result: true);
          },
          child: Text("Iya"),
        ),
      ],
    );
    if (confirm != true) {
      return;
    }
    final result = await ParkingServices.entryAndExit(
      ticketNumber: generateTicketNumber(
        app.user.value!.parkingGate!.id!.toString(),
      ),
      vehiclePlateNumber: vehicleNumber.text,
      vehicleTypeId: state![selectedVehicle.value].id!,
      paymentMethod: paymentMethod.value,
    );

    if (result.success == false) {
      AppDialog.instance.basic(
        title: "Oops!",
        description: result.message ?? 'Terjadi Kesalahan',
      );
      return;
    }
    imageFile.value = null;
    vehicleNumber.clear();

    Get.toNamed(Routes.DETAIL_PAGE, arguments: result.data);
  }

  String generateTicketNumber(String gateName) {
    final now = DateTime.now();
    final formatted = DateFormat("yyyyMMddHHmmss").format(now);
    // hasil: 20250910223045 (tahun + bulan + tanggal + jam + menit + detik)

    return "$gateName$formatted";
  }
}
