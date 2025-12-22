import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/course_model.dart';
import '../models/user_schedule_model.dart';
import '../services/course_service.dart';

class CoursesProvider extends ChangeNotifier {
  final CourseService _courseService = CourseService();
  List<CourseModel> _courses = [];
  bool _loading = false;
  String? _error;

  List<CourseModel> get courses => _courses;
  bool get loading => _loading;
  String? get error => _error;

  CoursesProvider() {
    loadCourses();
  }

  void loadCourses() {
    _loading = true;
    _error = null;
    notifyListeners();

    _courseService.getAllCourses().listen(
      (courses) {
        _courses = courses;
        _loading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _loading = false;
        _error = e.toString();
        print('Error loading courses: $e');
        notifyListeners();
      },
      cancelOnError: false,
    );
  }

  Future<void> saveUserSchedule(String userId, List<String> courseIds,
      List<String> courseNames, String term) async {
    try {
      await _courseService.saveUserSchedule(userId, courseIds, courseNames, term);
    } catch (e) {
      throw e;
    }
  }

  Stream<List<UserSchedule>> getUserSchedule(String userId, String term) {
    return _courseService.getUserSchedule(userId, term);
  }

  Future<Map<String, int>> getCourseRequestedCounts(
      String courseId, String term) async {
    return await _courseService.getCourseRequestedCounts(courseId, term);
  }
}
