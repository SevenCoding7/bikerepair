import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:logger/Logger.dart';

class StorageService {
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  final Logger _logger = Logger();

  Future<String?> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await _storage.ref('uploads/$fileName').putFile(file);
      String downloadURL =
          await _storage.ref('uploads/$fileName').getDownloadURL();
      return downloadURL;
    } on firebase_storage.FirebaseException catch (e) {
      _logger.e('Error uploading file: ${e.code}');
      return null;
    }
  }

  Future<String?> uploadImageData(Uint8List imageData, String fileName) async {
    try {
      await _storage.ref('images/$fileName').putData(imageData);
      String downloadURL =
          await _storage.ref('images/$fileName').getDownloadURL();
      return downloadURL;
    } on firebase_storage.FirebaseException catch (e) {
      _logger.e('Error uploading image: ${e.code}');
      return null;
    }
  }

  Future<Uint8List?> downloadFile(String fileName) async {
    try {
      final data = await _storage.ref('uploads/$fileName').getData();
      return data;
    } on firebase_storage.FirebaseException catch (e) {
      _logger.e('Error downloading file: ${e.code}');
      return null;
    }
  }

  Future<bool> deleteFile(String fileName) async {
    try {
      await _storage.ref('uploads/$fileName').delete();
      return true;
    } on firebase_storage.FirebaseException catch (e) {
      _logger.e('Error deleting file: ${e.code}');
      return false;
    }
  }
}
