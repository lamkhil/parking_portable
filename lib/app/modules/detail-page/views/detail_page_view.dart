import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parking_portable/app/routes/app_pages.dart';
import 'package:parking_portable/app/widgets/app_loading.dart';

import '../controllers/detail_page_controller.dart';

class DetailPageView extends GetView<DetailPageController> {
  const DetailPageView({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Ticket")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "No Ticket : ${controller.ticket.ticketNumber}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Plat Nomor: ${controller.ticket.vehiclePlateNumber}"),
                  Text(
                    "Jenis Kendaraan: ${controller.ticket.vehicleType?.name}",
                  ),
                  Text("Gate: ${controller.ticket.parkingGateIn?.name}"),
                  const Divider(height: 24),
                  Text("Shift: ${controller.ticket.shift?.name}"),
                  Text(
                    "Jam Shift: ${controller.ticket.shift?.startTime} - ${controller.ticket.shift?.endTime}",
                  ),
                  const Divider(height: 24),
                  Text("Waktu: ${formatDate(controller.ticket.createdAt)}"),
                  const Divider(height: 24),
                  Text("Metode Bayar: ${controller.ticket.paymentMethod}"),
                  Text("Tarif: ${formatCurrency(controller.ticket.amount)}"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () {
              controller.print();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Print")],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final result = await AppDialog.instance.basic(
                title: "Konfirmasi",
                description: "Apakah anda yakin untuk kembali?",
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
              if (result == true) {
                Get.back();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Kembali")],
            ),
          ),
        ],
      ),
    );
  }
}
