import 'package:flutter/material.dart';

const Color bg = Color(0xFF1E2229);
const Color cardColor = Color(0xFF262B33);
const Color primaryColor = Color(0xFF4B8BF4);
const Color appBarColor = Color(0xFF15181E);
const Color tabSelected = Color(0xFF4B8BF4);
const Color tabUnselected = Color(0xFF343A45);
const Color bottomBarColor = Color(0xFF485365);
const Color dividerColor = Color(0xFF303542);

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
    this.term = '',
  });
}

class CoursesGridScreen extends StatelessWidget {
  const CoursesGridScreen({super.key});

  // Course List
  final List<Course> _allCourses = const [
    Course(
      code: 'ACC 201',
      name: 'Accounting Fundamentals',
      instructor: 'Instructor',
      imagePath: 'assets/courses/acc201.png',
    ),
    Course(
      code: 'CS 303',
      name: 'Logic and Digital System Design',
      instructor: 'Instructor',
      imagePath: 'assets/courses/cs303.png',
    ),
    Course(
      code: 'HUM 201',
      name: 'Major Works of Literature',
      instructor: 'Instructor',
      imagePath: 'assets/courses/hum201.png',
    ),
    Course(
      code: 'MATH 306',
      name: 'Statistics',
      instructor: 'Instructor',
      imagePath: 'assets/courses/math306.png',
    ),
    Course(
      code: 'NS 102',
      name: 'Science of Nature II',
      instructor: 'Instructor',
      imagePath: 'assets/courses/ns102.png',
    ),
    Course(
      code: 'CS 204',
      name: 'Advanced Programming',
      instructor: 'Instructor',
      imagePath: 'assets/courses/cs204.png',
    ),
    Course(
      code: 'CS 411',
      name: 'Machine Learning',
      instructor: 'Instructor',
      imagePath: 'assets/courses/cs411.png',
    ),
    Course(
      code: 'ACC 201',
      name: 'Accounting Fundamentals',
      instructor: 'Instructor',
      imagePath: 'assets/courses/acc201.png',
    ),
    Course(
      code: 'CS 303',
      name: 'Logic and Digital System Design',
      instructor: 'Instructor',
      imagePath: 'assets/courses/cs303.png',
    ),
    Course(
      code: 'HUM 201',
      name: 'Major Works of Literature',
      instructor: 'Instructor',
      imagePath: 'assets/courses/hum201.png',
    ),
    Course(
      code: 'MATH 306',
      name: 'Statistics',
      instructor: 'Instructor',
      imagePath: 'assets/courses/math306.png',
    ),
    Course(
      code: 'NS 102',
      name: 'Science of Nature II',
      instructor: 'Instructor',
      imagePath: 'assets/courses/ns102.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        centerTitle: true,
        title: const Text('Courses'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs (Taken, Plan to Take, etc.)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              children: const [
                _CoursesTab(label: 'Taken', isSelected: true),
                SizedBox(width: 8),
                _CoursesTab(label: 'Plan to take'),
                SizedBox(width: 8),
                _CoursesTab(label: 'Favorites'),
              ],
            ),
          ),

          const Divider(color: dividerColor, height: 1),

          // Grid of courses
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _allCourses.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 sütun
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.55,
              ),
              itemBuilder: (context, index) {
                final course = _allCourses[index];
                return _CourseCard(course: course);
              },
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: const _CoursesBottomNavBar(),
    );
  }
}

// Tab Widget
class _CoursesTab extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _CoursesTab({
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? tabSelected : tabUnselected,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// Course Card Widget
class _CourseCard extends StatelessWidget {
  final Course course;

  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Course image or placeholder
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                course.imagePath,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      course.code,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        const SizedBox(height: 4),

        // Course code
        Text(
          course.code,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Course name
        Text(
          course.name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }
}

// Bottom Navigation Bar
class _CoursesBottomNavBar extends StatelessWidget {
  const _CoursesBottomNavBar();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: bottomBarColor,
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_outlined),
          label: '',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, color: Colors.greenAccent),
          label: '',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.flash_on_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
      ],
      onTap: (index) {
        // Navigation
      },
    );
  }
}