import 'package:flutter_test/flutter_test.dart';
import 'package:suboxd/models/course_model.dart';

void main() {
  group('CourseModel and CourseSession Tests', () {

    test('CourseSession.fromMap should normalize day and time formats', () {
      final rawData = {
        'day': 'monday',
        'time': '14.30'
      };

      final session = CourseSession.fromMap(rawData);

      expect(session.day, 'Monday');
      expect(session.time, '14:30');
    });

    test('CourseModel.fromDoc should correctly parse a full course document', () {
      final String mockId = 'CS310_01';
      final Map<String, dynamic> mockData = {
        'name': 'CS310',
        'courseName': 'Mobile Application Development',
        'instructor': 'John Doe',
        'quota': 40,
        'sessions': [
          {'day': 'Tuesday', 'time': '10:00'},
          {'day': 'Thursday', 'time': '10:00'}
        ]
      };

      final course = CourseModel.fromDoc(mockId, mockData);

      expect(course.id, mockId);
      expect(course.name, 'CS310');
      expect(course.sessions.length, 2);
      expect(course.sessions[0].day, 'Tuesday');
    });
  });
}