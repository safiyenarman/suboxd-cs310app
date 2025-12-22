import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteCourse {
  final String id;
  final String userId;
  final String courseCode;
  final String courseName;
  final String imageAsset;
  final DateTime createdAt;

  FavoriteCourse({
    required this.id,
    required this.userId,
    required this.courseCode,
    required this.courseName,
    required this.imageAsset,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'courseCode': courseCode,
      'courseName': courseName,
      'imageAsset': imageAsset,
      'createdAt': createdAt.toUtc(),
    };
  }

  factory FavoriteCourse.fromDoc(String id, Map<String, dynamic> data) {
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

    return FavoriteCourse(
      id: id,
      userId: data['userId'] as String? ?? '',
      courseCode: data['courseCode'] as String? ?? '',
      courseName: data['courseName'] as String? ?? '',
      imageAsset: data['imageAsset'] as String? ?? '',
      createdAt: createdAt,
    );
  }
}
