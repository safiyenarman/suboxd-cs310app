import 'package:flutter/material.dart';
import '../routes.dart';

class ReviewData {
  final String courseCode;
  final String courseName;
  final String username;
  final double rating;
  final String date;
  final int likes;
  final String text;
  final String imageAsset;

  const ReviewData({
    required this.courseCode,
    required this.courseName,
    required this.username,
    required this.rating,
    required this.date,
    required this.likes,
    required this.text,
    required this.imageAsset,
  });
}


class CourseMeta {
  final String code;
  final String name;
  final String imageAsset;

  const CourseMeta(this.code, this.name, this.imageAsset);
}

const List<CourseMeta> _courses = [
  CourseMeta('ACC201', 'ACC 201', 'assets/images/acc201.png'),
  CourseMeta('CS303', 'Logic & Digital System Design',
      'assets/images/cs303.png'),
  CourseMeta('HUM201', 'HUM 201', 'assets/images/hum201.png'),
  CourseMeta('PSY201', 'PSY 201', 'assets/images/psy201.png'),
  CourseMeta('CS204', 'Advanced Programming', 'assets/images/cs204.png'),
  CourseMeta('MATH306', 'Statistical Modelling', 'assets/images/math306.png'),
  CourseMeta('TLL102', 'TLL 102', 'assets/images/tll102.png'),
  CourseMeta('NS102', 'NS 102', 'assets/images/ns102.png'),
  CourseMeta('SPS102', 'SPS 102', 'assets/images/sps102.png'),
];


class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final List<ReviewData> _reviews = [
    const ReviewData(
      courseCode: 'CS303',
      courseName: 'Logic & Digital System Design',
      username: 'berkayozcan',
      rating: 4.5,
      date: '18.05.2023',
      likes: 23,
      text:
      'It is better to take this course in fall semester because Atıl hoca gives slayts and more related to coding not electronics.',
      imageAsset: 'assets/images/cs303.png',
    ),
    const ReviewData(
      courseCode: 'CS411',
      courseName: 'Cryptography',
      username: 'ihsankaya',
      rating: 5,
      date: '13.09.2024',
      likes: 42,
      text:
      'If you are studying CS you need to take this course. This course gives you a different perspective. Erkay hoca is the best.',
      imageAsset: 'assets/images/cs411.png',
    ),
    const ReviewData(
      courseCode: 'CS204',
      courseName: 'Advanced Programming',
      username: 'ravzaorsun',
      rating: 4.5,
      date: '18.02.2025',
      likes: 65,
      text:
      'This course really helps you understand what coding actually is. Kamer Hoca is very knowledgeable, but his exams are difficult. Albert Hoca’s exams are more moderate. If you care about your GPA, taking the course with Albert Hoca might be a better choice.',
      imageAsset: 'assets/images/cs204.png',
    ),
    const ReviewData(
      courseCode: 'MATH306',
      courseName: 'Statistical Modelling',
      username: 'rabia.orsun',
      rating: 3,
      date: '23.04.2019',
      likes: 30,
      text:
      'If you are taking this course just to gain credit this will be the worst idea you take. The general course will be determined by just two exams which makes to get A harder than ever.',
      imageAsset: 'assets/images/math306.png',
    ),
  ];

  Future<void> _openAddReview() async {
    final ReviewData? newReview = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddReviewScreen(),
      ),
    );

    if (newReview != null) {
      setState(() {
        _reviews.insert(0, newReview);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),

      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        elevation: 0,

        automaticallyImplyLeading: false,
        title: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1F222A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'SUboxd',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _openAddReview,
            child: const Text(
              'Add Reviews',
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            onPressed: _openAddReview,
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            color: const Color(0xFF1F222A),
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _tabItem(
                  'Profile',
                  false,
                      () => Navigator.pushReplacementNamed(context, '/profile'),
                ),
                _tabItem(
                  'Courses',
                  false,
                      () => Navigator.pushReplacementNamed(context, '/courses'),
                ),
                _tabItem('Reviews', true, null),
                _tabItem('Plan to Take', false, null),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Write and share reviews. Compile your own lists.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final r = _reviews[index];
                return _buildReviewCard(context, r);
              },
            ),
          ),
        ],
      ),


      bottomNavigationBar: Container(
        height: 70,
        color: const Color(0xFF1F222A),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.menu_book, color: Colors.grey),
            Icon(Icons.search, color: Colors.grey),
            CircleAvatar(
              radius: 26,
              backgroundColor: Color(0xFF4CAF50),
              child: Icon(Icons.add, color: Colors.white, size: 26),
            ),
            Icon(Icons.flash_on, color: Colors.grey),
            Icon(Icons.person, color: Colors.grey),
          ],
        ),
      ),
    );
  }


  Widget _tabItem(String label, bool active, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.blueGrey : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.grey,
            fontSize: 14,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, ReviewData r) {
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
          // SOL GÖRSEL
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
                  '${r.courseCode}  ${r.courseName}',
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
                      style: const TextStyle(
                          color: Colors.amber, fontSize: 12),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '(${r.date})',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  r.text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style:
                  const TextStyle(color: Colors.white70, fontSize: 13),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.favorite,
                        color: Colors.greenAccent, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '${r.likes} likes',
                      style: const TextStyle(
                          color: Colors.greenAccent, fontSize: 12),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ReviewDetailScreen(review: r),
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
  final ReviewData review;

  const ReviewDetailScreen({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
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
          '${review.courseCode}  ${review.courseName}',
          style: const TextStyle(fontSize: 16),
        ),
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
                          '${review.courseCode}  ${review.courseName}',
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
                              child: Icon(Icons.person,
                                  size: 16, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              review.username,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '⭐ ${review.rating}',
                              style: const TextStyle(
                                  color: Colors.amber, fontSize: 13),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              review.date,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
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
                    color: Colors.white70, fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.favorite,
                      color: Colors.greenAccent, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    '${review.likes} likes',
                    style: const TextStyle(
                        color: Colors.greenAccent, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  CourseMeta _selectedCourse = _courses[0];
  int _selectedStars = 4;

  void _submit() {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a comment.')),
      );
      return;
    }

    final username = _nameController.text.trim().isEmpty
        ? 'anonymous'
        : _nameController.text.trim();

    final newReview = ReviewData(
      courseCode: _selectedCourse.code,
      courseName: _selectedCourse.name,
      username: username,
      rating: _selectedStars.toDouble(),
      date: '01.01.2025', // demo
      likes: 0,
      text: comment,
      imageAsset: _selectedCourse.imageAsset,
    );

    Navigator.pop(context, newReview);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Add Review',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Enter your name...',
                      hintStyle: TextStyle(color: Colors.white54),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white38),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),


            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF08A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CourseMeta>(
                  value: _selectedCourse,
                  dropdownColor: const Color(0xFF1F222A),
                  iconEnabledColor: Colors.black87,
                  items: _courses
                      .map(
                        (c) => DropdownMenuItem(
                      value: c,
                      child: Text(
                        '${c.code} - ${c.name}',
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 13),
                      ),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCourse = value;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),


            Container(
              height: 160,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: TextField(
                controller: _commentController,
                maxLines: null,
                expands: true,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add your comment here...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),


            Row(
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                final filled = starIndex <= _selectedStars;
                return IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      _selectedStars = starIndex;
                    });
                  },
                  icon: Icon(
                    filled ? Icons.star : Icons.star_border,
                    color: Colors.white,
                    size: 22,
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),


            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4C00FF),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: _submit,
                child: const Text(
                  'SUBMIT',
                  style: TextStyle(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
