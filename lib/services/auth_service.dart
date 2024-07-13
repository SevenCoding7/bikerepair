import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  Stream<User?> get user => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signInWithPhoneNumber(
      String phone, Function(String) onCodeSent) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          _logger.e('Phone number verification failed: ${e.message}');
          throw e;
        },
        codeSent: (String verificationId, int? resendToken) async {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _logger.i('SMS code auto retrieval timeout');
        },
      );
    } catch (e) {
      _logger.e('Error in signInWithPhoneNumber: $e');
      rethrow;
    }
  }

  Future<void> verifySmsCode(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _signInWithCredential(credential);
    } catch (e) {
      _logger.e('Error in verifySmsCode: $e');
      rethrow;
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      await _createOrUpdateUser(userCredential.user!);
    } catch (e) {
      _logger.e('Error in _signInWithCredential: $e');
      rethrow;
    }
  }

  Future<void> _createOrUpdateUser(User user) async {
    try {
      DocumentReference userDoc = _firestore.collection('users').doc(user.uid);
      DocumentSnapshot snapshot = await userDoc.get();

      if (!snapshot.exists) {
        await userDoc.set({
          'phoneNumber': user.phoneNumber,
          'isAdmin': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        await userDoc.update({
          'lastSignInAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      _logger.e('Error in _createOrUpdateUser: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      _logger.e('Error signing out: $e');
      rethrow;
    }
  }

  Future<bool> isAdmin(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      return userDoc.exists &&
          (userDoc.data() as Map<String, dynamic>)['isAdmin'] == true;
    } catch (e) {
      _logger.e('Error checking admin status: $e');
      return false;
    }
  }

  Future<void> setAdminStatus(String uid, bool isAdmin) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({'isAdmin': isAdmin});
    } catch (e) {
      _logger.e('Error setting admin status: $e');
      rethrow;
    }
  }

  Future<String?> getCurrentUserPhone() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        return user.phoneNumber;
      }
      return null;
    } catch (e) {
      _logger.e('Error getting current user phone: $e');
      return null;
    }
  }

  Future<void> updateUserProfile(String displayName) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await _firestore.collection('users').doc(user.uid).update({
          'displayName': displayName,
        });
      } else {
        throw Exception('No user is currently signed in.');
      }
    } catch (e) {
      _logger.e('Error updating user profile: $e');
      rethrow;
    }
  }
}
