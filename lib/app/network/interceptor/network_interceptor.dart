import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:parking_portable/app/routes/app_pages.dart';

class NetworkInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    String? token = GetStorage().read('token');
    if (token != null) {
      token = "Bearer $token";
      options.headers.addAll({HttpHeaders.authorizationHeader: token});
    }
    return super.onRequest(options, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    return super.onError(err, handler);
  }

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.data is Map) {
      if (response.data['message'] == "Unauthenticated.") {
        Future.delayed(
          Duration(seconds: 1),
        ).then((_) => Get.offAllNamed(Routes.LOGIN));
      }
    }
    return super.onResponse(response, handler);
  }
}
