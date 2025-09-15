import 'package:parking_portable/app/data/models/vehicle_type.dart';

class ParkingTicket {
  int? id;
  int? gateInId;
  int? gateOutId;
  String? ticketNumber;
  String? exitedAt;
  int? durationMinutes;
  String? vehiclePlateNumber;
  int? vehicleTypeId;
  String? status;
  int? amount;
  String? currency;
  String? paymentMethod;
  String? transactionId;
  String? externalReference;
  String? paidAt;
  int? paidBy;
  int? issuedBy;
  String? cancelledAt;
  int? cancelledBy;
  String? name;
  String? description;
  String? notes;
  String? slug;
  String? statusMessage;
  int? statusCode;
  Map<String, dynamic>? metadata;
  int? createdBy;
  int? updatedBy;
  int? deletedBy;
  String? ipAddress;
  String? userAgent;
  String? photoIn;
  String? photoOut;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? shiftId;
  String? paymentStatus;
  ParkingGateIn? parkingGateIn;
  ParkingGateIn? parkingGateOut;
  Shift? shift;
  VehicleType? vehicleType;

  ParkingTicket({
    this.id,
    this.gateInId,
    this.gateOutId,
    this.ticketNumber,
    this.exitedAt,
    this.durationMinutes,
    this.vehiclePlateNumber,
    this.vehicleTypeId,
    this.status,
    this.amount,
    this.currency,
    this.paymentMethod,
    this.transactionId,
    this.externalReference,
    this.paidAt,
    this.paidBy,
    this.issuedBy,
    this.cancelledAt,
    this.cancelledBy,
    this.name,
    this.description,
    this.notes,
    this.slug,
    this.statusMessage,
    this.statusCode,
    this.metadata,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.ipAddress,
    this.userAgent,
    this.photoIn,
    this.photoOut,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.shiftId,
    this.paymentStatus,
    this.parkingGateIn,
    this.parkingGateOut,
    this.shift,
    this.vehicleType,
  });

  ParkingTicket.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    gateInId = int.tryParse(json['gate_in_id']?.toString() ?? '');
    gateOutId = int.tryParse(json['gate_out_id']?.toString() ?? '');
    ticketNumber = json['ticket_number'];
    exitedAt = json['exited_at'];
    durationMinutes = int.tryParse(json['duration_minutes']?.toString() ?? '');
    vehiclePlateNumber = json['vehicle_plate_number'];
    vehicleTypeId = int.tryParse(json['vehicle_type_id']?.toString() ?? '');
    status = json['status'];
    amount = double.tryParse((json['amount']?.toString() ?? ''))?.toInt();
    currency = json['currency'];
    paymentMethod = json['payment_method'];
    transactionId = json['transaction_id'];
    externalReference = json['external_reference'];
    paidAt = json['paid_at'];
    paidBy = int.tryParse(json['paid_by']?.toString() ?? '');
    issuedBy = int.tryParse(json['issued_by']?.toString() ?? '');
    cancelledAt = json['cancelled_at'];
    cancelledBy = int.tryParse(json['cancelled_by']?.toString() ?? '');
    name = json['name'];
    description = json['description'];
    notes = json['notes'];
    slug = json['slug'];
    statusMessage = json['status_message'];
    statusCode = int.tryParse(json['status_code']?.toString() ?? '');
    metadata = json['metadata'];
    createdBy = int.tryParse(json['created_by']?.toString() ?? '');
    updatedBy = int.tryParse(json['updated_by']?.toString() ?? '');
    deletedBy = int.tryParse(json['deleted_by']?.toString() ?? '');
    ipAddress = json['ip_address'];
    userAgent = json['user_agent'];
    photoIn = json['photo_in'];
    photoOut = json['photo_out'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    shiftId = int.tryParse(json['shift_id']?.toString() ?? '');
    paymentStatus = json['payment_status'];
    parkingGateIn = json['parking_gate_in'] != null
        ? ParkingGateIn.fromJson(json['parking_gate_in'])
        : null;
    parkingGateOut = json['parking_gate_out'] != null
        ? ParkingGateIn.fromJson(json['parking_gate_out'])
        : null;
    shift = json['shift'] != null ? Shift.fromJson(json['shift']) : null;
    vehicleType = json['vehicle_type'] != null
        ? VehicleType.fromJson(json['vehicle_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['gate_in_id'] = gateInId;
    data['gate_out_id'] = gateOutId;
    data['ticket_number'] = ticketNumber;
    data['exited_at'] = exitedAt;
    data['duration_minutes'] = durationMinutes;
    data['vehicle_plate_number'] = vehiclePlateNumber;
    data['vehicle_type_id'] = vehicleTypeId;
    data['status'] = status;
    data['amount'] = amount;
    data['currency'] = currency;
    data['payment_method'] = paymentMethod;
    data['transaction_id'] = transactionId;
    data['external_reference'] = externalReference;
    data['paid_at'] = paidAt;
    data['paid_by'] = paidBy;
    data['issued_by'] = issuedBy;
    data['cancelled_at'] = cancelledAt;
    data['cancelled_by'] = cancelledBy;
    data['name'] = name;
    data['description'] = description;
    data['notes'] = notes;
    data['slug'] = slug;
    data['status_message'] = statusMessage;
    data['status_code'] = statusCode;
    data['metadata'] = metadata;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['deleted_by'] = deletedBy;
    data['ip_address'] = ipAddress;
    data['user_agent'] = userAgent;
    data['photo_in'] = photoIn;
    data['photo_out'] = photoOut;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['shift_id'] = shiftId;
    data['payment_status'] = paymentStatus;
    if (parkingGateIn != null) {
      data['parking_gate_in'] = parkingGateIn!.toJson();
    }
    if (parkingGateOut != null) {
      data['parking_gate_out'] = parkingGateOut!.toJson();
    }
    if (shift != null) {
      data['shift'] = shift!.toJson();
    }
    if (vehicleType != null) {
      data['vehicle_type'] = vehicleType!.toJson();
    }
    return data;
  }
}

class ParkingGateIn {
  int? id;
  String? name;
  String? type;
  String? createdAt;
  String? updatedAt;

  ParkingGateIn({
    this.id,
    this.name,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  ParkingGateIn.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    name = json['name'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Shift {
  int? id;
  String? name;
  String? startTime;
  String? endTime;
  String? createdAt;
  String? updatedAt;

  Shift({
    this.id,
    this.name,
    this.startTime,
    this.endTime,
    this.createdAt,
    this.updatedAt,
  });

  Shift.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    name = json['name'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
