import 'package:parking_portable/app/data/models/response_api.dart';
import 'package:parking_portable/app/data/models/vehicle_type.dart';
import 'package:parking_portable/app/extension/response_extensions.dart';
import 'package:parking_portable/app/network/config.dart';

class ParkingServices {
  static Future<ResponseApi<List<VehicleType>>> getVehicleType() async {
    final result = await dio.get('vehicle-type');
    if (!result.isSuccess) {
      return ResponseApi(
        data: null,
        success: false,
        message: result.data['message'],
      );
    }

    return ResponseApi(
      data: (result.data['data'] as List)
          .map((e) => VehicleType.fromJson(e))
          .toList(),
      success: true,
    );
  }
}
