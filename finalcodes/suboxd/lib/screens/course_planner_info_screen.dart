import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course_model.dart';
import '../providers/courses_provider.dart';

class CoursePlannerInfoScreen extends StatefulWidget {
  const CoursePlannerInfoScreen({super.key});

  @override
  State<CoursePlannerInfoScreen> createState() => _CoursePlannerInfoScreenState();
}

class _CoursePlannerInfoScreenState extends State<CoursePlannerInfoScreen> {
  final String _currentTerm = "Fall 2024"; 
  Map<String, Map<String, int>> _courseCounts = {};

  @override
  void initState() {
    super.initState();
    _loadCourseCounts();
  }

  Future<void> _loadCourseCounts() async {
    final courses =
        ModalRoute.of(context)!.settings.arguments as List<CourseModel>;
    final coursesProvider = Provider.of<CoursesProvider>(context, listen: false);

    final Map<String, Map<String, int>> counts = {};
    for (var course in courses) {
      final countData = await coursesProvider.getCourseRequestedCounts(
        course.id,
        _currentTerm,
      );
      counts[course.id] = {'requested': countData['requested'] ?? 0};
    }

    if (mounted) {
      setState(() {
        _courseCounts = counts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final courses =
        ModalRoute.of(context)!.settings.arguments as List<CourseModel>;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF15181E),
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Back",
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        title: const Text("Selected Courses"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("You selected:",
                style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 12),
            ...courses.map((c) => _buildCourseCard(c)),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(CourseModel c) {
    final counts = _courseCounts[c.id] ?? {'requested': c.requested};
    final requested = counts['requested'] ?? c.requested;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF262B33),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(c.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Instructor: ${c.instructor}",
              style: const TextStyle(color: Colors.white70)),
          Text("Quota: ${c.quota}",
              style: const TextStyle(color: Colors.white70)),
          Text("Requested: $requested",
              style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          ...c.sessions.map((s) => Text(
                "• ${s.day} at ${s.time}",
                style: const TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }
}
