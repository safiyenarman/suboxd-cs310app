import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';
import '../models/user_schedule_model.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<CourseModel>> getAllCourses() {
    return _firestore
        .collection('courses')
        .snapshots()
        .map((snapshot) {
          final courses = <CourseModel>[];
          print('Total documents in courses collection: ${snapshot.docs.length}');
          for (var doc in snapshot.docs) {
            try {
              final course = CourseModel.fromDoc(doc.id, doc.data());

              courses.add(course);
              final sessionInfo = course.sessions.isEmpty
                  ? ' (no sessions)'
                  : ' (${course.sessions.length} sessions)';
              print('Successfully loaded course: ${course.name} (${doc.id})$sessionInfo');
            } catch (e, stackTrace) {
              print('Error parsing course ${doc.id}: $e');
              print('Stack trace: $stackTrace');
              print('Course data: ${doc.data()}');

              try {
                final minimalCourse = CourseModel(
                  id: doc.id,
                  name: doc.id,
                  instructor: '',
                  quota: 0,
                  requested: 0,
                  seniorRequested: 0,
                  sessions: [],
                );
                courses.add(minimalCourse);
                print('Added minimal course for ${doc.id}');
              } catch (e2) {
                print('Failed to create minimal course for ${doc.id}: $e2');
              }
            }
          }
          print('Total courses loaded: ${courses.length}');
          return courses;
        });
  }

  Future<CourseModel?> getCourseById(String courseId) async {
    try {
      final doc = await _firestore
          .collection('courses')
          .doc(courseId)
          .withConverter<CourseModel>(
            fromFirestore: (snap, _) =>
                CourseModel.fromDoc(snap.id, snap.data() ?? {}),
            toFirestore: (course, _) => course.toMap(),
          )
          .get();
      return doc.data();
    } catch (e) {
      return null;
    }
  }

  Future<void> saveUserSchedule(String userId, List<String> courseIds,
      List<String> courseNames, String term) async {
    try {

      final existingSchedules = await _firestore
          .collection('userSchedules')
          .where('userId', isEqualTo: userId)
          .where('term', isEqualTo: term)
          .get();

      final batch = _firestore.batch();
      for (var doc in existingSchedules.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      final newBatch = _firestore.batch();
      for (int i = 0; i < courseIds.length; i++) {
        final scheduleRef = _firestore.collection('userSchedules').doc();
        final schedule = UserSchedule(
          id: scheduleRef.id,
          userId: userId,
          courseId: courseIds[i],
          courseName: courseNames[i],
          createdAt: DateTime.now(),
          term: term,
        );
        newBatch.set(scheduleRef, schedule.toMap());
      }
      await newBatch.commit();

      await _updateCourseRequestedCounts(courseIds, term);
    } catch (e) {
      throw 'Failed to save schedule: $e';
    }
  }

  Stream<List<UserSchedule>> getUserSchedule(String userId, String term) {
    return _firestore
        .collection('userSchedules')
        .where('userId', isEqualTo: userId)
        .where('term', isEqualTo: term)
        .withConverter<UserSchedule>(
          fromFirestore: (snap, _) =>
              UserSchedule.fromDoc(snap.id, snap.data() ?? {}),
          toFirestore: (schedule, _) => schedule.toMap(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((d) => d.data()).toList());
  }

  Future<void> _updateCourseRequestedCounts(
      List<String> courseIds, String term) async {
    try {
      for (var courseId in courseIds) {

        final requests = await _firestore
            .collection('userSchedules')
            .where('courseId', isEqualTo: courseId)
            .where('term', isEqualTo: term)
            .get();

        int totalCount = requests.docs.length;
        int seniorCount = 0;

        for (var scheduleDoc in requests.docs) {
          final userId = scheduleDoc.data()['userId'] as String?;
          if (userId != null) {
            try {
              final userDoc =
                  await _firestore.collection('users').doc(userId).get();
              final userData = userDoc.data();

              final isSenior = userData?['isSenior'] as bool? ?? false;
              if (isSenior) seniorCount++;
            } catch (e) {

              continue;
            }
          }
        }

        await _firestore.collection('courses').doc(courseId).update({
          'requested': totalCount,
          'seniorRequested': seniorCount,
        });
      }
    } catch (e) {

      print('Error updating course counts: $e');
    }
  }

  Future<Map<String, int>> getCourseRequestedCounts(
      String courseId, String term) async {
    try {
      final requests = await _firestore
          .collection('userSchedules')
          .where('courseId', isEqualTo: courseId)
          .where('term', isEqualTo: term)
          .get();

      int totalCount = requests.docs.length;
      int seniorCount = 0;

      for (var scheduleDoc in requests.docs) {
        final userId = scheduleDoc.data()['userId'] as String?;
        if (userId != null) {
          try {
            final userDoc =
                await _firestore.collection('users').doc(userId).get();
            final userData = userDoc.data();
            final isSenior = userData?['isSenior'] as bool? ?? false;
            if (isSenior) seniorCount++;
          } catch (e) {

            continue;
          }
        }
      }

      return {
        'requested': totalCount,
        'seniorRequested': seniorCount,
      };
    } catch (e) {
      return {'requested': 0, 'seniorRequested': 0};
    }
  }
}
