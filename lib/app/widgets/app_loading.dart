import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialog<T> {
  AppDialog._();

  static AppDialog? _instance;

  static AppDialog get instance {
    _instance ??= AppDialog._();
    return _instance!;
  }

  Future<T?> loading() {
    return Get.dialog<T>(
      Center(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Get.theme.scaffoldBackgroundColor,
          ),
          child: const CircularProgressIndicator(),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<T?> basic({
    required String title,
    required String description,
    List<Widget> actions = const [],
  }) async {
    return Get.dialog<T>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: Get.textTheme.titleLarge),
        content: Text(description, style: Get.textTheme.bodyMedium),
        actions: actions.isNotEmpty
            ? actions
            : [
                TextButton(
                  onPressed: () => Get.back<T>(),
                  child: const Text("OK"),
                ),
              ],
      ),
      barrierDismissible: false,
    );
  }
}
