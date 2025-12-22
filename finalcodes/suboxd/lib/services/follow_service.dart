import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/follow_model.dart';

class FollowService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> getFollowersCount(String userId) async {
    try {
      final followers = await _firestore
          .collection('follows')
          .where('followingId', isEqualTo: userId)
          .get();
      return followers.docs.length;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getFollowingCount(String userId) async {
    try {
      final following = await _firestore
          .collection('follows')
          .where('followerId', isEqualTo: userId)
          .get();
      return following.docs.length;
    } catch (e) {
      return 0;
    }
  }

  Stream<int> followersCountStream(String userId) {
    return _firestore
        .collection('follows')
        .where('followingId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> followingCountStream(String userId) {
    return _firestore
        .collection('follows')
        .where('followerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<List<String>> getFollowers(String userId) {
    return _firestore
        .collection('follows')
        .where('followingId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data()['followerId'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
    });
  }

  Stream<List<String>> getFollowing(String userId) {
    return _firestore
        .collection('follows')
        .where('followerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data()['followingId'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
    });
  }

  Future<void> addFollow(String followerId, String followingId) async {
    try {

      final existing = await _firestore
          .collection('follows')
          .where('followerId', isEqualTo: followerId)
          .where('followingId', isEqualTo: followingId)
          .get();

      if (existing.docs.isEmpty) {
        await _firestore.collection('follows').add({
          'followerId': followerId,
          'followingId': followingId,
          'createdAt': DateTime.now().toUtc(),
        });
      }
    } catch (e) {
      throw 'Failed to add follow: $e';
    }
  }

  Future<void> removeFollow(String followerId, String followingId) async {
    try {
      final follows = await _firestore
          .collection('follows')
          .where('followerId', isEqualTo: followerId)
          .where('followingId', isEqualTo: followingId)
          .get();

      for (var doc in follows.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw 'Failed to remove follow: $e';
    }
  }

  Future<bool> isFollowing(String followerId, String followingId) async {
    try {
      final follows = await _firestore
          .collection('follows')
          .where('followerId', isEqualTo: followerId)
          .where('followingId', isEqualTo: followingId)
          .get();
      return follows.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
