import 'package:flutter/material.dart';

const Color bg = Color(0xFF1E2229);
const Color cardColor = Color(0xFF262B33);
const Color primaryColor = Color(0xFF4B8BF4);
const Color appBarColor = Color(0xFF15181E);
const Color starColor = Color(0xFF18A60A);
const Color dividerColor = Color(0xFF303542);
const Color bottomBarColor = Color(0xFF485365);
const Color sectionHeaderColor = Color(0xFFC8CDD5);


class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key});

  final String courseCode = 'CS 201';
  final String courseTitle = 'Programming Fundamentals';
  final String instructor = 'Saima Gül';
  final String semester = 'Fall 2025-2026';
  final String faculty = 'Faculty of Engineering and Natural Sciences';
  final String level = 'Undergraduate';
  final String prerequisites = 'IF 100';
  final String corequisites = 'CS 201R';
  final String credits = 'SU Credit:3.000, ECTS:6';
  final String courseType = 'Lecture';
  final String email = 'saima.gul@sabanciuniv.edu';

  final String catalogDescription =
      'This course is intended to introduce students to the field of computing (basic computer organization, data representation, concepts, algorithmic thinking and problem solving), as well as give them intermediate level programming abilities in an object-oriented programming language';

  final List<String> learningOutcomes = const [
    'Describe the basics of computer architecture, programming languages and compilers',
    'Design an algorithm (step-by-step solution) for a given computing problem',
    'Write small C++ programs',
    'Use the basic programming concepts like if-else statements and while-for loops',
    'Use functions and describe different parameter passing methods',
    'Use, modify existing classes and design new classes',
    'Perform simple text file I/O operations',
    'Perform searches on arrays and sort arrays',
    'Perform basic complexity analysis on algorithms',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(courseTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // About course
          _SectionHeader(title: courseCode),
          _CourseInfoRow(label: 'Course:', value: '$courseTitle - $courseCode Section A'),
          _CourseInfoRow(label: 'Faculty:', value: faculty),
          _CourseInfoRow(label: 'Semester:', value: semester),
          _CourseInfoRow(label: 'Level:', value: level),
          _CourseInfoRow(label: 'Course Credits:', value: credits),
          _CourseInfoRow(label: 'Prerequisites:', value: prerequisites),
          _CourseInfoRow(label: 'Corequisites:', value: corequisites),
          _CourseInfoRow(label: 'Course Type:', value: courseType),

          const SizedBox(height: 24),

          // About instructor
          _SectionHeader(title: 'Instructor(s) Information'),
          _InstructorCard(instructorName: instructor, email: email),

          const SizedBox(height: 24),

          // Description
          _SectionHeader(title: 'Catalog Course Description'),
          _SectionContent(text: catalogDescription),

          const SizedBox(height: 24),

          // Learning outcomes
          _SectionHeader(title: 'Course Learning Outcomes'),
          _LearningOutcomesList(outcomes: learningOutcomes),

          const SizedBox(height: 24),

          // Technology Requirements
          _SectionHeader(title: 'Technology Requirements'),
          _SectionContent(text: 'Primary Recommendation: Visual Studio (Community Edition, Windows).\nAlternative Option: Visual Studio Code (Cross-Platform, Lightweight).'),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: sectionHeaderColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SectionContent extends StatelessWidget {
  final String text;

  const _SectionContent({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 15,
          height: 1.4,
        ),
      ),
    );
  }
}

class _CourseInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _CourseInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructorCard extends StatelessWidget {
  final String instructorName;
  final String email;

  const _InstructorCard({required this.instructorName, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            instructorName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Email: $email',
            style: TextStyle(color: primaryColor),
          ),
        ],
      ),
    );
  }
}

class _LearningOutcomesList extends StatelessWidget {
  final List<String> outcomes;

  const _LearningOutcomesList({required this.outcomes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(outcomes.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${index + 1}.',
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  outcomes[index],
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
