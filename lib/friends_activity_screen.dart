import 'package:flutter/material.dart';

class FriendsActivityScreen extends StatelessWidget {
  const FriendsActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New From Friends"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.68,
        ),
        itemCount: courseImages.length,
        itemBuilder: (context, index) {
          return _courseCard(
            imagePath: courseImages[index],
            courseName: courseNames[index],
            userName: userNames[index],
            rating: ratings[index],
          );
        },
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _courseCard({
    required String imagePath,
    required String courseName,
    required String userName,
    required double rating,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF262B33),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              courseName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                const Icon(Icons.person, color: Colors.grey, size: 18),
                const SizedBox(width: 6),
                Text(
                  userName,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: List.generate(
                rating.floor(),
                (index) => const Icon(Icons.star, color: Colors.green, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNav() {
    return Container(
      height: 70,
      color: const Color(0xFF1B2029),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.home, color: Colors.blue, size: 30),
          Icon(Icons.search, color: Colors.white70, size: 28),
          Icon(Icons.add_circle, color: Colors.green, size: 32),
          Icon(Icons.flash_on, color: Colors.white70, size: 28),
          Icon(Icons.person, color: Colors.white70, size: 28),
        ],
      ),
    );
  }
}

final courseImages = [
  "lib/assets/cs201.png",
  "lib/assets/cs303.png",
  "lib/assets/math306.png",
 "lib/assets/hum201.png",
];

final courseNames = [
  "C++ Programming",
  "Logic Design",
  "Statistics",
  "Major Works of Literature",
];

final userNames = [
  "oykuto",
  "safikk",
  "safikk",
  "oykuto",
];

final ratings = [
  5.0,
  4.0,
  5.0,
  3.0,
];
