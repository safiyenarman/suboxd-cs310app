import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/courses_provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_schedule_model.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';

const Color bg = Color(0xFF1E2229);
const Color cardColor = Color(0xFF262B33);
const Color primaryColor = Color(0xFF4B8BF4);
const Color dividerColor = Color(0xFF303542);
const Color appBarColor = Color(0xFF15181E);
const Color groupHeaderColor = Color(0xFF303542);

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userId = authProvider.user?.uid;
    final coursesProvider = context.watch<CoursesProvider>();

    if (userId == null) {
      return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Courses'),
        ),
        body: const Center(
          child: Text(
            'Please log in to view your courses',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Courses'),
      ),
      body: StreamBuilder<List<UserSchedule>>(
        stream: coursesProvider.getUserSchedule(userId, 'Fall 2024'), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final schedules = snapshot.data ?? [];
          if (schedules.isEmpty) {
            return const Center(
              child: Text(
                'No courses found. Add courses in Course Planner.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final groupedSchedules = <String, List<UserSchedule>>{};
          for (var schedule in schedules) {
            if (!groupedSchedules.containsKey(schedule.term)) {
              groupedSchedules[schedule.term] = [];
            }
            groupedSchedules[schedule.term]!.add(schedule);
          }

          final allCourses = coursesProvider.courses;

          return ListView.builder(
            itemCount: groupedSchedules.keys.length,
            itemBuilder: (context, termIndex) {
              final term = groupedSchedules.keys.elementAt(termIndex);
              final schedulesInTerm = groupedSchedules[term]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TermHeader(term: term),
                  ...schedulesInTerm.map((schedule) {
                    final course = allCourses.firstWhere(
                      (c) => c.id == schedule.courseId || c.name == schedule.courseName,
                      orElse: () => CourseModel(
                        id: schedule.courseId,
                        name: schedule.courseName,
                        instructor: '',
                        quota: 0,
                        requested: 0,
                        seniorRequested: 0,
                        sessions: [],
                      ),
                    );
                    return _CourseListTile(
                      courseCode: course.name,
                      courseName: course.name,
                      instructor: course.instructor,
                      term: term,
                    );
                  }).toList(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}


class _TermHeader extends StatelessWidget {
  final String term;

  const _TermHeader({required this.term});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      color: groupHeaderColor,
      child: Text(
        term,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _CourseListTile extends StatelessWidget {
  final String courseCode;
  final String courseName;
  final String instructor;
  final String term;

  const _CourseListTile({
    required this.courseCode,
    required this.courseName,
    required this.instructor,
    required this.term,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 90,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/${courseCode.toLowerCase().replaceAll(' ', '')}.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(Icons.menu_book, color: primaryColor.withOpacity(0.8), size: 24),
                        );
                      },
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        courseCode,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        instructor.isNotEmpty ? instructor : 'No instructor',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    courseName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 80),
          child: Divider(height: 1, color: dividerColor),
        ),
      ],
    );
  }
}