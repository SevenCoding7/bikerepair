class Maintenance {
  final String id;
  final String vehicleId;
  final List<String> services;
  final DateTime date;

  Maintenance({
    required this.id,
    required this.vehicleId,
    required this.services,
    required this.date,
  });

  factory Maintenance.fromMap(Map<String, dynamic> data) {
    return Maintenance(
      id: data['id'],
      vehicleId: data['vehicleId'],
      services: List<String>.from(data['services']),
      date: data['date'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'services': services,
      'date': date,
    };
  }

  static Maintenance fromString(String maintenanceInfo) {
    final parts = maintenanceInfo.split(',');
    return Maintenance(
      id: parts[0],
      vehicleId: parts[1],
      services: List<String>.from(parts[2].split(':')),
      date: DateTime.parse(parts[3]),
    );
  }
}
