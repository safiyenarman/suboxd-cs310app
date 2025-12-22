import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suboxd/screens/add_review_screen.dart';
import '../routes.dart';
import 'profile_screen.dart';
import '../providers/reviews_provider.dart';
import '../models/review_model.dart';

const Color primaryColor = Color(0xFF4B8BF4);
const Color bottomBarColor = Color(0xFF485365);

class FriendsActivityScreen extends StatelessWidget {
  static const routeName = '/friends-activity';

  const FriendsActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New From Friends")),
      body: StreamBuilder<List<Review>>(
        stream: context.read<ReviewsProvider>().reviewsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading reviews: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final reviews = snapshot.data ?? [];

          if (reviews.isEmpty) {
            return const Center(
              child: Text(
                'No reviews from friends yet.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return _courseCard(review: review);
            },
          );
        },
      ),
      bottomNavigationBar:
          _BottomNavBar(),
    );
  }

  Widget _courseCard({required Review review}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF262B33),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                review.imageAsset,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {

                  return Container(
                    color: Colors.grey.shade800,
                    child: const Center(
                      child: Icon(Icons.image, color: Colors.grey, size: 40),
                    ),
                  );
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: Text(
              review.courseCode == review.courseName || review.courseName.isEmpty
                  ? review.courseCode
                  : '${review.courseCode} ${review.courseName}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                const Icon(Icons.person, color: Colors.grey, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    review.username,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  color: index < review.rating.floor()
                      ? Colors.amber
                      : Colors.grey.shade700,
                  size: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Text(
              review.text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: bottomBarColor,
      type: BottomNavigationBarType.fixed,
      currentIndex: 3,
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
          case 4:

            Navigator.pushNamedAndRemoveUntil(
              context,
              ProfileScreen.routeName,
              (route) => false,
            );
            break;
          case 3:

            break;
          default:
            break;
        }
      },
    );
  }
}
