import 'package:flutter/material.dart';

const Color bg = Color(0xFF1E2229);
const Color cardColor = Color(0xFF262B33);
const Color primaryColor = Color(0xFF4B8BF4);
const Color dividerColor = Color(0xFF303542);
const Color appBarColor = Color(0xFF15181E);
const Color groupHeaderColor = Color(0xFF303542);

class Course {
  final String code;
  final String name;
  final String instructor;
  final String imagePath;
  final String term;

  const Course({
    required this.code,
    required this.name,
    required this.instructor,
    required this.imagePath,
    required this.term,
  });
}

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  final List<Course> _allCourses = const [
    Course(code: 'HUM 201', name: 'Major Works of Literature', instructor: 'Zeynep Nevin Yelçe', imagePath: 'assets/courses/hum201.png', term: 'FALL 2025 - 2026'),
    Course(code: 'CS 303', name: 'Logic and Digital System Design', instructor: 'Özcan Öztürk', imagePath: 'assets/courses/cs303.png', term: 'FALL 2025 - 2026'),
    Course(code: 'PSY 201', name: 'Mind and Behavior', instructor: 'Çiğdem Bağcı', imagePath: 'assets/courses/psy201.png', term: 'FALL 2025 - 2026'),
    Course(code: 'CS 204', name: 'Advanced Programming', instructor: 'Kamer Kaya', imagePath: 'assets/courses/cs204.png', term: 'FALL 2025 - 2026'),
    Course(code: 'NS 102', name: 'Science of Nature II', instructor: 'Çiğdem Altıntaş', imagePath: 'assets/courses/ns102.png', term: 'SUMMER 2025'),
    Course(code: 'SPS 102', name: 'Humanity and Society II', instructor: 'Melike Ayşe Kocacık Şenol', imagePath: 'assets/courses/sps102.png', term: 'SUMMER 2025'),
  ];

  @override
  Widget build(BuildContext context) {
    // grouping according to term
    final groupedCourses = _groupCoursesByTerm(_allCourses);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        // back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            Navigator.pop(context); // Goes to the previous page
          },
        ),
        title: const Text('Courses'),
      ),
      // No app bar

      body: ListView.builder(
        itemCount: groupedCourses.keys.length,
        itemBuilder: (context, termIndex) {
          final term = groupedCourses.keys.elementAt(termIndex);
          final coursesInTerm = groupedCourses[term]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _TermHeader(term: term),

              // Course list at that semester
              ...coursesInTerm.map((course) {
                return _CourseListTile(course: course);
              }).toList(),
            ],
          );
        },
      ),
    );
  }

  // Function for grouping the courses
  Map<String, List<Course>> _groupCoursesByTerm(List<Course> courses) {
    final Map<String, List<Course>> groups = {};
    for (var course in courses) {
      if (!groups.containsKey(course.term)) {
        groups[course.term] = [];
      }
      groups[course.term]!.add(course);
    }
    return groups;
  }
}

/// Semester (FALL 2025 - 2026 / SUMMER 2025)
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

/// Course List
class _CourseListTile extends StatelessWidget {
  final Course course;

  const _CourseListTile({required this.course});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // Navigations
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
                      course.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(Icons.menu_book, color: primaryColor.withOpacity(0.8), size: 24),
                        );
                      },
                    ),
                  ),
                ),

                // Course code, instructor name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.code,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        course.instructor,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Course name
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    course.name,
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
        // Divider
        const Padding(
          padding: EdgeInsets.only(left: 80),
          child: Divider(height: 1, color: dividerColor),
        ),
      ],
    );
  }
}
