import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parking_portable/app/data/models/rekap_ticket.dart';
import 'package:parking_portable/app/modules/home/controllers/history_controller.dart';
import 'package:parking_portable/app/routes/app_pages.dart';
import 'package:shimmer/shimmer.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rekap Ticket")),
      body: controller.obx(
        (state) {
          if (state == null || state.isEmpty) {
            return _buildEmpty();
          }

          return RefreshIndicator(
            onRefresh: controller.getData,
            child: ListView.builder(
              controller: controller.scrollController,
              itemCount: state.length,
              itemBuilder: (context, index) {
                RekapTicket item = state[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    onTap: () {
                      Get.toNamed(Routes.REKAP_DETAIL, arguments: item);
                    },
                    leading: const Icon(Icons.receipt_long, color: Colors.blue),
                    title: Text(
                      "Petugas: ${item.user?.name ?? '-'}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Shift: ${item.shift?.name ?? '-'}"),
                        Text("Gate: ${item.parkingGate?.name ?? '-'}"),
                        Text(
                          "Jumlah Ticket: ${item.parkingTickets?.length ?? 0}",
                        ),
                        Text(
                          "Total: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(item.totalAmount ?? 0)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      item.createdAt != null
                          ? DateFormat(
                              "dd/MM/yyyy",
                            ).format(DateTime.parse(item.createdAt!))
                          : "-",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          );
        },
        onLoading: _buildShimmer(),
        onEmpty: _buildEmpty(),
        onError: (err) => _buildError(err),
      ),
    );
  }

  /// Shimmer loading UI
  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Container(width: 40, height: 40, color: Colors.white),
              title: Container(
                width: double.infinity,
                height: 14,
                color: Colors.white,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Container(width: 150, height: 12, color: Colors.white),
                  const SizedBox(height: 6),
                  Container(width: 100, height: 12, color: Colors.white),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Tampilan ketika data kosong
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Data kosong"),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: controller.getData,
            icon: const Icon(Icons.refresh),
            label: const Text("Refresh"),
          ),
        ],
      ),
    );
  }

  /// Tampilan ketika error
  Widget _buildError(String? err) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Terjadi kesalahan: $err"),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: controller.getData,
            icon: const Icon(Icons.refresh),
            label: const Text("Coba Lagi"),
          ),
        ],
      ),
    );
  }
}
