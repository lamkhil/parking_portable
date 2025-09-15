import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:parking_portable/app/modules/home/controllers/home_controller.dart';
import 'package:parking_portable/app/routes/app_pages.dart';
import 'package:parking_portable/app/widgets/app_loading.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: controller.obx(
        (state) => Container(
          padding: const EdgeInsets.all(16.0),
          width: Get.width,
          height: Get.height,
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    controller.refreshData();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() {
                          return ListTile(
                            leading: const Icon(
                              Icons.person,
                              color: Colors.blue,
                              size: 54,
                            ),
                            title: Text(
                              controller.app.user.value?.name ?? '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Shift ${controller.app.user.value?.shift?.name}: ${controller.app.user.value?.shift?.startTime} - ${controller.app.user.value?.shift?.endTime}\nGate: ${controller.app.user.value?.parkingGate?.name}",
                            ),
                            isThreeLine: true,
                            trailing: IconButton(
                              onPressed: () async {
                                final result = await AppDialog.instance.basic(
                                  title: "Konfirmasi",
                                  description:
                                      "Apakah anda yakin untuk logout?",
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
                                  GetStorage().erase();
                                  Get.offAllNamed(Routes.LOGIN);
                                }
                              },
                              icon: Icon(Icons.logout, color: Colors.red),
                            ),
                          );
                        }),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Obx(() {
                            // Jika Bluetooth belum menyala
                            if (controller.bluetoothOn.value != true) {
                              return Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                      Icons.bluetooth_disabled,
                                      color: Colors.red,
                                    ),
                                    title: const Text("Bluetooth mati"),
                                    subtitle: const Text(
                                      "Nyalakan Bluetooth terlebih dahulu di pengaturan",
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      controller.checkPrinter();
                                    },
                                    icon: Icon(Icons.refresh),
                                  ),
                                ],
                              );
                            }

                            // Jika Bluetooth menyala tapi device belum dipilih
                            if (controller.device.value == null) {
                              return ListTile(
                                leading: const Icon(
                                  Icons.print,
                                  color: Colors.orange,
                                ),
                                title: const Text("Printer belum ditautkan"),
                                subtitle: const Text(
                                  "Tautkan printer terlebih dahulu di pengaturan bluetooth",
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    controller.checkPrinter();
                                  },
                                  icon: Icon(Icons.refresh),
                                ),
                              );
                            }

                            // Jika device sudah ada tapi belum terhubung
                            if (controller.connectDevice.value != true) {
                              return ListTile(
                                leading: const Icon(
                                  Icons.bluetooth_searching,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  "Printer: ${controller.device.value!.name}",
                                ),
                                subtitle: const Text("Belum terhubung"),
                                trailing: ElevatedButton(
                                  onPressed: () async {
                                    final bool result =
                                        await PrintBluetoothThermal.connect(
                                          macPrinterAddress: controller
                                              .device
                                              .value!
                                              .macAdress,
                                        );
                                    controller.connectDevice.value = result;
                                  },
                                  child: const Text("Connect"),
                                ),
                              );
                            }

                            // Jika sudah terhubung
                            return Column(
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.bluetooth_connected,
                                    color: Colors.green,
                                  ),
                                  title: Text(
                                    "Printer: ${controller.device.value!.name}",
                                  ),
                                  subtitle: const Text("Terhubung"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await PrintBluetoothThermal.disconnect;
                                    controller.connectDevice.value = false;
                                  },
                                  child: const Text("Disconnect"),
                                ),
                              ],
                            );
                          }),
                        ),
                        SizedBox(height: 24, width: Get.width),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 12,
                          children: state!
                              .map(
                                (e) => Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      controller.selectedVehicle.value = state
                                          .indexOf(e);
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 96,
                                          height: 96,
                                          clipBehavior: Clip.hardEdge,
                                          margin: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color:
                                                  controller
                                                          .selectedVehicle
                                                          .value ==
                                                      state.indexOf(e)
                                                  ? Colors.deepPurple
                                                  : Colors.transparent,
                                              width: 5,
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                e.imageUrl ?? '',
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                controller
                                                        .selectedVehicle
                                                        .value ==
                                                    state.indexOf(e)
                                                ? Colors.deepPurple
                                                : Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            e.name ?? '',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  controller
                                                          .selectedVehicle
                                                          .value !=
                                                      state.indexOf(e)
                                                  ? Colors.deepPurple
                                                  : Colors.grey.shade300,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),

                        SizedBox(height: 16, width: Get.width),
                        TextFormField(
                          controller: controller.vehicleNumber,

                          validator: (value) => (value?.isEmpty ?? true)
                              ? 'Plat Nomor tidak boleh kosong'
                              : null,
                          decoration: InputDecoration(
                            labelText: "Plat Nomor",
                            prefixIcon: const Icon(
                              Icons.confirmation_number_outlined,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text("Biaya", style: TextStyle(fontSize: 16)),
                            const Spacer(),
                            Obx(() {
                              final price =
                                  state[controller.selectedVehicle.value]
                                      .parkingRateRules
                                      ?.firstOrNull
                                      ?.fixedPrice;
                              log(price.toString());

                              final formattedPrice = price != null
                                  ? "Rp ${NumberFormat.decimalPattern('id').format(price)}"
                                  : "-";

                              return Text(
                                formattedPrice,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    controller.paymentMethod.value == 'cash'
                                    ? Colors.amber
                                    : null,
                              ),
                              onPressed: () {
                                controller.paymentMethod.value = 'cash';
                              },
                              child: Text('Cash'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    controller.paymentMethod.value == 'qris'
                                    ? Colors.amber
                                    : null,
                              ),
                              onPressed: null,
                              child: Text('Qris'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            controller.pickImageFromCamera();
                          },
                          child: Obx(
                            () => Container(
                              width: Get.width,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade300,
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: controller.imageFile.value == null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.camera),
                                        const SizedBox(width: 8),
                                        Text("Ambil Gambar"),
                                      ],
                                    )
                                  : Image.file(
                                      controller.imageFile.value!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Obx(
                              () => controller.imageFile.value == null
                                  ? const SizedBox.shrink()
                                  : ElevatedButton(
                                      onPressed: () {
                                        controller.imageFile.value = null;
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.deepOrangeAccent,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 76),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await controller.save();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Simpan")],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
