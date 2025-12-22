import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'all_courses_screen.dart';
import 'friends_activity_screen.dart';
import 'profile_screen.dart';
import '../routes.dart'; 
import '../providers/reviews_provider.dart';
import '../models/review_model.dart';

const Color primaryColor = Color(0xFF4B8BF4);
const Color bottomBarColor = Color(0xFF485365);
const Color tabSelected = Color(0xFF4B8BF4);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF1C2128);

    final bottomNavBar = BottomNavigationBar(
      backgroundColor: bottomBarColor,
      type: BottomNavigationBarType.fixed,
      currentIndex: 0, 
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, color: Colors.greenAccent),
          label: '',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.flash_on_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
      ],

      onTap: (index) {
        
        switch (index) {
          case 0:
            
              context,
              Routes.home,
              (route) => false,
            );
            break;

          case 1:
            
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.search,
              (route) => false,
            );
            break;

          case 2:
            
            Navigator.pushNamed(context, Routes.addReview);
            break;

          case 3:
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.friendsActivity,
              (route) => false,
            );
            break;

          case 4:
            Navigator.pushNamedAndRemoveUntil(
              context,
              ProfileScreen.routeName,
              (route) => false,
            );
            break;
        }
      },
    );

    return Scaffold(
      backgroundColor: backgroundColor,

      bottomNavigationBar: bottomNavBar,

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
                    selected: false, 
                    onTap: () {
                      Navigator.pushNamed(context, ProfileScreen.routeName);
                    },
                  ),
                  const _TabDivider(),
                  _TabItem(
                    label: "Courses",
                    selected: false, 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CoursesGridScreen(),
                        ),
                      );
                    },
                  ),
                  const _TabDivider(),
                  _TabItem(
                    label: "Reviews",
                    selected: false, 
                    onTap: () {
                      Navigator.pushNamed(context, Routes.reviews);
                    },
                  ),
                  const _TabDivider(),
                  _TabItem(
                    label: "Plan to Take",
                    selected: false, 
                    onTap: () {
                      Navigator.pushNamed(context, Routes.coursePlanner);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          const _SectionHeader(title: 'Popular this term'),
          const SizedBox(height: 8),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: context.read<ReviewsProvider>().getCoursesByReviewCount(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 150,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              
              final courses = snapshot.data ?? [];
              if (courses.isEmpty) {
                return const SizedBox(
                  height: 150,
                  child: Center(
                    child: Text(
                      'No reviews yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }
              
              return SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: courses.length > 4 ? 4 : courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return _CourseCardWithName(
                      width: 90,
                      height: 120,
                      imagePath: course['imageAsset'] as String? ?? '',
                      courseCode: course['courseCode'] as String? ?? '',
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          _SectionHeader(
            title: 'New from friends',
            onTap: () {
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
                  imagePath: 'assets/hum201.png', 
                  username: 'ranakeles',
                ),
                SizedBox(width: 12),
                _FriendCourseCard(
                  width: 90,
                  height: 120,
                  imagePath: 'assets/math306.png', 
                  username: 'pirildeniz',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const _SectionHeader(title: 'Popular with friends'),
          const SizedBox(height: 8),
          FutureBuilder<List<Review>>(
            future: context.read<ReviewsProvider>().getReviewsByLikes(limit: 10),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 150,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              
              final reviews = snapshot.data ?? [];
              if (reviews.isEmpty) {
                return const SizedBox(
                  height: 150,
                  child: Center(
                    child: Text(
                      'No reviews yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }
              
              final uniqueCourses = <String, Review>{};
              for (var review in reviews) {
                if (!uniqueCourses.containsKey(review.courseCode)) {
                  uniqueCourses[review.courseCode] = review;
                }
                if (uniqueCourses.length >= 4) break;
              }
              
              return SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: uniqueCourses.length,
                  itemBuilder: (context, index) {
                    final review = uniqueCourses.values.elementAt(index);
                    return _CourseCardWithName(
                      width: 90,
                      height: 120,
                      imagePath: review.imageAsset,
                      courseCode: review.courseCode,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


class _TabItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _TabItem({required this.label, this.selected = false, this.onTap});

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
      color: const Color(0xFF303542),
  }
}


class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const _SectionHeader({required this.title, this.onTap});

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
        const Text('>', style: TextStyle(color: Colors.white70, fontSize: 18)),
      ],
    );

    if (onTap == null) return row;

    return InkWell(onTap: onTap, child: row);
  }
}


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

class _CourseCardWithName extends StatelessWidget {
  final double width, height;
  final String imagePath;
  final String courseCode;

  const _CourseCardWithName({
    required this.width,
    required this.height,
    required this.imagePath,
    required this.courseCode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              imagePath,
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Icon(Icons.image, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: width,
            child: Text(
              courseCode,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
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
      width: width, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                child: Icon(Icons.person, size: 12, color: Colors.white),
              ),
              const SizedBox(width: 6),
              Text(
                username,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
