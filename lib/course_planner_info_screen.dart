import 'package:flutter/material.dart';
import '../models/course_model.dart';

class CoursePlannerInfoScreen extends StatelessWidget {
  const CoursePlannerInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courses =
    ModalRoute.of(context)!.settings.arguments as List<CourseModel>;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF15181E),
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel",
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
          Text("Requested: ${c.requested}",
              style: const TextStyle(color: Colors.white70)),
          Text("Senior Requested: ${c.seniorRequested}",
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
