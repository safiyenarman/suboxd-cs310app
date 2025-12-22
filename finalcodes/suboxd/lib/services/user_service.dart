import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:convert';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserAvatar(String userId, XFile imageFile) async {
    try {

      Uint8List bytes;
      try {
        bytes = await imageFile.readAsBytes();

        if (bytes.length > 800 * 1024) {
          throw 'Image file is too large. Please select a smaller image (max 800KB).';
        }
      } catch (e) {
        if (e.toString().contains('too large')) {
          rethrow;
        }
        throw 'Failed to read image file: $e';
      }

      final base64String = base64Encode(bytes);
      final dataUrl = 'data:image/jpeg;base64,$base64String';

      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {

        await _firestore.collection('users').doc(userId).update({
          'avatarUrl': dataUrl,
          'updatedAt': DateTime.now().toUtc(),
        });
      } else {

        await _firestore.collection('users').doc(userId).set({
          'avatarUrl': dataUrl,
          'updatedAt': DateTime.now().toUtc(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      throw 'Failed to upload avatar: $e';
    }
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      throw 'Failed to get user data: $e';
    }
  }

  Stream<Map<String, dynamic>?> userDataStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snap) => snap.data());
  }

  Stream<List<Map<String, dynamic>>> getAllUsers() {
    return _firestore
        .collection('users')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'email': data['email'] as String? ?? '',
          'username': data['username'] as String? ?? data['email'] as String? ?? '',
          ...data,
        };
      }).toList();
    });
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return {'id': doc.id, ...doc.data()!};
      }
      return null;
    } catch (e) {
      throw 'Failed to get user: $e';
    }
  }
}
