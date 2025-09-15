import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:parking_portable/app/data/models/parking_ticket.dart'
    hide VehicleType;
import 'package:parking_portable/app/data/models/rekap_ticket.dart';
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

  static Future<ResponseApi<List<ParkingTicket>>> getUnrekapTickets() async {
    try {
      final result = await dio.get('unrekap');

      if (!result.isSuccess) {
        return ResponseApi(
          data: null,
          success: false,
          message: result.data['message'] ?? "Gagal mengambil data tiket",
        );
      }

      return ResponseApi(
        data: (result.data['data'] as List)
            .map((e) => ParkingTicket.fromJson(e))
            .toList(),
        success: true,
      );
    } catch (e) {
      return ResponseApi(data: null, success: false, message: e.toString());
    }
  }

  static Future<ResponseApi<RekapTicket>> rekapTickets() async {
    try {
      final result = await dio.post('rekap');

      if (!result.isSuccess) {
        return ResponseApi(
          data: null,
          success: false,
          message: result.data['message'] ?? "Gagal merekap tiket",
        );
      }

      return ResponseApi(
        data: RekapTicket.fromJson(result.data['data']),
        success: true,
        message: result.data['message'] ?? "Rekap tiket berhasil",
      );
    } catch (e) {
      return ResponseApi(data: null, success: false, message: e.toString());
    }
  }

  static Future<ResponseApi<List<RekapTicket>>> getRekap({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result = await dio.get(
        'rekap',
        queryParameters: {'page': page, 'per_page': limit},
      );

      if (!result.isSuccess) {
        return ResponseApi(
          data: null,
          success: false,
          message: result.data['message'] ?? "Gagal mengambil data rekap",
        );
      }
      return ResponseApi(
        data: (result.data['data'] as List)
            .map((e) => RekapTicket.fromJson(e))
            .toList(),
        success: true,
      );
    } catch (e) {
      return ResponseApi(data: null, success: false, message: e.toString());
    }
  }
}
