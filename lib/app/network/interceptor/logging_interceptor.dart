// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:dio/dio.dart';

class LoggingInterceptors extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    print(
      "--> ${options.method.toUpperCase()} ${"${options.baseUrl}${options.path}"}",
    );
    print("Headers:");
    options.headers.forEach((k, v) => print('$k: $v'));
    print("queryParameters:");
    options.queryParameters.forEach((k, v) => print('$k: $v'));
    if (options.data != null) {
      print("Body: ${options.data}");
    }
    print("--> END ${options.method.toUpperCase()}");

    return super.onRequest(options, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    print(
      "<-- ${err.message} ${(err.response != null ? (err.response!.requestOptions.baseUrl + err.response!.requestOptions.path) : 'URL')}",
    );
    print("${err.response != null ? err.response!.data : 'Unknown Error'}");
    print("<-- End error");
    return super.onError(err, handler);
  }

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    print("<-- ${(response.statusCode)}");
    print(
      "<-- ${(response.requestOptions.baseUrl + response.requestOptions.path)}",
    );
    print("Headers:");
    response.headers.forEach((k, v) => print('$k: $v'));
    log("Response: ${response.data}");
    print("<-- END HTTP");
    return super.onResponse(response, handler);
  }
}
