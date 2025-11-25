import 'package:flutter/material.dart';
import 'package:suboxd/screens/add_review_screen.dart';
import 'package:suboxd/screens/add_review_screen.dart';
import 'settings_screen.dart';
import 'followers_screen.dart';
import 'followings_screen.dart';
import '../routes.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF1E2229);
    const cardColor = Color(0xFF262B33);
    const dividerColor = Color(0xFF303542);
    const primaryColor = Color(0xFF4B8BF4);
    const tabSelected = primaryColor;
    const bottomBarColor = Color(0xFF485365);


    return Scaffold(
      backgroundColor: bg,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.settings, color: Colors.white70),
          onPressed: () {
            Navigator.pushNamed(context, SettingsScreen.routeName);
          },
        ),
        title: const Text(
          'username',
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
            color: Colors.black,
            child: Container(
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFF2C323A),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: _TabItem(
                      label: "Profile",
                      selected: true, 
                    ),
                  ),
                  const _TabDivider(),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.allCourses);
                      },
                      child: const _TabItem(label: "Courses"),
                    ),
                  ),
                  const _TabDivider(),

                  Expanded(
                    child: GestureDetector(
                      onTap: () { //
                        Navigator.pushNamed(context, Routes.reviews);
                      },
                      child: const _TabItem(label: "Reviews", selected: false),
                    ),
                  ),
                  const _TabDivider(),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
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

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: bottomBarColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: 4,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, color: Colors.greenAccent),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ],

        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
              break;
            case 1:
              Navigator.pushNamedAndRemoveUntil(context, Routes.search, (route) => false);
              break;
            case 2:
              Navigator.pushNamed(context, AddReviewScreen.routeName);
              break;
              break;
            case 3:
              Navigator.pushNamedAndRemoveUntil(context, Routes.friendsActivity, (route) => false);
              break;
            case 4:
              break;
            default:
              break;
          }
        },
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.grey.shade700,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Divider(color: dividerColor, height: 24),

                  const Text(
                    'RECENT ACTIVITY',
                    style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: const [
                      _RecentCourseCard(imagePath: 'assets/acc201.png'),
                      SizedBox(width: 8),
                      _RecentCourseCard(imagePath: 'assets/cs303.png'),
                      SizedBox(width: 8),
                      _RecentCourseCard(imagePath: 'assets/cs411.png'),
                      SizedBox(width: 8),
                      _RecentCourseCard(imagePath: 'assets/math306.png'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Column(
              children: [
                const Divider(color: dividerColor, height: 1),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.coursesHistory);
                  },
                  child: Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: const [
                        Expanded(
                          child: Text(
                            'More activity',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const Divider(color: dividerColor, height: 1),
              ],
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  RatingsHistogram(
                    values: [8, 5, 3, 4, 10, 14, 20, 16, 12],
                  ),
                  SizedBox(height: 8),
                  _HistogramRatingRow(),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _ProfileListTile(
              title: 'Courses taken',
              trailingText: '30/5 this semester',
              onTap: () {
                Navigator.pushNamed(context, Routes.coursesHistory);
              },
            ),
            _ProfileListTile(
              title: 'Friends feed',
              trailingIcon: Icons.chevron_right,
              onTap: () {
                Navigator.pushNamed(context, Routes.friendsActivity);
              },
            ),
            const _ProfileListTile(
              title: 'Reviews',
              trailingText: '8',
            ),
            const _ProfileListTile(
              title: 'Ratings',
              trailingText: '15',
            ),

            _ProfileListTile(
              title: 'Course Planner',
              trailingIcon: Icons.chevron_right,
              onTap: () {
                Navigator.pushNamed(context, Routes.coursePlanner);
              },
            ),

            _ProfileListTile(
              title: 'Following Students',
              trailingText: '35',
              onTap: () {
                Navigator.pushNamed(context, FollowingsScreen.routeName);
              },
            ),
            _ProfileListTile(
              title: 'Followers',
              trailingText: '34',
              onTap: () {
                Navigator.pushNamed(context, FollowersScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool selected;

  const _TabItem({
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    const Color tabSelected = Color(0xFF4B8BF4);

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? tabSelected : Colors.transparent,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? Colors.white : Colors.white70,
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
      height: 28,
      color: const Color(0xFF303542),
    );
  }
}


class _RecentCourseCard extends StatelessWidget {
  final String imagePath;
  const _RecentCourseCard({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.grey.shade600,
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}


class RatingsHistogram extends StatelessWidget {
  final List<double> values;
  const RatingsHistogram({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    const List<Color> barColors = [
      Color(0xFF6C7280),
      Color(0xFF747A89),
      Color(0xFF7C8291),
      Color(0xFF858B9A),
      Color(0xFF8D93A3),
      Color(0xFF7E8898),
      Color(0xFF6F7888),
      Color(0xFF707A8A),
      Color(0xFF818A99),
    ];

    const maxBarHeight = 60.0;
    final double maxValue = values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: maxBarHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (i) {
          final v = values[i];
          final barHeight = (v / maxValue) * maxBarHeight;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: barColors[i % barColors.length],
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _HistogramRatingRow extends StatelessWidget {
  const _HistogramRatingRow();

  @override
  Widget build(BuildContext context) {
    const starColor = Colors.lightGreenAccent;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.star, size: 16, color: starColor),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
                (_) => const Icon(Icons.star, size: 18, color: starColor),
          ),
        ),
      ],
    );
  }
}


class _ProfileListTile extends StatelessWidget {
  final String title;
  final String? trailingText;
  final IconData? trailingIcon;
  final VoidCallback? onTap;

  const _ProfileListTile({
    required this.title,
    this.trailingText,
    this.trailingIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const dividerColor = Color(0xFF303542);

    Widget trailing;
    if (trailingText != null) {
      trailing = Text(
        trailingText!,
        style: const TextStyle(color: Colors.grey),
      );
    } else if (trailingIcon != null) {
      trailing = Icon(trailingIcon, color: Colors.grey);
    } else {
      trailing = const SizedBox.shrink();
    }

    return Column(
      children: [
        const Divider(color: dividerColor, height: 1),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          title: Text(
            title,
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: trailing,
          onTap: onTap,
        ),
      ],
    );
  }
}
