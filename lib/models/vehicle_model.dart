import 'package:equatable/equatable.dart';
import 'maintenance_model.dart';

class Vehicle extends Equatable {
  final String id;
  final String number;
  final String model;
  final int year;
  final String color;
  final String ownerName;
  final Maintenance? lastMaintenance;

  const Vehicle({
    required this.id,
    required this.number,
    required this.model,
    required this.year,
    required this.color,
    required this.ownerName,
    this.lastMaintenance,
  });

  factory Vehicle.fromMap(Map<String, dynamic> data) {
    return Vehicle(
      id: data['id'] as String,
      number: data['number'] as String,
      model: data['model'] as String,
      year: data['year'] as int,
      color: data['color'] as String,
      ownerName: data['ownerName'] as String,
      lastMaintenance: data['lastMaintenance'] != null
          ? Maintenance.fromMap(data['lastMaintenance'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'model': model,
      'year': year,
      'color': color,
      'ownerName': ownerName,
      'lastMaintenance': lastMaintenance?.toMap(),
    };
  }

  Vehicle copyWith({
    String? id,
    String? number,
    String? model,
    int? year,
    String? color,
    String? ownerName,
    Maintenance? lastMaintenance,
  }) {
    return Vehicle(
      id: id ?? this.id,
      number: number ?? this.number,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      ownerName: ownerName ?? this.ownerName,
      lastMaintenance: lastMaintenance ?? this.lastMaintenance,
    );
  }

  @override
  List<Object?> get props =>
      [id, number, model, year, color, ownerName, lastMaintenance];

  @override
  String toString() {
    return 'Vehicle(id: $id, number: $number, model: $model, year: $year, color: $color, ownerName: $ownerName, lastMaintenance: $lastMaintenance)';
  }

  static Vehicle fromString(String vehicleInfo) {
    final parts = vehicleInfo.split(',');
    return Vehicle(
      id: parts[0],
      number: parts[1],
      model: parts[2],
      year: int.parse(parts[3]),
      color: parts[4],
      ownerName: parts[5],
    );
  }
}
