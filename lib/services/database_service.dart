import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../models/user_model.dart';
import '../models/vehicle_model.dart';
import '../models/maintenance_model.dart';
import '../models/reservation_model.dart';
import '../models/message_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  DatabaseService() {
    _firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  }

  Future<UserData?> getUserData(String? userId) async {
    if (userId == null) return null;
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;
      return UserData.fromMap(doc.data()!);
    } catch (e) {
      _logger.e('Error getting user data: $e');
      return null;
    }
  }

  Future<void> updateUserData(String userId, UserData userData) async {
    try {
      await _firestore.collection('users').doc(userId).set(userData.toMap());
    } catch (e) {
      _logger.e('Error updating user data: $e');
      rethrow;
    }
  }

  Future<List<Vehicle>> getUserVehicles(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .get();
      return snapshot.docs.map((doc) => Vehicle.fromMap(doc.data())).toList();
    } catch (e) {
      _logger.e('Error getting user vehicles: $e');
      return [];
    }
  }

  Future<void> addVehicle(String userId, Vehicle vehicle) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .add(vehicle.toMap());
    } catch (e) {
      _logger.e('Error adding vehicle: $e');
      rethrow;
    }
  }

  Future<void> completeMaintenance(
      String vehicleId, List<String> maintenanceItems) async {
    final maintenance = Maintenance(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      vehicleId: vehicleId,
      services: maintenanceItems,
      date: DateTime.now(),
    );

    try {
      await _firestore.runTransaction((transaction) async {
        final vehicleRef = _firestore.collection('vehicles').doc(vehicleId);

        transaction
            .update(vehicleRef, {'lastMaintenance': maintenance.toMap()});

        transaction.set(
            vehicleRef.collection('maintenance').doc(maintenance.id),
            maintenance.toMap());
      });
    } catch (e) {
      _logger.e('Error completing maintenance: $e');
      rethrow;
    }
  }

  Stream<List<Message>> getMessages(String userId) {
    return _firestore
        .collection('messages')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromMap(doc.data()..['id'] = doc.id))
            .toList());
  }

  Future<void> sendMessage(Message message) async {
    try {
      await _firestore.collection('messages').add(message.toMap());
    } catch (e) {
      _logger.e('Error sending message: $e');
      rethrow;
    }
  }

  Future<void> createReservation(Reservation reservation) async {
    try {
      await _firestore
          .collection('reservations')
          .doc(reservation.id)
          .set(reservation.toMap());
    } catch (e) {
      _logger.e('Error creating reservation: $e');
      rethrow;
    }
  }

  Stream<Reservation> getReservationStatus(String reservationId) {
    return _firestore
        .collection('reservations')
        .doc(reservationId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        throw Exception('Reservation not found');
      }
      return Reservation.fromMap(snapshot.data()!);
    });
  }

  Future<void> createUser(String uid, String phoneNumber,
      {bool isAdmin = false}) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'phoneNumber': phoneNumber,
        'isAdmin': isAdmin,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _logger.e('Error creating user document: $e');
      rethrow;
    }
  }
}
