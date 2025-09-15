import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parking_portable/app/controllers/app_controller.dart';
import 'package:parking_portable/app/data/models/parking_ticket.dart';
import 'package:parking_portable/app/data/models/rekap_ticket.dart';
import 'package:parking_portable/app/data/services/parking_services.dart';
import 'package:parking_portable/app/widgets/app_loading.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class RekapController extends GetxController
    with StateMixin<List<ParkingTicket>> {
  final rekaped = false.obs;
  final rekap = Rx<RekapTicket?>(null);
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData({bool shouldClearState = false}) async {
    if (shouldClearState) {
      change(null, status: RxStatus.loading());
    }
    final result = await ParkingServices.getUnrekapTickets();
    if (result.success) {
      if (result.data?.isEmpty ?? true) {
        change([], status: RxStatus.empty());
      } else {
        change(result.data!, status: RxStatus.success());
      }
    } else {
      change(
        null,
        status: RxStatus.error(result.message ?? 'Terjadi Kesalahan'),
      );
    }
  }

  Future<void> rekapAndPrint() async {
    if (rekaped.value == false) {
      final confirm = await AppDialog.instance.basic(
        title: "Konfirmasi",
        description: '''
            Apakah anda ingin menutup shift ini?
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
      AppDialog.instance.loading();

      final result = await ParkingServices.rekapTickets();
      rekap.value = result.data;

      Get.back();

      if (!result.success) {
        return;
      }
      rekaped.value = true;
    }
    String enter = '\n';
    AppDialog.instance.loading();
    var kendaraan = <String, dynamic>{};
    rekap.value?.parkingTickets?.forEach((e) {
      if (kendaraan[e.vehicleType?.name ?? 'Unknown'] != null) {
        kendaraan[e.vehicleType?.name ?? 'Unknown'] += 1;
      } else {
        kendaraan[e.vehicleType?.name ?? 'Unknown'] = 1;
      }
    });
    await PrintBluetoothThermal.writeBytes(
      await parkirTicket(
        kendaraan: kendaraan,
        total: formatCurrency(rekap.value?.totalAmount),
        gate: rekap.value?.parkingGate?.name ?? 'Gate 1',
        shift: rekap.value?.shift?.name ?? 'Shift 1',
      ),
    );
    await PrintBluetoothThermal.writeBytes(enter.codeUnits);
    await PrintBluetoothThermal.disconnect;
    Get.back();
  }

  String formatDate(String? date) {
    if (date == null) return "-";
    try {
      final dt = DateTime.parse(date);
      return DateFormat("dd MMM yyyy, HH:mm").format(dt);
    } catch (e) {
      return date;
    }
  }

  String formatCurrency(num? amount) {
    if (amount == null) return "-";
    final formatter = NumberFormat.currency(locale: 'id', symbol: "Rp ");
    return formatter.format(amount);
  }

  Future<List<int>> parkirTicket({
    required Map<String, dynamic> kendaraan,
    required String total,
    String? gate = 'Gate 1',
    String? shift = 'Shift 1',
  }) async {
    final profile = await CapabilityProfile.load(); // default profile
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    // --- HEADER ---
    bytes += generator.text(
      Get.find<AppController>().user.value!.appName ?? 'KARCIS PARKIR',
      styles: PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    bytes += generator.text(
      'Tiket Parkir',
      styles: PosStyles(align: PosAlign.center, bold: true),
    );

    // --- TICKET INFO ---
    bytes += generator.text('Gate         : $gate');
    bytes += generator.text('Shift        : $shift');
    for (var element in kendaraan.keys) {
      final jumlah = kendaraan[element] ?? '0';
      bytes += generator.text('Total $element : $jumlah');
    }
    bytes += generator.text('Total Semua  : $total');

    // --- FOOTER ---
    bytes += generator.text(
      'Terima kasih sudah menggunakan layanan kami.',
      styles: PosStyles(align: PosAlign.center),
    );

    // --- CUT ---
    bytes += generator.cut();

    return bytes;
  }
}
