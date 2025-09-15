import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parking_portable/app/modules/home/controllers/rekap_controller.dart';
import 'package:parking_portable/app/data/models/parking_ticket.dart';
import 'package:shimmer/shimmer.dart';

class RekapPage extends GetView<RekapController> {
  const RekapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rekap Parkir"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.getData(shouldClearState: true),
          ),
        ],
      ),
      body: controller.obx(
        // ✅ sukses: tampilkan list
        (List<ParkingTicket>? state) {
          return RefreshIndicator(
            onRefresh: controller.getData,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state?.length ?? 0,
                    itemBuilder: (context, index) {
                      final ticket = state![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          title: Text(
                            "#${ticket.ticketNumber}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Kendaraan  : ${ticket.vehicleType?.name}\n"
                            "Waktu          : ${ticket.createdAt?.split('.').firstOrNull?.replaceAll('T', ' ') ?? '-'}",
                          ),
                          trailing: Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp ',
                              decimalDigits: 0,
                            ).format(ticket.amount),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                if (state != null && state.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: const Border(
                        top: BorderSide(color: Colors.black12),
                      ),
                    ),
                    child: Builder(
                      builder: (_) {
                        final totalMobil = state
                            .where((t) => t.vehicleType?.name == "Mobil")
                            .length;
                        final totalMotor = state
                            .where((t) => t.vehicleType?.name == "Motor")
                            .length;
                        final totalPendapatan = state.fold<int>(
                          0,
                          (sum, t) => sum + (t.amount ?? 0),
                        );

                        return SizedBox(
                          width: Get.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Mobil",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "$totalMobil",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const Divider(height: 20, thickness: 1),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Motor",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "$totalMotor",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const Divider(height: 20, thickness: 1),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total Pendapatan",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp ',
                                      decimalDigits: 0,
                                    ).format(totalPendapatan),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 20, thickness: 1),
                              ElevatedButton(
                                onPressed: () {
                                  controller.rekapAndPrint();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.print),
                                    const SizedBox(width: 8),
                                    Obx(
                                      () => Text(
                                        controller.rekaped.value
                                            ? "Cetak Laporan"
                                            : "Rekap & Cetak Laporan",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },

        // ✅ loading → pakai shimmer
        onLoading: ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Container(height: 16, width: 120, color: Colors.white),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        height: 14,
                        width: 180,
                        color: Colors.white,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        height: 14,
                        width: 100,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  trailing: Container(
                    height: 16,
                    width: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),

        // ✅ empty
        onEmpty: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inbox, size: 64, color: Colors.grey),
              const SizedBox(height: 12),
              const Text("Belum ada data tiket untuk direkap."),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text("Muat Ulang"),
                onPressed: () => controller.getData(shouldClearState: true),
              ),
            ],
          ),
        ),

        // ✅ error
        onError: (error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.redAccent),
              const SizedBox(height: 12),
              Text(error ?? "Terjadi kesalahan."),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text("Coba Lagi"),
                onPressed: () => controller.getData(shouldClearState: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
