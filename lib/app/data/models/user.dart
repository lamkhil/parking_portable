class User {
  int? id;
  String? name;
  String? email;
  String? appName;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  int? parkingGateId;
  int? shiftId;
  Shift? shift;
  ParkingGate? parkingGate;

  User({
    this.id,
    this.name,
    this.email,
    this.appName,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.parkingGateId,
    this.shiftId,
    this.shift,
    this.parkingGate,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    appName = json['app_name'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    parkingGateId = json['parking_gate_id'];
    shiftId = json['shift_id'];
    shift = json['shift'] != null ? new Shift.fromJson(json['shift']) : null;
    parkingGate = json['parking_gate'] != null
        ? new ParkingGate.fromJson(json['parking_gate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['app_name'] = this.appName;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['parking_gate_id'] = this.parkingGateId;
    data['shift_id'] = this.shiftId;
    if (this.shift != null) {
      data['shift'] = this.shift!.toJson();
    }
    if (this.parkingGate != null) {
      data['parking_gate'] = this.parkingGate!.toJson();
    }
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
    id = json['id'];
    name = json['name'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ParkingGate {
  int? id;
  String? name;
  String? type;
  String? createdAt;
  String? updatedAt;

  ParkingGate({this.id, this.name, this.type, this.createdAt, this.updatedAt});

  ParkingGate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
