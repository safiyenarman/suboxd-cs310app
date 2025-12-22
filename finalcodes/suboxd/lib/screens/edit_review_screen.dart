import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/review_model.dart';
import '../providers/reviews_provider.dart';
import '../providers/auth_provider.dart';

class CourseMeta {
  final String code;
  final String name;
  final String imageAsset;
  const CourseMeta(this.code, this.name, this.imageAsset);
}

const List<CourseMeta> _courses = [
  CourseMeta('ACC201', 'ACC 201', 'assets/acc201.png'),
  CourseMeta('CS204', 'Advanced Programming', 'assets/cs204.png'),
  CourseMeta('CS303', 'Logic & Digital System Design', 'assets/cs303.png'),
  CourseMeta('CS411', 'Cryptography', 'assets/cs411.png'),
  CourseMeta('MATH306', 'Statistical Modelling', 'assets/math306.png'),
  CourseMeta('HUM201', 'Major Works of Literature', 'assets/hum201.png'),
  CourseMeta('PSY201', 'Psychology', 'assets/psy201.png'),
  CourseMeta('NS102', 'NS 102', 'assets/ns102.png'),
  CourseMeta('SPS102', 'SPS 102', 'assets/sps102.png'),
  CourseMeta('TLL102', 'TLL 102', 'assets/tll102.png'),
];

class EditReviewScreen extends StatefulWidget {
  final Review review;

  const EditReviewScreen({super.key, required this.review});

  @override
  State<EditReviewScreen> createState() => _EditReviewScreenState();
}

class _EditReviewScreenState extends State<EditReviewScreen> {
  late TextEditingController _reviewController;
  late int _selectedStars;
  late CourseMeta? _selectedCourse;

  @override
  void initState() {
    super.initState();
    _reviewController = TextEditingController(text: widget.review.text);
    _selectedStars = widget.review.rating.toInt();
    _selectedCourse = _courses.firstWhere(
      (course) => course.code == widget.review.courseCode,
      orElse: () => _courses.first,
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedCourse == null ||
        _selectedStars == 0 ||
        _reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and provide a rating!'),
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final username = auth.user?.email ?? 'anonymous';

    final updatedReview = Review(
      id: widget.review.id,
      courseCode: _selectedCourse!.code,
      courseName: _selectedCourse!.name,
      username: username,
      rating: _selectedStars.toDouble(),
      text: _reviewController.text.trim(),
      createdAt: widget.review.createdAt, 
      likes: widget.review.likes,
      imageAsset: _selectedCourse!.imageAsset,
    );

    try {
      await context.read<ReviewsProvider>().updateReview(updatedReview);
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review updated successfully'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update review: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Review'),
        backgroundColor: const Color(0xFF15181E),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Course',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2C323A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonFormField<CourseMeta>(
                dropdownColor: const Color(0xFF2C323A),
                decoration: const InputDecoration(border: InputBorder.none),
                hint: const Text(
                  'Choose lecture code. . .',
                  style: TextStyle(color: Colors.white70),
                ),
                value: _selectedCourse,
                isExpanded: true,
                items: _courses.map((CourseMeta course) {
                  return DropdownMenuItem<CourseMeta>(
                    value: course,
                    child: Text(
                      '${course.code} - ${course.name}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (CourseMeta? newValue) {
                  setState(() {
                    _selectedCourse = newValue;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Your Review',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reviewController,
              maxLines: 6,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Share your thoughts on the course...',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF2C323A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Rating',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    color: filled
                        ? const Color(0xFFFFC107)
                        : Colors.white54,
                    size: 36,
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B8BF4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: _submit,
                child: const Text(
                  'UPDATE',
                  style: TextStyle(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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

