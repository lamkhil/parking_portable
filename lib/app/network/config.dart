import 'package:dio/dio.dart';

import 'interceptor/logging_interceptor.dart';
import 'interceptor/network_interceptor.dart';

final Dio dio =
    Dio(
        BaseOptions(
          baseUrl: 'https://parkir.dpmptsp-surabaya.my.id/api/',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          followRedirects: true,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      )
      ..interceptors.add(LoggingInterceptors())
      ..interceptors.add(NetworkInterceptor());
