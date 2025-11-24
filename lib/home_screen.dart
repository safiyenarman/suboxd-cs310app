import 'package:flutter/material.dart';
import 'all_courses_screen.dart';
import 'friends_activity_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF1C2128);

    const popularThisTermImages = [
      'assets/courses/acc201.png',
      'assets/courses/cs204.png',
      'assets/courses/cs303.png',
      'assets/courses/cs411.png',
    ];

    const popularWithFriendsImages = [
      'assets/courses/ns102.png',
      'assets/courses/acc201.png',
      'assets/courses/cs204.png',
      'assets/courses/cs303.png',
    ];

    return Scaffold(
      backgroundColor: backgroundColor,

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
                  _TabItem(
                    label: "Profile",
                    selected: true,
                    onTap: () {
                      // şimdilik hiçbir şey yapmıyor, zaten buradasın
                    },
                  ),
                  const _TabDivider(),
                  _TabItem(
                    label: "Courses",
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
                  const _TabItem(label: "Reviews"),
                  const _TabDivider(),
                  const _TabItem(label: "Plan to Take"),
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
                  imagePath: 'assets/courses/hum201.png',
                  username: 'ranakeles',
                ),
                SizedBox(width: 12),
                _FriendCourseCard(
                  width: 90,
                  height: 120,
                  imagePath: 'assets/courses/math306.png',
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

      // BOTTOM NAV
      bottomNavigationBar: Container(
        height: 56,
        decoration: const BoxDecoration(
          color: Color(0xFF2C323A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: 30,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B8DFF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SearchScreen(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.search_rounded,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.greenAccent,
                      width: 1.4,
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.greenAccent,
                    size: 20,
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Icon(
                  Icons.bolt,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Icon(
                  Icons.person_outline,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
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
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          )
              : null,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? Colors.white : Colors.grey[300],
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
      color: Colors.white24,
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