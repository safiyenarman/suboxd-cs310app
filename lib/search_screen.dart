import 'package:flutter/material.dart';

const Color bg = Color(0xFF1E2229);
const Color cardColor = Color(0xFF262B33);
const Color primaryColor = Color(0xFF4B8BF4);
const Color dividerColor = Color(0xFF303542);
const Color appBarColor = Color(0xFF15181E);
const Color bottomBarColor = Color(0xFF485365);
const Color tabSelected = Color(0xFF4B8BF4);
const Color tabUnselected = Color(0xFF343A45);

class Course {
  final String code;
  final String name;
  final String instructor;
  final String image;

  const Course({required this.code, required this.name, required this.instructor, required this.image});
}

/// Search Screen
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Temp course list
  final List<Course> _allCourses = [
    const Course(code: 'CS 201', name: 'Programming Fundamentals', instructor: 'Salma Gül', image: 'assets/courses/cs201.png'),
    const Course(code: 'CS 204', name: 'Advanced Programming', instructor: 'Kamer Kaya', image: 'assets/courses/cs204.png'),
    const Course(code: 'CS 300', name: '    Data Structures', instructor: 'Cemal Yılmaz', image: 'assets/courses/cs300.png'),
    const Course(code: 'CS 301', name: '       Algorithms', instructor: 'Esra Erdem', image: 'assets/courses/cs301.png'),
    const Course(code: 'CS 302', name: 'Formal Languages and Automata Theory', instructor: 'Kemal İnan', image: 'assets/courses/cs302.png'),
    const Course(code: 'CS 303', name: 'Logic and Digital System Design', instructor: 'Özcan Öztürk', image: 'assets/courses/cs303.png'),
    const Course(code: 'CS 305', name: 'Programming Languages', instructor: 'Hüsnü Yenigün', image: 'assets/courses/cs305.png'),
  ];

  List<Course> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _filteredCourses = _allCourses;
    _searchController.addListener(_filterCourses);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCourses() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCourses = _allCourses.where((course) {
        final codeLower = course.code.toLowerCase();
        final nameLower = course.name.toLowerCase();
        final instructorLower = course.instructor.toLowerCase();
        return codeLower.contains(query) || nameLower.contains(query) || instructorLower.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavBar = BottomNavigationBar(
      backgroundColor: bottomBarColor,
      type: BottomNavigationBarType.fixed,
      currentIndex: 1,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, color: Colors.greenAccent),
          label: '',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.flash_on_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
      ],
      onTap: (index) {},
    );

    return Scaffold(
      backgroundColor: bg,
      bottomNavigationBar: bottomNavBar,
      body: SafeArea(
        child: Column(
          children: [
            // search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: appBarColor,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'CS',
                          hintStyle: TextStyle(color: Colors.white54, fontSize: 18),
                          prefixIcon: Icon(Icons.search, color: Colors.white54),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: dividerColor),

            // Course list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _filteredCourses.length,
                itemBuilder: (context, index) {
                  final course = _filteredCourses[index];
                  return _CourseListTile(
                    course: course,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseListTile extends StatelessWidget {
  final Course course;

  const _CourseListTile({required this.course});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Clicking
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // images
            Container(
              width: 75,
              height: 110,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  course.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.code, color: Colors.greenAccent, size: 30));
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: SizedBox(
                height: 110,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.code,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      course.instructor,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Course name
            Flexible(
              child: Text(
                course.name.trim(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}