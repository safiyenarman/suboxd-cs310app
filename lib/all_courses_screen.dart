import 'package:flutter/material.dart';
import 'package:suboxd/screens/add_review_screen.dart';
import 'package:suboxd/screens/add_review_screen.dart';
import 'package:suboxd/screens/friends_activity_screen.dart';
import 'profile_screen.dart'; // ProfileScreen'e gitmek için import edildi
import 'settings_screen.dart'; // SettingsScreen'e gitmek için import edildi
import '../routes.dart';

const Color bg = Color(0xFF1E2229);
const Color cardColor = Color(0xFF262B33);
const Color primaryColor = Color(0xFF4B8BF4);
const Color appBarColor = Colors.black; // AppBar arka planı Colors.black
const Color tabSelected = Color(0xFF4B8BF4);
const Color tabUnselectedBg = Color(0xFF2C323A); // Sekme arkaplanı
const Color tabUnselected = Color(0xFF343A45);
const Color bottomBarColor = Color(0xFF485365);
const Color dividerColor = Color(0xFF303542);


// ProfileScreen'deki görsel stile uygun hale getirildi.
class _TabItem extends StatelessWidget {
  final String label;
  final bool selected;

  const _TabItem({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Padding kaldırıldı, alignment ile merkezleme yapıldı.
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? tabSelected : Colors.transparent,
        // Dış konteynerin 14 radiusuna uyum sağlaması için 13 kullanıldı.
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.white70,
          // Seçili olanı bold, diğerlerini normal yaparak kontrast sağlandı.
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }
}

// ProfileScreen'den gelen _TabDivider'ın eşleşen tanımı
class _TabDivider extends StatelessWidget {
  const _TabDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: dividerColor,
    );
  }
}


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
  static const routeName = '/all-courses';

  const CoursesGridScreen({super.key});

  // Course List
  final List<Course> _allCourses = const [
    Course(code: 'ACC 201', name: 'Accounting Fundamentals', instructor: 'Instructor', imagePath: 'assets/acc201.png'),
    Course(code: 'CS 303', name: 'Logic and Digital System Design', instructor: 'Instructor', imagePath: 'assets/cs303_2.png'),
    Course(code: 'HUM 201', name: 'Major Works of Literature', instructor: 'Instructor', imagePath: 'assets/hum201.png'),
    Course(code: 'PSY 201', name: 'Mind and Behavior', instructor: 'Instructor', imagePath: 'assets/psy201.png'),
    Course(code: 'CS 204', name: 'Advanced Programming', instructor: 'Instructor', imagePath: 'assets/cs204_2.png'),
    Course(code: 'MATH 306', name: 'Statistics Course', instructor: 'Instructor', imagePath: 'assets/math306_2.png'),
    Course(code: 'TLL 102', name: 'Literature and Language', instructor: 'Instructor', imagePath: 'assets/tll102.png'),
    Course(code: 'NS 102', name: 'Science of Nature II', instructor: 'Instructor', imagePath: 'assets/ns102.png'),
    Course(code: 'SPS 102', name: 'Humanity and Society II', instructor: 'Instructor', imagePath: 'assets/sps102.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,

      // ================== EŞLEŞTİRİLMİŞ APP BAR ==================
      appBar: AppBar(
        backgroundColor: appBarColor, // Colors.black
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.settings, color: Colors.white70),
          onPressed: () {
            // Settings ekranına git
            Navigator.pushNamed(context, SettingsScreen.routeName);
          },
        ),
        title: const Text(
          'username', // Profile sayfasındaki gibi
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        toolbarHeight: 56,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(32),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
            color: appBarColor, // Colors.black
            child: Container(
              height: 28,
              decoration: BoxDecoration(
                // Profile sayfasındaki renk kodu
                color: const Color(0xFF2C323A),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  // Profile
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Profile ekranına git
                        Navigator.pushNamed(context, ProfileScreen.routeName);
                      },
                      child: const _TabItem(label: "Profile"),
                    ),
                  ),
                  const _TabDivider(),

                  // Courses (Şu anki ekran - Seçili)
                  const Expanded(
                    child: _TabItem(label: "Courses", selected: true), // Mavi Seçili
                  ),
                  const _TabDivider(),

                  // Reviews (Courses History'ye yönlendirildi)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Reviews/Courses History ekranına git
                        Navigator.pushNamed(context, Routes.reviews);
                      },
                      child: const _TabItem(label: "Reviews"),
                    ),
                  ),
                  const _TabDivider(),

                  // Plan to Take
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Course Planner ekranına git
                        Navigator.pushNamed(context, Routes.coursePlanner);
                      },
                      child: const _TabItem(label: "Plan to Take"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // =============================================================

      body: SafeArea(
        child: Column(
          children: [
            // Grid view
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _allCourses.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.60,
                ),
                itemBuilder: (context, index) {
                  return _CourseCard(course: _allCourses[index]);
                },
              ),
            ),
          ],
        ),
      ),
      // bottom navigation bar
      bottomNavigationBar: const _CustomBottomNavBar(),
    );
  }
}

// Course Cards
class _CourseCard extends StatelessWidget {
  final Course course;

  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Go to course details
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card image
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  const _CustomBottomNavBar();

  @override
  Widget build(BuildContext context) {
    // Current Index 1 (CoursesGridScreen, yani All Courses)
    return BottomNavigationBar(
      backgroundColor: bottomBarColor,
      type: BottomNavigationBarType.fixed,
      // CoursesGridScreen'de olduğumuz için Search (Index 1) aktif olmalı.
      currentIndex: 1,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      items: const [
        // YENİ EKLENEN HOME İKONU (Index 0)
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),

        // SEARCH İKONU (Index 1) - Bu ekranda Courses'u temsil ediyor
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),

        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, color: Colors.greenAccent),
          label: '',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.flash_on_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
      ],
      onTap: (index) {
        // Indexler güncellendi: Home (0), Search (1), Add (2), Flash (3), Profile (4)
        switch (index) {
          case 0:
          // Home sayfasına git ve stack'i temizle
          // Home rotası main.dart'ta '/home' olarak tanımlı, bu yüzden Routes.home kullanıyoruz.
          // Navigasyon yığınını temizlemek için pushNamedAndRemoveUntil kullanılır.
            Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
            break;
          case 1:
          // Search ekranına git
            Navigator.pushNamed(context, Routes.search);
            break;
          case 2:
            Navigator.pushNamed(context, AddReviewScreen.routeName);
            break;
          case 3:
            Navigator.pushNamed(context, FriendsActivityScreen.routeName);
            break;
          case 4:
          // Profile ekranına git
            Navigator.pushNamed(context, ProfileScreen.routeName);
            break;
          default:
          // Diğer ikonlar şimdilik bir şey yapmıyor
            break;
        }
      },
    );
  }
}