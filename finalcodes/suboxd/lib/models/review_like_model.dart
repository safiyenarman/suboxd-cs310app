import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewLike {
  final String id;
  final String reviewId;
  final String userId;
  final DateTime createdAt;

  ReviewLike({
    required this.id,
    required this.reviewId,
    required this.userId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'reviewId': reviewId,
      'userId': userId,
      'createdAt': createdAt.toUtc(),
    };
  }

  factory ReviewLike.fromDoc(String id, Map<String, dynamic> data) {
    final rawCreatedAt = data['createdAt'];
    DateTime createdAt;
    if (rawCreatedAt is Timestamp) {
      createdAt = rawCreatedAt.toDate();
    } else if (rawCreatedAt is DateTime) {
      createdAt = rawCreatedAt;
    } else {
      createdAt =
          DateTime.tryParse(rawCreatedAt?.toString() ?? '') ?? DateTime.now();
    }

    return ReviewLike(
      id: id,
      reviewId: data['reviewId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      createdAt: createdAt,
    );
  }
}
