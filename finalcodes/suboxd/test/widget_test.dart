import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('The course card image should be displayed correctly.', (WidgetTester tester) async {
    const String testImagePath = 'assets/hum201.png';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TestCourseCard(
            width: 100,
            height: 150,
            imagePath: testImagePath,
          ),
        ),
      ),
    );

    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);

    final Image imageWidget = tester.widget(imageFinder);
    expect((imageWidget.image as AssetImage).assetName, testImagePath);
  });
}

class TestCourseCard extends StatelessWidget {
  final double width, height;
  final String imagePath;

  const TestCourseCard({
    super.key,
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
