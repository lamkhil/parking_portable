import 'package:dio/dio.dart';

import 'interceptor/logging_interceptor.dart';
import 'interceptor/network_interceptor.dart';

final Dio dio =
    Dio(
        BaseOptions(
          baseUrl: 'http://10.0.2.2:8000/api/',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      )
      ..interceptors.add(LoggingInterceptors())
      ..interceptors.add(NetworkInterceptor());
