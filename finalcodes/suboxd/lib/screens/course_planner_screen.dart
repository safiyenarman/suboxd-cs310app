import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course_model.dart';
import '../routes.dart';
import '../providers/courses_provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_schedule_model.dart';

class CoursePlannerScreen extends StatefulWidget {
  const CoursePlannerScreen({super.key});

  @override
  State<CoursePlannerScreen> createState() => _CoursePlannerScreenState();
}

class _CoursePlannerScreenState extends State<CoursePlannerScreen> {
  String searchQuery = "";
  List<CourseModel> selectedCourses = [];
  bool _isSaving = false;
  String _currentTerm = "Fall 2024"; 

  @override
  void initState() {
    super.initState();
    _loadUserSchedule();
  }

  Future<void> _loadUserSchedule() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final coursesProvider = Provider.of<CoursesProvider>(context, listen: false);
    
    if (authProvider.user == null) return;

    coursesProvider.getUserSchedule(authProvider.user!.uid, _currentTerm).listen(
      (schedules) {
        if (mounted) {
          final courseIds = schedules.map((s) => s.courseId).toList();
          final allCourses = coursesProvider.courses;
          setState(() {
            selectedCourses = allCourses
                .where((c) => courseIds.contains(c.id))
                .toList();
          });
        }
      },
    );
  }

  Future<void> _saveSchedule() async {
    if (selectedCourses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one course')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final coursesProvider = Provider.of<CoursesProvider>(context, listen: false);

    if (authProvider.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to save your schedule')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final courseIds = selectedCourses.map((c) => c.id).toList();
      final courseNames = selectedCourses.map((c) => c.name).toList();

      await coursesProvider.saveUserSchedule(
        authProvider.user!.uid,
        courseIds,
        courseNames,
        _currentTerm,
      );

      if (mounted) {
        Navigator.pushNamed(
          context,
          Routes.coursePlannerInfo,
          arguments: selectedCourses,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving schedule: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF262B33);
    final coursesProvider = Provider.of<CoursesProvider>(context);

    final allCourses = coursesProvider.courses;
    final filteredCourses = searchQuery.trim().isEmpty
        ? [] 
        : allCourses
            .where((c) =>
                c.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 48,
        backgroundColor: const Color(0xFF15181E),

        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),

        title: const Text("Course Planner"),
        centerTitle: true,

        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveSchedule,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                    ),
                  )
                : const Text("Save",
                    style: TextStyle(color: Colors.greenAccent, fontSize: 16)),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("Select your schedule for this term",
                style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 12),

            TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (v) => setState(() => searchQuery = v),
              decoration: InputDecoration(
                hintText: "Search courses...",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: cardColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 16),

            
            if (coursesProvider.loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              ),

            if (coursesProvider.error != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Error loading courses: ${coursesProvider.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),

            
            if (!coursesProvider.loading && coursesProvider.error == null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Total courses available: ${allCourses.length}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),

            
            if (!coursesProvider.loading &&
                coursesProvider.error == null &&
                searchQuery.trim().isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Type to search for courses...',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

            
            if (!coursesProvider.loading &&
                coursesProvider.error == null &&
                filteredCourses.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: filteredCourses.map((course) {
                    final isSelected = selectedCourses.any((c) => c.id == course.id);

                    return ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(course.name,
                                style: const TextStyle(color: Colors.white)),
                          ),
                          if (course.sessions.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Colors.orange,
                              ),
                            ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.instructor,
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          if (course.sessions.isEmpty)
                            const Row(
                              children: [
                                Icon(
                                  Icons.schedule_outlined,
                                  size: 12,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'No schedule data in Firebase',
                                  style: TextStyle(color: Colors.orange, fontSize: 11),
                                ),
                              ],
                            ),
                        ],
                      ),
                      trailing: Icon(
                        isSelected
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color:
                        isSelected ? Colors.greenAccent : Colors.grey,
                      ),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedCourses.removeWhere((c) => c.id == course.id);
                          } else {
                            selectedCourses.add(course);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 32),
            const Text("Your Schedule",
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),

            _buildScheduleGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleGrid() {
    const days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
    const times = [
      "08:40",
      "09:40",
      "10:40",
      "11:40",
      "12:40",
      "13:40",
      "14:40",
      "15:40",
      "16:40",
      "17:40",
    ];

    Map<String, String> grid = {};
    List<String> coursesWithoutSessions = [];
    
    for (var c in selectedCourses) {
      if (c.sessions.isEmpty) {
        coursesWithoutSessions.add(c.name);
        print('Course ${c.name}: No sessions available');
        continue;
      }
      
      print('Course ${c.name}: Processing ${c.sessions.length} session(s)');
      for (var s in c.sessions) {
        String normalizedDay = s.day;
        if (normalizedDay.isNotEmpty) {
          normalizedDay = normalizedDay.substring(0, 1).toUpperCase() + 
                         normalizedDay.substring(1).toLowerCase();
        }
        
        String normalizedTime = s.time;
        if (normalizedTime.contains('.')) {
          normalizedTime = normalizedTime.replaceAll('.', ':');
        }
        
        if (normalizedTime.contains(':')) {
          final parts = normalizedTime.split(':');
          if (parts.length >= 2) {
            final hour = parts[0].padLeft(2, '0');
            final minute = parts[1].padLeft(2, '0');
            normalizedTime = '$hour:$minute';
          }
        }
        
        print('  Session: $normalizedDay at $normalizedTime (original: ${s.time})');
        
        if (days.contains(normalizedDay) && normalizedTime.isNotEmpty) {
          final gridKey = "$normalizedDay-$normalizedTime";
          grid[gridKey] = c.name;
          print('  ✓ Added to grid: $gridKey');
        } else {
          print('  ✗ Invalid session - Day: "$normalizedDay" (valid: ${days.contains(normalizedDay)}), Time: "$normalizedTime" (in times: ${times.contains(normalizedTime)})');
        }
      }
    }

    return Column(
      children: [
        if (coursesWithoutSessions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF262B33),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Selected courses without schedule:',
                      style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'These courses don\'t have session data in Firebase. They can still be saved to your schedule, but won\'t appear on the weekly grid.',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: coursesWithoutSessions.map((name) {
                    return Chip(
                      label: Text(
                        name,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      backgroundColor: Colors.blueGrey.shade700,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        
        Table(
          border: TableBorder.all(color: Colors.grey.shade800),
          columnWidths: const {0: FixedColumnWidth(70)},
          children: [
            TableRow(
              children: [
                const SizedBox(),
                ...days.map((d) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(d, style: const TextStyle(color: Colors.white)),
                  ),
                )),
              ],
            ),
            ...times.map(
                  (time) => TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(time, style: const TextStyle(color: Colors.grey)),
                  ),
                  ...days.map((day) {
                    final key = "$day-$time";
                    final val = grid[key];

                    return Container(
                      height: 40,
                      alignment: Alignment.center,
                      color: val != null ? Colors.blueGrey.shade400 : Colors.transparent,
                      child: Text(val ?? "",
                          style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
