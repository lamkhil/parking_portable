import 'dart:developer';

class VehicleType {
  int? id;
  String? name;
  String? description;
  String? image;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;
  List<ParkingRateRules>? parkingRateRules;

  VehicleType({
    this.id,
    this.name,
    this.description,
    this.image,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.parkingRateRules,
  });

  VehicleType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    imageUrl = json['image_url'] ?? '-';
    if (imageUrl!.contains('localhost') || imageUrl!.contains('127.0.0.1')) {
      imageUrl = imageUrl!
          .replaceAll('localhost', '10.0.2.2')
          .replaceAll('127.0.0.1', '10.0.2.2');
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['parking_rate_rules'] != null) {
      parkingRateRules = <ParkingRateRules>[];
      json['parking_rate_rules'].forEach((v) {
        parkingRateRules!.add(new ParkingRateRules.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['image_url'] = this.imageUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.parkingRateRules != null) {
      data['parking_rate_rules'] = this.parkingRateRules!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class ParkingRateRules {
  int? id;
  int? vehicleTypeId;
  int? startMinute;
  int? endMinute;
  double? fixedPrice;
  double? perHourPrice;
  double? perDayPrice;
  String? createdAt;
  String? updatedAt;

  ParkingRateRules({
    this.id,
    this.vehicleTypeId,
    this.startMinute,
    this.endMinute,
    this.fixedPrice,
    this.perHourPrice,
    this.perDayPrice,
    this.createdAt,
    this.updatedAt,
  });

  ParkingRateRules.fromJson(Map<String, dynamic> json) {
    log(json.toString());
    id = int.tryParse(json['id'].toString());
    vehicleTypeId = int.tryParse(json['vehicle_type_id'].toString());
    startMinute = int.tryParse(json['start_minute'].toString());
    endMinute = int.tryParse(json['end_minute'].toString());
    fixedPrice = double.tryParse(json['fixed_price'].toString());
    perHourPrice = double.tryParse(json['per_hour_price'].toString());
    perDayPrice = double.tryParse(json['per_day_price'].toString());
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vehicle_type_id'] = this.vehicleTypeId;
    data['start_minute'] = this.startMinute;
    data['end_minute'] = this.endMinute;
    data['fixed_price'] = this.fixedPrice;
    data['per_hour_price'] = this.perHourPrice;
    data['per_day_price'] = this.perDayPrice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
