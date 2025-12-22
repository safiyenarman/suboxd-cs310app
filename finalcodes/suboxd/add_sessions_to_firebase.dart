// Helper script to add sessions to courses in Firebase
// Run this once to populate session data for courses that don't have it
// 
// Usage: This is a reference script. You can adapt it or manually add sessions in Firebase Console

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;
  final coursesRef = firestore.collection('courses');

  // Example: Add sessions to CS201
  // Replace with actual schedule times for each course
  final courseSessions = {
    'CS201': [
      {'day': 'Monday', 'time': '09:40'},
      {'day': 'Monday', 'time': '10:40'},
    ],
    'CS303': [
      {'day': 'Tuesday', 'time': '10:40'},
      {'day': 'Thursday', 'time': '10:40'},
    ],
    'CS305': [
      {'day': 'Monday', 'time': '13:40'},
      {'day': 'Wednesday', 'time': '13:40'},
    ],
    'CS400': [
      {'day': 'Tuesday', 'time': '14:40'},
      {'day': 'Thursday', 'time': '14:40'},
    ],
    'CS404': [
      {'day': 'Monday', 'time': '15:40'},
      {'day': 'Wednesday', 'time': '15:40'},
    ],
    'ACC201': [
      {'day': 'Tuesday', 'time': '09:40'},
      {'day': 'Thursday', 'time': '09:40'},
    ],
    'MATH306': [
      {'day': 'Monday', 'time': '11:40'},
      {'day': 'Wednesday', 'time': '11:40'},
    ],
  };

  for (var entry in courseSessions.entries) {
    final courseId = entry.key;
    final sessions = entry.value;

    try {
      // Check if course exists
      final doc = await coursesRef.doc(courseId).get();
      if (!doc.exists) {
        print('Course $courseId does not exist, skipping...');
        continue;
      }

      // Check if sessions already exist
      final existingSessions = doc.data()?['sessions'];
      if (existingSessions != null && (existingSessions as List).isNotEmpty) {
        print('Course $courseId already has sessions, skipping...');
        continue;
      }

      // Add sessions
      await coursesRef.doc(courseId).update({
        'sessions': sessions,
      });

      print('✓ Added sessions to $courseId');
    } catch (e) {
      print('✗ Error adding sessions to $courseId: $e');
    }
  }

  print('\nDone! All sessions have been added.');
}

