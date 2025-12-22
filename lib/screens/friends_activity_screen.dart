import 'package:flutter/material.dart';
import 'package:suboxd/screens/add_review_screen.dart';
import 'package:suboxd/screens/add_review_screen.dart';
import '../routes.dart'; 
import 'profile_screen.dart'; 


const Color primaryColor = Color(0xFF4B8BF4);
const Color bottomBarColor = Color(0xFF485365);

class FriendsActivityScreen extends StatelessWidget {
  static const routeName = '/friends-activity'; 

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
      bottomNavigationBar: _BottomNavBar(), 
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
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
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
                    (index) => const Icon(
                  Icons.star,
                  color: Colors.green,
                  size: 18,
                ),
              ),
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
        
            Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
            break;
          case 1:
         
            Navigator.pushNamedAndRemoveUntil(context, Routes.search, (route) => false);
            break;
          case 2:
          
            Navigator.pushNamed(context, AddReviewScreen.routeName);
            break;
          case 4:
          // Profile
            Navigator.pushNamedAndRemoveUntil(context, ProfileScreen.routeName, (route) => false);
            break;
          case 3:
          // Friends Activity (Zaten buradayız)
            break;
          default:
            break;
        }
      },
    );
  }
}



final courseImages = [
  "assets/cs204.png",
  "assets/cs303.png",
  "assets/math306.png",
  "assets/hum201.png",
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
