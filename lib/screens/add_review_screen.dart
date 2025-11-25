import 'package:flutter/material.dart';

// CourseMeta yapısı, Reviews ekranından alınmıştır.
class CourseMeta {
  final String code;
  final String name;
  final String imageAsset;
  const CourseMeta(this.code, this.name, this.imageAsset);
}

// Kurs listesi (örnek veriler)
const List<CourseMeta> _courses = [
  CourseMeta('ACC201', 'ACC 201', 'assets/images/acc201.png'),
  CourseMeta('CS303', 'Logic & Digital System Design', 'assets/images/cs303.png'),
  CourseMeta('HUM201', 'Major Works of Literature', 'assets/images/hum201.png'),
  CourseMeta('PSY201', 'Psychology', 'assets/images/psy201.png'),
  // ... Diğer kurslarınız ...
];


class AddReviewScreen extends StatefulWidget {
  // Yeni rota adı sabiti eklendi.
  static const routeName = '/add-review';

  const AddReviewScreen({super.key});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _reviewController = TextEditingController();
  int _selectedStars = 0;
  CourseMeta? _selectedCourse;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedCourse == null || _selectedStars == 0 || _reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun ve puan verin!')),
      );
      return;
    }

    // Yorumu gönderme mantığı buraya eklenecek.
    print('Yorum Gönderildi:');
    print('Kurs: ${_selectedCourse!.code}');
    print('Puan: $_selectedStars');
    print('Yorum Metni: ${_reviewController.text}');

    // İşlem başarılı ise bir önceki ekrana dön.
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Review'),
        backgroundColor: const Color(0xFF15181E), // AppBar rengi

        // ⭐️ GÜNCELLEME: Çarpı (Kapat) butonu eklendi.
        // Bu, önceki ekrana geri dönmeyi garanti eder.
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            // Bir önceki rotaya geri döner.
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. KURS SEÇİM ALANI (DROPDOWN)
            const Text(
              'Select Course',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2C323A), // Sekme arkaplan rengi
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonFormField<CourseMeta>(
                dropdownColor: const Color(0xFF2C323A),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                hint: const Text('Choose lecture code. . .', style: TextStyle(color: Colors.white70)),
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

            // 2. YORUM METİN ALANI
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

            // 3. YILDIZ PUANLAMA
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
                    color: filled ? const Color(0xFFFFC107) : Colors.white54, // Sarı yıldız rengi
                    size: 36, // Daha büyük yıldızlar
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),


            // GÖNDER BUTONU
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B8BF4), // Mavi buton rengi
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
                      color: Colors.white
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