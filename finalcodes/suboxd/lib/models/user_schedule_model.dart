import 'package:cloud_firestore/cloud_firestore.dart';

class UserSchedule {
  final String id;
  final String userId;
  final String courseId;
  final String courseName;
  final DateTime createdAt;
  final String term;

  UserSchedule({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.courseName,
    required this.createdAt,
    required this.term,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'courseId': courseId,
      'courseName': courseName,
      'createdAt': createdAt.toUtc(),
      'term': term,
    };
  }

  factory UserSchedule.fromDoc(String id, Map<String, dynamic> data) {
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

    return UserSchedule(
      id: id,
      userId: data['userId'] as String? ?? '',
      courseId: data['courseId'] as String? ?? '',
      courseName: data['courseName'] as String? ?? '',
      createdAt: createdAt,
      term: data['term'] as String? ?? '',
    );
  }
}
