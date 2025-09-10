import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:parking_portable/app/data/models/parking_ticket.dart';
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

  /// Entry & Exit Ticket
  static Future<ResponseApi<ParkingTicket>> entryAndExit({
    required String ticketNumber,
    required String vehiclePlateNumber,
    required int vehicleTypeId,
    required String paymentMethod,
    File? photo,
  }) async {
    try {
      final formData = FormData.fromMap({
        'ticket_number': ticketNumber,
        'vehicle_plate_number': vehiclePlateNumber,
        'vehicle_type_id': vehicleTypeId,
        'payment_method': paymentMethod,
        if (photo != null)
          'photo': await MultipartFile.fromFile(
            photo.path,
            filename: photo.path.split('/').last,
          ),
      });

      final result = await dio.post(
        'entry-and-exit',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (!result.isSuccess) {
        return ResponseApi(
          data: null,
          success: false,
          message: result.data['message'],
        );
      }

      return ResponseApi(
        data: ParkingTicket.fromJson(result.data['data']),
        success: true,
        message: result.data['message'],
      );
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      return ResponseApi(data: null, success: false, message: e.toString());
    }
  }

  static Future<ResponseApi<ParkingTicket>> pay({
    required String ticketNumber,
    required String paymentMethod,
  }) async {
    try {
      final result = await dio.post(
        'pay',
        data: {"ticket_number": ticketNumber},
      );

      if (!result.isSuccess) {
        return ResponseApi(
          data: null,
          success: false,
          message: result.data['message'] ?? "Gagal melakukan pembayaran",
        );
      }

      return ResponseApi(
        data: ParkingTicket.fromJson(result.data['data']),
        success: true,
        message: result.data['message'] ?? "Pembayaran berhasil",
      );
    } catch (e) {
      return ResponseApi(data: null, success: false, message: e.toString());
    }
  }
}
