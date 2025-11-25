import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../routes.dart';

class CoursePlannerScreen extends StatefulWidget {
  const CoursePlannerScreen({super.key});

  @override
  State<CoursePlannerScreen> createState() => _CoursePlannerScreenState();
}

class _CoursePlannerScreenState extends State<CoursePlannerScreen> {
  String searchQuery = "";

  final List<CourseModel> allCourses = [
    CourseModel(
      name: "CS201A",
      instructor: "Saima Gül",
      quota: 120,
      requested: 150,
      seniorRequested: 40,
      sessions: [
        CourseSession(day: "Monday", time: "09:40"),
        CourseSession(day: "Monday", time: "10:40"),
      ],
    ),
    CourseModel(
      name: "CS201R A2",
      instructor: "Barış Akgül",
      quota: 80,
      requested: 95,
      seniorRequested: 22,
      sessions: [
        CourseSession(day: "Tuesday", time: "13:40"),
      ],
    ),
    CourseModel(
      name: "CS412",
      instructor: "Eren Alpay",
      quota: 150,
      requested: 156,
      seniorRequested: 52,
      sessions: [
        CourseSession(day: "Wednesday", time: "08:40"),
        CourseSession(day: "Wednesday", time: "09:40"),
        CourseSession(day: "Thursday", time: "16:40"),
      ],
    ),
  ];

  List<CourseModel> selectedCourses = [];

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF262B33);

    final filteredCourses = searchQuery.trim().isEmpty
        ? []                                    // 👉 arama boşken liste GÖRÜNMEZ
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
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.coursePlannerInfo,
                arguments: selectedCourses,
              );
            },
            child: const Text("Save",
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

            // Only show if filtered list is not empty
            if (filteredCourses.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: filteredCourses.map((course) {
                    final isSelected = selectedCourses.contains(course);

                    return ListTile(
                      title: Text(course.name,
                          style: const TextStyle(color: Colors.white)),
                      trailing: Icon(
                        isSelected
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color:
                        isSelected ? Colors.greenAccent : Colors.grey,
                      ),
                      onTap: () {
                        setState(() {
                          isSelected
                              ? selectedCourses.remove(course)
                              : selectedCourses.add(course);
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
    for (var c in selectedCourses) {
      for (var s in c.sessions) {
        grid["${s.day}-${s.time}"] = c.name;
      }
    }

    return Table(
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
    );
  }
}
