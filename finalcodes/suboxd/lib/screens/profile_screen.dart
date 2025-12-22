import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suboxd/screens/add_review_screen.dart';
import 'settings_screen.dart';
import 'followers_screen.dart';
import 'followings_screen.dart';
import '../routes.dart';
import '../providers/auth_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/reviews_provider.dart';
import '../providers/courses_provider.dart';
import '../services/follow_service.dart';
import '../services/user_service.dart';
import '../models/favorite_model.dart';
import '../models/user_schedule_model.dart';
import 'dart:convert';

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
        title: Builder(
          builder: (context) {
            final auth = context.watch<AuthProvider>();
            final username = auth.user?.email?.split('@').first ??
                           auth.user?.displayName ??
                           'username';
            return Text(
              username,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            );
          },
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
                      onTap: () {

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

          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),

          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, color: Colors.greenAccent),
            label: '',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on_outlined),
            label: '',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],

        onTap: (index) {

          switch (index) {
            case 0:

              Navigator.pushNamedAndRemoveUntil(
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
              Navigator.pushNamed(context, AddReviewScreen.routeName);
              break;
              break;
            case 3:

              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.friendsActivity,
                (route) => false,
              );
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
                  Builder(
                    builder: (context) {
                      final auth = context.watch<AuthProvider>();
                      final userId = auth.user?.uid;
                      final userService = UserService();

                      if (userId == null) {
                        return Center(
                          child: CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.grey.shade700,
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        );
                      }

                      return StreamBuilder<Map<String, dynamic>?>(
                        stream: userService.userDataStream(userId),
                        builder: (context, snapshot) {
                          final avatarDataUrl = snapshot.data?['avatarUrl'] as String?;

                          return Center(
                            child: FutureBuilder<ImageProvider?>(
                              future: _getAvatarImageProvider(avatarDataUrl),
                              builder: (context, imageSnapshot) {
                                return CircleAvatar(
                                  radius: 36,
                                  backgroundColor: Colors.grey.shade700,
                                  backgroundImage: imageSnapshot.data,
                                  child: avatarDataUrl == null || imageSnapshot.data == null
                                      ? Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.grey.shade300,
                                        )
                                      : null,
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
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

                  Builder(
                    builder: (context) {
                      final auth = context.watch<AuthProvider>();
                      final userId = auth.user?.uid;

                      if (userId == null) {
                        return const Text(
                          'Sign in to see your recent activity.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        );
                      }

                      return StreamBuilder<List<FavoriteCourse>>(
                        stream: context
                            .read<FavoritesProvider>()
                            .favoritesForUser(userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              height: 110,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            );
                          }

                          final favorites = snapshot.data ?? [];
                          final displayed = favorites
                              .take(4)
                              .toList(growable: false);

                          if (displayed.isEmpty) {
                            return const Text(
                              'Add some favorite courses to see them here.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            );
                          }

                          return Row(
                            children: List.generate(4, (index) {
                              if (index < displayed.length) {
                                return Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: index == 3 ? 0 : 8,
                                    ),
                                    child: _RecentCourseCard(
                                      imagePath: displayed[index].imageAsset,
                                    ),
                                  ),
                                );
                              } else {

                                return Expanded(
                                  child: Container(
                                    height: 110,
                                    margin: EdgeInsets.only(
                                      right: index == 3 ? 0 : 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                );
                              }
                            }),
                          );
                        },
                      );
                    },
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

            Builder(
              builder: (context) {
                final auth = context.watch<AuthProvider>();
                final userEmail = auth.user?.email;

                if (userEmail == null) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      'Sign in to see activity',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return StreamBuilder<List<int>>(
                  stream: context
                      .read<ReviewsProvider>()
                      .getUserRatingDistributionStream(userEmail),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    final distribution = snapshot.data ?? [0, 0, 0, 0, 0];

                    final totalReviews = distribution.fold<int>(0, (sum, count) => sum + count);
                    if (totalReviews == 0) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Text(
                          'No reviews yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingsHistogram(distribution: distribution),
                          const SizedBox(height: 8),
                          _HistogramRatingRow(),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            Builder(
              builder: (context) {
                final auth = context.watch<AuthProvider>();
                final userId = auth.user?.uid;
                final userEmail = auth.user?.email;

                if (userId == null) {
                  return const _ProfileListTile(
                    title: 'Courses taken',
                    trailingText: '0/0 this semester',
                  );
                }

                return StreamBuilder<List<UserSchedule>>(
                  stream: context
                      .read<CoursesProvider>()
                      .getUserSchedule(userId, 'Fall 2024'),
                  builder: (context, scheduleSnapshot) {
                    final coursesCount = scheduleSnapshot.data?.length ?? 0;
                    return _ProfileListTile(
                      title: 'Courses taken',
                      trailingText: '$coursesCount/5 this semester',
                      onTap: () {
                        Navigator.pushNamed(context, Routes.coursesHistory);
                      },
                    );
                  },
                );
              },
            ),

            _ProfileListTile(
              title: 'Friends feed',
              trailingIcon: Icons.chevron_right,
              onTap: () {
                Navigator.pushNamed(context, Routes.friendsActivity);
              },
            ),
            Builder(
              builder: (context) {
                final auth = context.watch<AuthProvider>();
                final userEmail = auth.user?.email;

                if (userEmail == null) {
                  return const _ProfileListTile(
                    title: 'Reviews',
                    trailingText: '0',
                  );
                }

                return FutureBuilder<int>(
                  future: context
                      .read<ReviewsProvider>()
                      .getUserReviewCount(userEmail),
                  builder: (context, snapshot) {
                    final reviewCount = snapshot.data ?? 0;
                    return _ProfileListTile(
                      title: 'Reviews',
                      trailingText: '$reviewCount',
                    );
                  },
                );
              },
            ),
            Builder(
              builder: (context) {
                final auth = context.watch<AuthProvider>();
                final userEmail = auth.user?.email;

                if (userEmail == null) {
                  return const _ProfileListTile(
                    title: 'Ratings',
                    trailingText: '0',
                  );
                }

                return FutureBuilder<int>(
                  future: context
                      .read<ReviewsProvider>()
                      .getUserRatingsCount(userEmail),
                  builder: (context, snapshot) {
                    final ratingsCount = snapshot.data ?? 0;
                    return _ProfileListTile(
                      title: 'Ratings',
                      trailingText: '$ratingsCount',
                    );
                  },
                );
              },
            ),

            _ProfileListTile(
              title: 'Course Planner',
              trailingIcon: Icons.chevron_right,
              onTap: () {
                Navigator.pushNamed(context, Routes.coursePlanner);
              },
            ),

            Builder(
              builder: (context) {
                final auth = context.watch<AuthProvider>();
                final userId = auth.user?.uid;

                if (userId == null) {
                  return const _ProfileListTile(
                    title: 'Following Students',
                    trailingText: '0',
                  );
                }

                final followService = FollowService();
                return StreamBuilder<int>(
                  stream: followService.followingCountStream(userId),
                  builder: (context, snapshot) {
                    final followingCount = snapshot.data ?? 0;
                    return _ProfileListTile(
                      title: 'Following Students',
                      trailingText: '$followingCount',
                      onTap: () {
                        Navigator.pushNamed(context, FollowingsScreen.routeName);
                      },
                    );
                  },
                );
              },
            ),
            Builder(
              builder: (context) {
                final auth = context.watch<AuthProvider>();
                final userId = auth.user?.uid;

                if (userId == null) {
                  return const _ProfileListTile(
                    title: 'Followers',
                    trailingText: '0',
                  );
                }

                final followService = FollowService();
                return StreamBuilder<int>(
                  stream: followService.followersCountStream(userId),
                  builder: (context, snapshot) {
                    final followersCount = snapshot.data ?? 0;
                    return _ProfileListTile(
                      title: 'Followers',
                      trailingText: '$followersCount',
                      onTap: () {
                        Navigator.pushNamed(context, FollowersScreen.routeName);
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}

Future<ImageProvider?> _getAvatarImageProvider(String? dataUrl) async {
  if (dataUrl == null || dataUrl.isEmpty) {
    return null;
  }

  try {

    if (dataUrl.startsWith('data:image')) {

      final base64String = dataUrl.split(',')[1];
      final bytes = base64Decode(base64String);
      return MemoryImage(bytes);
    } else {

      return NetworkImage(dataUrl);
    }
  } catch (e) {
    print('Error decoding avatar: $e');
    return null;
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool selected;

  const _TabItem({required this.label, this.selected = false});

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
    return Container(width: 1, height: 28, color: const Color(0xFF303542));
  }
}

class _RecentCourseCard extends StatelessWidget {
  final String imagePath;
  const _RecentCourseCard({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.grey.shade600,
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
    );
  }
}

class RatingsHistogram extends StatelessWidget {
  final List<int> distribution;
  const RatingsHistogram({super.key, required this.distribution});

  @override
  Widget build(BuildContext context) {
    const List<Color> barColors = [
      Color(0xFF6C7280),
      Color(0xFF747A89),
      Color(0xFF7C8291),
      Color(0xFF858B9A),
      Color(0xFF8D93A3),
    ];

    const maxBarHeight = 60.0;

    final counts = List<int>.from(distribution);
    while (counts.length < 5) {
      counts.add(0);
    }
    final fiveCounts = counts.take(5).toList();

    final maxCount = fiveCounts.isEmpty
        ? 1
        : fiveCounts.reduce((a, b) => a > b ? a : b);

    if (maxCount == 0) {
      return const SizedBox(
        height: maxBarHeight,
        child: Center(
          child: Text(
            'No data',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      );
    }

    return SizedBox(
      height: maxBarHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(5, (i) {
          final count = fiveCounts[i];

          final barHeight = maxCount > 0
              ? (count / maxCount) * maxBarHeight
              : 0.0;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: barHeight.clamp(0.0, maxBarHeight),
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
          title: Text(title, style: const TextStyle(color: Colors.grey)),
          trailing: trailing,
          onTap: onTap,
        ),
      ],
    );
  }
}
