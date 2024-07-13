import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final String id;
  final String userId;
  final DateTime dateTime;
  final List<String> services;
  final String status; // 'pending', 'confirmed', 'cancelled'

  Reservation({
    required this.id,
    required this.userId,
    required this.dateTime,
    required this.services,
    required this.status,
  });

  factory Reservation.fromMap(Map<String, dynamic> data) {
    return Reservation(
      id: data['id'],
      userId: data['userId'],
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      services: List<String>.from(data['services']),
      status: data['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'dateTime': Timestamp.fromDate(dateTime),
      'services': services,
      'status': status,
    };
  }
}
