import 'vehicle_model.dart';
import 'maintenance_model.dart';

class UserData {
  final String id;
  final String name;
  final String phone;
  final Vehicle? vehicle;
  final Maintenance? lastMaintenance;
  final int couponCount;

  UserData({
    required this.id,
    required this.name,
    required this.phone,
    this.vehicle,
    this.lastMaintenance,
    required this.couponCount,
  });

  factory UserData.fromMap(Map<String, dynamic> data) {
    return UserData(
      id: data['id'],
      name: data['name'],
      phone: data['phone'],
      vehicle:
          data['vehicle'] != null ? Vehicle.fromMap(data['vehicle']) : null,
      lastMaintenance: data['lastMaintenance'] != null
          ? Maintenance.fromMap(data['lastMaintenance'])
          : null,
      couponCount: data['couponCount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'vehicle': vehicle?.toMap(),
      'lastMaintenance': lastMaintenance?.toMap(),
      'couponCount': couponCount,
    };
  }
}
