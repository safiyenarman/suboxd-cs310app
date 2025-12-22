import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import '../models/review_model.dart';
import '../providers/reviews_provider.dart';
import '../providers/auth_provider.dart';
import 'add_review_screen.dart';
import 'edit_review_screen.dart';

const Color primaryColor = Color(0xFF4B8BF4);
const Color tabSelected = primaryColor;
const Color bg = Color(0xFF1E2229);
const Color appBarColor = Colors.black;
const Color bottomBarColor = Color(0xFF485365);
const Color dividerColor = Color(0xFF303542);
const Color starColor = Color(0xFFF7C300);

class CourseMeta {
  final String code;
  final String name;
  final String imageAsset;

  const CourseMeta(this.code, this.name, this.imageAsset);
}

const List<CourseMeta> _courses = [
  CourseMeta('ACC201', 'ACC 201', 'assets/acc201.png'),
  CourseMeta(
    'CS303',
    'Logic & Digital System Design',
    'assets/images/cs303.png',
  ),
  CourseMeta('HUM201', 'HUM 201', 'assets/hum201.png'),
  CourseMeta('PSY201', 'PSY 201', 'assets/psy201.png'),
  CourseMeta('CS204', 'Advanced Programming', 'assets/cs204.png'),
  CourseMeta('MATH306', 'Statistical Modelling', 'assets/math306.png'),
  CourseMeta('TLL102', 'TLL 102', 'assets/tll102.png'),
  CourseMeta('NS102', 'NS 102', 'assets/ns102.png'),
  CourseMeta('SPS102', 'SPS 102', 'assets/sps102.png'),
];

class ReviewsScreen extends StatefulWidget {

  static const routeName = '/reviews';
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {

  Future<void> _openAddReview() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddReviewScreen()),
    );
  }

  int _currentIndex = 0;

  void _onBottomNavItemTapped(int index) {

    if (index == 2) {
      _openAddReview();
      return;
    }

    if (_currentIndex == index) return;

    String targetRoute;
    switch (index) {
      case 0:
        targetRoute = Routes.home;
        break;
      case 1:
        targetRoute = Routes.search;
        break;
      case 2:
        targetRoute = Routes.addReview;

      case 3:
        targetRoute = Routes.friendsActivity;
        break;
      case 4:
        targetRoute = ProfileScreen.routeName;
        break;
      default:
        return;
    }

    Navigator.pushNamedAndRemoveUntil(context, targetRoute, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,

      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.settings, color: Colors.white70),
          onPressed: () {

            Navigator.pushNamed(context, SettingsScreen.routeName);
          },
        ),
        title: const Text(
          'Reviews',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        toolbarHeight: 56,

        actions: [
          PopupMenuButton<String>(
            color: bottomBarColor,
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            onSelected: (String result) {
              if (result == 'add_review') {
                _openAddReview();
              } else if (result == 'friends_activity') {

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.friendsActivity,
                  (route) => false,
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'add_review',
                child: Text(
                  'Add Review',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'friends_activity',
                child: Text(
                  'Friends Activity',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: appBarColor,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _tabItem(
                  'Profile',
                  false,
                  () => Navigator.pushReplacementNamed(
                    context,
                    ProfileScreen.routeName,
                  ),
                ),
                _tabItem(
                  'Courses',
                  false,

                  () => Navigator.pushReplacementNamed(
                    context,
                    Routes.allCourses,
                  ),
                ),
                _tabItem('Reviews', true, null),
                _tabItem(
                  'Plan to Take',
                  false,

                  () => Navigator.pushReplacementNamed(
                    context,
                    Routes.coursePlanner,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Write and share reviews. Compile your own lists.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: StreamBuilder<List<Review>>(
              stream: context.read<ReviewsProvider>().reviewsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Failed to load reviews: ${snapshot.error}',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                }
                final reviews = snapshot.data ?? [];
                if (reviews.isEmpty) {
                  return const Center(
                    child: Text(
                      'No reviews yet. Be the first to add one!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final authProvider = context.watch<AuthProvider>();
                final userId = authProvider.user?.uid ?? '';

                return StreamBuilder<Set<String>>(
                  stream: userId.isNotEmpty
                      ? context.read<ReviewsProvider>().getUserLikedReviews(userId)
                      : Stream.value(<String>{}),
                  builder: (context, likedSnapshot) {
                    final likedReviewIds = likedSnapshot.data ?? <String>{};

                    return ListView.builder(
                      padding: const EdgeInsets.all(14),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final r = reviews[index];
                        final isLiked = likedReviewIds.contains(r.id);
                        return _buildReviewCard(context, r, isLiked);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: bottomBarColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
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
        onTap: _onBottomNavItemTapped,
      ),
    );
  }

  Widget _tabItem(String label, bool active, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? tabSelected
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, Review r, bool isLiked) {

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF1F222A),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              r.imageAsset,
              width: 70,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.courseCode == r.courseName || r.courseName.isEmpty
                      ? r.courseCode
                      : '${r.courseCode} ${r.courseName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),

                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 14, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      r.username,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '⭐ ${r.rating}',
                      style: const TextStyle(color: Colors.amber, fontSize: 12),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formatReviewDate(r.createdAt),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  r.text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    StreamBuilder<List<Review>>(
                      stream: context.read<ReviewsProvider>().reviewsStream(),
                      builder: (context, reviewSnapshot) {
                        final currentReview = reviewSnapshot.data?.firstWhere(
                          (review) => review.id == r.id,
                          orElse: () => r,
                        ) ?? r;

                        return InkWell(
                          onTap: () async {
                            final authProvider = context.read<AuthProvider>();
                            final userId = authProvider.user?.uid;
                            if (userId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please login to like reviews'),
                                ),
                              );
                              return;
                            }

                            try {
                              await context.read<ReviewsProvider>().toggleLike(r.id, userId);
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                  ),
                                );
                              }
                            }
                          },
                          child: Row(
                            children: [
                              Icon(
                                isLiked ? Icons.favorite : Icons.favorite_border,
                                color: isLiked ? Colors.red : Colors.greenAccent,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${currentReview.likes} likes',
                                style: TextStyle(
                                  color: isLiked ? Colors.red : Colors.greenAccent,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Spacer(),

                    if (context.watch<AuthProvider>().user?.email == r.username) ...[
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditReviewScreen(review: r),
                            ),
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: const Color(0xFF2C323A),
                              title: const Text(
                                'Delete Review',
                                style: TextStyle(color: Colors.white),
                              ),
                              content: const Text(
                                'Are you sure you want to delete this review?',
                                style: TextStyle(color: Colors.white70),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            try {
                              await context.read<ReviewsProvider>().deleteReview(r.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Review deleted successfully'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to delete review: $e'),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                    ],
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReviewDetailScreen(review: r),
                          ),
                        );
                      },
                      child: const Text(
                        'click to see more…',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewDetailScreen extends StatelessWidget {
  final Review review;

  const ReviewDetailScreen({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final isOwner = context.watch<AuthProvider>().user?.email == review.username;
    final userId = context.watch<AuthProvider>().user?.uid ?? '';

    return StreamBuilder<Set<String>>(
      stream: userId.isNotEmpty
          ? context.read<ReviewsProvider>().getUserLikedReviews(userId)
          : Stream.value(<String>{}),
      builder: (context, likedSnapshot) {
        final isLiked = likedSnapshot.data?.contains(review.id) ?? false;

        return _buildDetailContent(context, isOwner, userId, isLiked);
      },
    );
  }

  Widget _buildDetailContent(BuildContext context, bool isOwner, String userId, bool isLiked) {

    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          review.courseCode == review.courseName || review.courseName.isEmpty
              ? review.courseCode
              : '${review.courseCode} ${review.courseName}',
          style: const TextStyle(fontSize: 16),
        ),
        actions: isOwner
            ? [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditReviewScreen(review: review),
                      ),
                    );

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF2C323A),
                        title: const Text(
                          'Delete Review',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: const Text(
                          'Are you sure you want to delete this review?',
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      try {
                        await context.read<ReviewsProvider>().deleteReview(review.id);
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Review deleted successfully'),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to delete review: $e'),
                            ),
                          );
                        }
                      }
                    }
                  },
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      review.imageAsset,
                      width: 90,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.courseCode == review.courseName || review.courseName.isEmpty
                              ? review.courseCode
                              : '${review.courseCode} ${review.courseName}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.person,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              review.username,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '⭐ ${review.rating}',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              formatReviewDate(review.createdAt),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Review',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                review.text,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  if (userId.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please login to like reviews'),
                      ),
                    );
                    return;
                  }

                  try {
                    await context.read<ReviewsProvider>().toggleLike(review.id, userId);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                        ),
                      );
                    }
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.greenAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    StreamBuilder<List<Review>>(
                      stream: context.read<ReviewsProvider>().reviewsStream(),
                      builder: (context, snapshot) {
                        final currentReview = snapshot.data?.firstWhere(
                          (r) => r.id == review.id,
                          orElse: () => review,
                        ) ?? review;
                        return Text(
                          '${currentReview.likes} likes',
                          style: TextStyle(
                            color: isLiked ? Colors.red : Colors.greenAccent,
                            fontSize: 13,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatReviewDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
}
