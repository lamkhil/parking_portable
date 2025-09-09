import 'package:dio/dio.dart';

extension ResponseExtensions on Response {
  bool get isSuccess {
    return statusCode == 200;
  }
}
