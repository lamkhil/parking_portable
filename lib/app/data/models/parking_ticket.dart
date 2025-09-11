import 'package:parking_portable/app/data/models/user.dart';
import 'package:parking_portable/app/data/models/vehicle_type.dart';

class ParkingTicket {
  int? gateInId;
  int? gateOutId;
  int? shiftId;
  String? ticketNumber;
  String? vehiclePlateNumber;
  int? createdBy;
  int? updatedBy;
  String? ipAddress;
  String? userAgent;
  int? vehicleTypeId;
  String? photoIn;
  String? photoOut;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? exitedAt;
  double? durationMinutes;
  int? amount;
  String? paymentMethod;
  ParkingGate? parkingGateIn;
  ParkingGate? parkingGateOut;
  Shift? shift;
  VehicleType? vehicleType;

  ParkingTicket({
    this.gateInId,
    this.gateOutId,
    this.shiftId,
    this.ticketNumber,
    this.vehiclePlateNumber,
    this.createdBy,
    this.updatedBy,
    this.ipAddress,
    this.userAgent,
    this.vehicleTypeId,
    this.photoIn,
    this.photoOut,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.exitedAt,
    this.durationMinutes,
    this.amount,
    this.paymentMethod,
    this.parkingGateIn,
    this.parkingGateOut,
    this.shift,
    this.vehicleType,
  });

  ParkingTicket.fromJson(Map<String, dynamic> json) {
    gateInId = int.tryParse(json['gate_in_id'].toString());
    gateOutId = int.tryParse(json['gate_out_id'].toString());
    shiftId = int.tryParse(json['shift_id'].toString());
    ticketNumber = json['ticket_number'];
    vehiclePlateNumber = json['vehicle_plate_number'];
    createdBy = int.tryParse(json['created_by'].toString());
    updatedBy = int.tryParse(json['updated_by'].toString());
    ipAddress = json['ip_address'];
    userAgent = json['user_agent'];
    vehicleTypeId = int.tryParse(json['vehicle_type_id'].toString());
    photoIn = json['photo_in'];
    photoOut = json['photo_out'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = int.tryParse(json['id'].toString());
    exitedAt = json['exited_at'];
    durationMinutes = double.tryParse(json['duration_minutes'].toString());
    amount = double.tryParse(json['amount'].toString())?.toInt();
    paymentMethod = json['payment_method'];
    parkingGateIn = json['parking_gate_in'] != null
        ? new ParkingGate.fromJson(json['parking_gate_in'])
        : null;
    parkingGateOut = json['parking_gate_out'] != null
        ? new ParkingGate.fromJson(json['parking_gate_out'])
        : null;
    shift = json['shift'] != null ? new Shift.fromJson(json['shift']) : null;
    vehicleType = json['vehicle_type'] != null
        ? new VehicleType.fromJson(json['vehicle_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gate_in_id'] = this.gateInId;
    data['gate_out_id'] = this.gateOutId;
    data['shift_id'] = this.shiftId;
    data['ticket_number'] = this.ticketNumber;
    data['vehicle_plate_number'] = this.vehiclePlateNumber;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['ip_address'] = this.ipAddress;
    data['user_agent'] = this.userAgent;
    data['vehicle_type_id'] = this.vehicleTypeId;
    data['photo_in'] = this.photoIn;
    data['photo_out'] = this.photoOut;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['exited_at'] = this.exitedAt;
    data['duration_minutes'] = this.durationMinutes;
    data['amount'] = this.amount;
    data['payment_method'] = this.paymentMethod;
    if (this.parkingGateIn != null) {
      data['parking_gate_in'] = this.parkingGateIn!.toJson();
    }
    if (this.parkingGateOut != null) {
      data['parking_gate_out'] = this.parkingGateOut!.toJson();
    }
    if (this.shift != null) {
      data['shift'] = this.shift!.toJson();
    }
    if (this.vehicleType != null) {
      data['vehicle_type'] = this.vehicleType!.toJson();
    }
    return data;
  }
}
