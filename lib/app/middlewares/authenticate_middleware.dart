import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticateMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Cek apakah user sudah login
    final isLoggedIn = GetStorage().read(
      'token',
    ); // Ganti dengan logika autentikasi sebenarnya

    if (isLoggedIn == null) {
      return const RouteSettings(name: '/login');
    }
    return null;
  }
}
