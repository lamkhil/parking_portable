import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_portable/app/modules/home/views/tabs/home_page.dart';
import 'package:parking_portable/app/modules/home/views/tabs/history_page.dart';
import 'package:parking_portable/app/modules/home/views/tabs/rekap_page.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: [
          HomePage(),
          RekapPage(),
          HistoryPage(),
        ][controller.pageView.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.pageView.value,
          onTap: (index) {
            controller.pageView.value = index;
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.note_add_outlined),
              label: "Rekap",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: "Riwayat",
            ),
          ],
        ),
      ),
    );
  }
}
