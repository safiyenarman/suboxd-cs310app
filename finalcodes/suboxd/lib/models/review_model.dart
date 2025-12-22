import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String courseCode;
  final String courseName;
  final String username;
  final double rating;
  final String text;
  final DateTime createdAt;
  final int likes;
  final String imageAsset;

  Review({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.username,
    required this.rating,
    required this.text,
    required this.createdAt,
    required this.likes,
    required this.imageAsset,
  });

  Map<String, dynamic> toMap() {
    return {
      'courseCode': courseCode,
      'courseName': courseName,
      'username': username,
      'rating': rating,
      'text': text,
      'createdAt': createdAt.toUtc(),
      'likes': likes,
      'imageAsset': imageAsset,
    };
  }

  factory Review.fromDoc(String id, Map<String, dynamic> data) {
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

    return Review(
      id: id,
      courseCode: data['courseCode'] as String? ?? '',
      courseName: data['courseName'] as String? ?? '',
      username: data['username'] as String? ?? 'anonymous',
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      text: data['text'] as String? ?? '',
      createdAt: createdAt,
      likes: data['likes'] as int? ?? 0,
      imageAsset: data['imageAsset'] as String? ?? '',
    );
  }
}
