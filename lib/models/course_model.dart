class CourseSession {
  final String day;
  final String time;

  CourseSession({required this.day, required this.time});
}

class CourseModel {
  final String name;
  final List<CourseSession> sessions;

  final String instructor;
  final int quota;
  final int requested;
  final int seniorRequested;

  CourseModel({
    required this.name,
    required this.sessions,
    required this.instructor,
    required this.quota,
    required this.requested,
    required this.seniorRequested,
  });
}
