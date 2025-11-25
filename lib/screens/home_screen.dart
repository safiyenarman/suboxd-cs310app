import 'package:flutter/material.dart';
import 'all_courses_screen.dart';
import 'friends_activity_screen.dart';
import 'search_screen.dart';
import 'profile_screen.dart'; // Rota adı için gerekli
import '../routes.dart'; // Rota sabitleri için gerekli
import 'course_planner_screen.dart'; // Rotayı kullanmak için import edildi

// Diğer ekranlarla uyumlu renk sabitleri
const Color primaryColor = Color(0xFF4B8BF4);
const Color bottomBarColor = Color(0xFF485365);
const Color tabSelected = Color(0xFF4B8BF4);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF1C2128);

    // 1. Asset yolları güncellendi
    const popularThisTermImages = [
      'assets/acc201.png',
      'assets/cs204.png',
      'assets/cs303.png',
      'assets/cs411.png',
    ];

    // 1. Asset yolları güncellendi
    const popularWithFriendsImages = [
      'assets/ns102.png',
      'assets/acc201.png',
      'assets/cs204.png',
      'assets/cs303.png',
    ];

    final bottomNavBar = BottomNavigationBar(
      // Renk sabitlerinin tanımlı olduğundan emin olun.
      backgroundColor: bottomBarColor,
      type: BottomNavigationBarType.fixed,
      currentIndex: 0, // Home (Index 0) seçili
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      items: const [
        // Index 0: Home
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
        // Index 1: Search
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        // Index 2: Add (Review Ekleme)
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, color: Colors.greenAccent),
          label: '',
        ),
        // Index 3: Friends Activity
        BottomNavigationBarItem(icon: Icon(Icons.flash_on_outlined), label: ''),
        // Index 4: Profile
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
      ],

      onTap: (index) {
        // Alt Bar Navigasyonları
        switch (index) {
          case 0:
          // Home ekranına git
          // Zaten Home ekranında olsanız bile, bu yöntem stack'i temizler.
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.home, (route) => false);
            break;

          case 1:
          // Search ekranına git
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.search, (route) => false);
            break;

          case 2:
          // ⭐️ ADD REVIEW (EKLE) EKRANINA GİT
          // Bu bir form/modal olduğu için stack'i temizlemiyoruz (pushNamed yeterli).
          // Böylece formdan geri tuşuyla Home ekranına dönebiliriz.
            Navigator.pushNamed(context, Routes.addReview);
            break;

          case 3:
          // Friends Activity ekranına git
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.friendsActivity, (route) => false);
            break;

          case 4:
          // Profile ekranına git
            Navigator.pushNamedAndRemoveUntil(
                context, ProfileScreen.routeName, (route) => false);
            break;
        }
      },
    );

    return Scaffold(
      backgroundColor: backgroundColor,

      // BOTTOM NAV
      bottomNavigationBar: bottomNavBar,

      // TOP BAR
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'SUboxd',
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
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
            color: Colors.black,
            child: Container(
              height: 26,
              decoration: BoxDecoration(
                color: const Color(0xFF2C323A),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  // Profile (Seçili değil, basınca ProfileScreen'e gidecek)
                  _TabItem(
                    label: "Profile",
                    selected: false, // 2. Artık seçili değil
                    onTap: () {
                      // 2. Profile ekranına yönlendirme
                      Navigator.pushNamed(context, ProfileScreen.routeName);
                    },
                  ),
                  const _TabDivider(),
                  // Courses
                  _TabItem(
                    label: "Courses",
                    selected: false, // 2. Artık seçili değil
                    onTap: () {
                      // 🔹 COURSES TAB → CoursesGridScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CoursesGridScreen(),
                        ),
                      );
                    },
                  ),
                  const _TabDivider(),
                  // Reviews
                   _TabItem(
                    label: "Reviews",
                    selected: false, // 2. Artık seçili değil
                     onTap: () {
                       // 2. Plan to Take (Course Planner) ekranına yönlendirme
                       Navigator.pushNamed(context, Routes.reviews);
                     },
                  ),
                  const _TabDivider(),
                  // Plan to Take
                  _TabItem(
                    label: "Plan to Take",
                    selected: false, // 2. Artık seçili değil
                    onTap: () {
                      // 2. Plan to Take (Course Planner) ekranına yönlendirme
                      Navigator.pushNamed(context, Routes.coursePlanner);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // BODY
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // POPULAR THIS TERM
          const _SectionHeader(title: 'Popular this term'),
          const SizedBox(height: 8),
          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: popularThisTermImages.length,
              itemBuilder: (context, index) => _CourseCard(
                width: 90,
                height: 120,
                imagePath: popularThisTermImages[index],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // NEW FROM FRIENDS → TIKLANINCA FRIENDS ACTIVITY
          _SectionHeader(
            title: 'New from friends',
            onTap: () {
              // 🔹 NEW FROM FRIENDS HEADER → FriendsActivityScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FriendsActivityScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _FriendCourseCard(
                  width: 90,
                  height: 120,
                  imagePath: 'assets/hum201.png', // 1. Asset yolu düzeltildi
                  username: 'ranakeles',
                ),
                SizedBox(width: 12),
                _FriendCourseCard(
                  width: 90,
                  height: 120,
                  imagePath: 'assets/math306.png', // 1. Asset yolu düzeltildi
                  username: 'pirildeniz',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // POPULAR WITH FRIENDS
          const _SectionHeader(title: 'Popular with friends'),
          const SizedBox(height: 8),
          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: popularWithFriendsImages.length,
              itemBuilder: (context, index) => _CourseCard(
                width: 90,
                height: 120,
                imagePath: popularWithFriendsImages[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---- TOP TAB COMPONENTS ---- //

class _TabItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _TabItem({
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: selected
              ? BoxDecoration(
            color: tabSelected,
            borderRadius: BorderRadius.circular(14),
          )
              : null, // selected false iken arka plan renkli olmayacak
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                // selected false iken Colors.white70 olacak
                color: selected ? Colors.white : Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabDivider extends StatelessWidget {
  const _TabDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 18,
      color: const Color(0xFF303542), // Divider rengi diğer ekranlara uyarlandı
    );
  }
}

// ---- SECTION HEADER (TIKLANABİLİR) ---- //

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const _SectionHeader({
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Text(
          '>',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18,
          ),
        ),
      ],
    );

    if (onTap == null) return row;

    return InkWell(
      onTap: onTap,
      child: row,
    );
  }
}

// ---- KARTLAR ---- //

class _CourseCard extends StatelessWidget {
  final double width, height;
  final String imagePath;

  const _CourseCard({
    required this.width,
    required this.height,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _FriendCourseCard extends StatelessWidget {
  final double width, height;
  final String imagePath;
  final String username;

  const _FriendCourseCard({
    required this.width,
    required this.height,
    required this.imagePath,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, // 90
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // course görseli
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              imagePath,
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const CircleAvatar(
                radius: 10,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  size: 12,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                username,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}