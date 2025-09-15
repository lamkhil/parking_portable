import 'package:parking_portable/app/data/models/parking_ticket.dart';
import 'package:parking_portable/app/data/models/user.dart' hide Shift;

class RekapTicket {
  int? id;
  int? userId;
  int? shiftId;
  int? parkingGateId;
  int? totalAmount;
  String? createdAt;
  String? updatedAt;
  List<ParkingTicket>? parkingTickets;
  User? user;
  Shift? shift;
  ParkingGateIn? parkingGate;

  RekapTicket({
    this.id,
    this.userId,
    this.shiftId,
    this.parkingGateId,
    this.totalAmount,
    this.createdAt,
    this.updatedAt,
    this.parkingTickets,
    this.user,
    this.shift,
    this.parkingGate,
  });

  RekapTicket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    shiftId = json['shift_id'];
    parkingGateId = json['parking_gate_id'];
    totalAmount = json['total_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['parking_tickets'] != null) {
      parkingTickets = <ParkingTicket>[];
      json['parking_tickets'].forEach((v) {
        parkingTickets!.add(new ParkingTicket.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    shift = json['shift'] != null ? Shift.fromJson(json['shift']) : null;
    parkingGate = json['parking_gate'] != null
        ? new ParkingGateIn.fromJson(json['parking_gate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['shift_id'] = this.shiftId;
    data['parking_gate_id'] = this.parkingGateId;
    data['total_amount'] = this.totalAmount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.parkingTickets != null) {
      data['parking_tickets'] = this.parkingTickets!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.shift != null) {
      data['shift'] = this.shift!.toJson();
    }
    if (this.parkingGate != null) {
      data['parking_gate'] = this.parkingGate!.toJson();
    }
    return data;
  }
}
