import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:parking_portable/app/widgets/app_loading.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: Form(
        key: controller.formState,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animasi Lottie (bisa diganti file JSON lokal atau link)
              SizedBox(
                height: 180,
                child: Lottie.asset('assets/lottie/login.json'),
              ),

              const SizedBox(height: 20),

              FadeTransition(
                opacity: controller.fadeTransition,
                child: Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Login to continue",
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 40),

              // Email Field
              TextFormField(
                controller: controller.usernameController,

                validator: (value) => (value?.isEmpty ?? true)
                    ? 'Username tidak boleh kosong'
                    : null,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              Obx(
                () => TextFormField(
                  obscureText: controller.obscurePassword,
                  controller: controller.passwordController,
                  validator: (value) => (value?.isEmpty ?? true)
                      ? 'Password tidak boleh kosong'
                      : null,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        controller.obscurePassword =
                            !controller.obscurePassword;
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Tombol Login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.login();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    AppDialog.instance.loading();
                    final bool enabled =
                        await PrintBluetoothThermal.bluetoothEnabled;

                    if (!enabled) {
                      Get.close(1);
                      AppDialog.instance.basic(
                        title: "Oops!",
                        description:
                            "Nyalakan bluetooth dan sambungkan printer!!",
                      );
                      return;
                    }
                    final List<BluetoothInfo> listResult =
                        await PrintBluetoothThermal.pairedBluetooths;
                    final BluetoothInfo? selectedDevice = listResult
                        .where(
                          (e) =>
                              e.name.toLowerCase().contains(
                                "bluetoothprinter",
                              ) ==
                              true,
                        )
                        .firstOrNull;
                    if (selectedDevice == null) {
                      Get.close(1);
                      AppDialog.instance.basic(
                        title: "Oops!",
                        description: "Printer bluetooth tidak ditemukan!!",
                      );
                      return;
                    }
                    final bool result = await PrintBluetoothThermal.connect(
                      macPrinterAddress: selectedDevice.macAdress,
                    );
                    if (!result) {
                      Get.close(1);
                      AppDialog.instance.basic(
                        title: "Oops!",
                        description: "Gagal terhubung ke printer!!",
                      );
                      return;
                    }
                    bool conexionStatus =
                        await PrintBluetoothThermal.connectionStatus;
                    if (!conexionStatus) {
                      Get.close(1);
                      AppDialog.instance.basic(
                        title: "Oops!",
                        description: "Printer bluetooth tidak terhubung!!",
                      );
                      return;
                    }

                    String enter = '\n';
                    await PrintBluetoothThermal.writeBytes(enter.codeUnits);
                    await PrintBluetoothThermal.writeBytes(
                      await parkirTicket(
                        noTicket: "A001",
                        plat: "B 1234 CD",
                        masuk: DateTime.now(),
                      ),
                    );
                    await PrintBluetoothThermal.writeBytes(enter.codeUnits);
                    await PrintBluetoothThermal.disconnect;
                    Get.close(1);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.pink,
                  ),
                  child: const Text(
                    "Test",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<int>> parkirTicket({
    required String noTicket,
    required String plat,
    required DateTime masuk,
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
      linesAfter: 1,
    );
    bytes += generator.text(
      'Tiket Parkir',
      styles: PosStyles(align: PosAlign.center, bold: true),
      linesAfter: 1,
    );

    // --- TICKET INFO ---
    bytes += generator.text('No Tiket : $noTicket');
    bytes += generator.text('Plat     : $plat');
    bytes += generator.text('Gate     : $gate');
    bytes += generator.text(
      'Masuk    : ${masuk.toString().split('.')[0]}',
      linesAfter: 1,
    );

    // --- BARCODE ---
    bytes += generator.barcode(
      Barcode.code128(noTicket.split('')),
      width: 2,
      height: 80,
    );

    // --- FOOTER ---
    bytes += generator.feed(2);
    bytes += generator.text(
      'Terima kasih sudah menggunakan layanan kami.',
      styles: PosStyles(align: PosAlign.center),
      linesAfter: 2,
    );

    // --- CUT ---
    bytes += generator.cut();

    return bytes;
  }
}
