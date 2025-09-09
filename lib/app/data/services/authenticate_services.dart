import 'package:get_storage/get_storage.dart';
import 'package:parking_portable/app/data/models/response_api.dart';
import 'package:parking_portable/app/data/models/user.dart';
import 'package:parking_portable/app/extension/response_extensions.dart';
import 'package:parking_portable/app/network/config.dart';

class AuthenticateServices {
  static Future<ResponseApi<User>> login(String email, String password) async {
    final result = await dio.post(
      'login',
      data: {'email': email, 'password': password},
    );

    if (!result.isSuccess) {
      return ResponseApi(
        data: null,
        success: false,
        message: result.data['message'] ?? 'Terjadi Kesalahan',
      );
    }

    final user = User.fromJson(result.data['data']);

    await GetStorage().write('token', result.data['token']);

    return ResponseApi(
      data: user,
      success: true,
      message: result.data['message'] ?? 'Berhasil mengambil data',
    );
  }

  static Future<ResponseApi<User>> me() async {
    final result = await dio.get('me');
    if (!result.isSuccess) {
      return ResponseApi(
        data: null,
        success: false,
        message: result.data['message'] ?? 'Terjadi Kesalahan',
      );
    }
    final user = User.fromJson(result.data['data']);

    return ResponseApi(
      data: user,
      success: true,
      message: result.data['message'] ?? 'Berhasil mengambil data',
    );
  }

  static Future<ResponseApi> logout() async {
    final result = await dio.post('logout');
    if (!result.isSuccess) {
      return ResponseApi(
        data: null,
        success: false,
        message: result.data['message'] ?? 'Terjadi Kesalahan',
      );
    }
    return ResponseApi(
      data: null,
      success: true,
      message: result.data['message'] ?? 'Berhasil mengambil data',
    );
  }
}
