import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_portable/app/controllers/app_controller.dart';
import 'package:parking_portable/app/data/services/authenticate_services.dart';
import 'package:parking_portable/app/routes/app_pages.dart';
import 'package:parking_portable/app/widgets/app_loading.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final fadeTransition = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..forward();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final formState = GlobalKey<FormState>();

  final _obscurePassword = true.obs;
  set obscurePassword(bool value) => _obscurePassword.value = value;
  bool get obscurePassword => _obscurePassword.value;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    fadeTransition.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if ((formState.currentState?.validate() ?? false) == false) {
      return;
    }

    AppDialog.instance.loading();

    final result = await AuthenticateServices.login(
      usernameController.text,
      passwordController.text,
    );

    Get.close(1);

    if (!result.success) {
      AppDialog.instance.basic(
        title: "Oops!",
        description: result.message ?? "Terjadi Kesalahan",
      );
      return;
    }

    Get.find<AppController>().user.value = result.data;
    Get.offAllNamed(Routes.HOME);
  }
}
