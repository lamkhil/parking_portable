import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parking_portable/app/data/models/parking_ticket.dart';
import 'package:parking_portable/app/widgets/app_loading.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class DetailPageController extends GetxController {
  final ParkingTicket ticket = Get.arguments;

  Future<void> print() async {
    AppDialog.instance.loading();

    String enter = '\n';
    await PrintBluetoothThermal.writeBytes(
      await parkirTicket(
        noTicket: ticket.ticketNumber ?? '-',
        plat: ticket.vehiclePlateNumber ?? '-',
        masuk: formatDate(ticket.createdAt),
        tarif: formatCurrency(ticket.amount),
        gate: ticket.parkingGateIn?.name,
        kendaraan: ticket.vehicleType?.name ?? '-',
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
    required String noTicket,
    required String plat,
    required String masuk,
    required String tarif,
    required String kendaraan,
    String? gate = 'Gate 1',
  }) async {
    final profile = await CapabilityProfile.load(); // default profile
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    // --- HEADER ---
    bytes += generator.text(
      'PARKIR PORTABLE',
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
    bytes += generator.text('No Tiket : $noTicket');
    bytes += generator.text('Plat     : $plat');
    bytes += generator.text('Gate     : $gate');
    bytes += generator.text('Tarif    : $tarif');
    bytes += generator.text('Kendaraan: $kendaraan');
    bytes += generator.text(
      'Masuk    : ${masuk.toString().split('.')[0].replaceAll('T', " ")}',
    );

    // --- BARCODE ---
    bytes += generator.barcode(
      Barcode.code128(noTicket.split('')),
      width: 2,
      height: 80,
    );

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
