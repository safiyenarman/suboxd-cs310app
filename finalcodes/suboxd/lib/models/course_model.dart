import 'package:cloud_firestore/cloud_firestore.dart';

class CourseSession {
  final String day;
  final String time;

  CourseSession({required this.day, required this.time});

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'time': time,
    };
  }

  factory CourseSession.fromMap(Map<String, dynamic> data) {

    String day = data['day'] as String? ??
                 data['Day'] as String? ??
                 data['weekday'] as String? ??
                 data['weekDay'] as String? ??
                 '';

    if (day.isNotEmpty) {
      day = day.substring(0, 1).toUpperCase() + day.substring(1).toLowerCase();
    }

    String time = data['time'] as String? ??
                  data['Time'] as String? ??
                  data['startTime'] as String? ??
                  data['start_time'] as String? ??
                  '';

    if (time.isNotEmpty) {

      if (time.contains('.') && !time.contains(':')) {
        time = time.replaceAll('.', ':');
      }

      if (time.contains(':') && time.split(':').length == 3) {
        final parts = time.split(':');
        time = '${parts[0]}:${parts[1]}';
      }

      if (time.toLowerCase().contains('am') || time.toLowerCase().contains('pm')) {

        time = time.replaceAll(RegExp(r'\s*(am|pm)', caseSensitive: false), '');
      }

      if (time.contains(':')) {
        final parts = time.split(':');
        if (parts.length >= 2) {
          final hour = parts[0].padLeft(2, '0');
          final minute = parts[1].padLeft(2, '0');
          time = '$hour:$minute';
        }
      }
    }

    return CourseSession(
      day: day,
      time: time,
    );
  }
}

class CourseModel {
  final String id;
  final String name;
  final String? courseName;
  final List<CourseSession> sessions;
  final String instructor;
  final int quota;
  final int requested;
  final int seniorRequested;

  CourseModel({
    required this.id,
    required this.name,
    this.courseName,
    required this.sessions,
    required this.instructor,
    required this.quota,
    required this.requested,
    required this.seniorRequested,
  });

  String get courseCode => name;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'instructor': instructor,
      'quota': quota,
      'requested': requested,
      'seniorRequested': seniorRequested,
      'sessions': sessions.map((s) => s.toMap()).toList(),
    };
  }

  factory CourseModel.fromDoc(String id, Map<String, dynamic> data) {
    try {

      String courseCode = data['code'] as String? ??
                         data['courseCode'] as String? ??
                         data['name'] as String? ??
                         id;

      String? fullCourseName = data['courseName'] as String? ??
                              data['fullName'] as String? ??
                              data['description'] as String?;

      final nameField = data['name'] as String?;
      if (nameField != null && nameField != courseCode && fullCourseName == null) {

        if (nameField.contains(' ') && nameField.length > courseCode.length) {
          fullCourseName = nameField;

          if (nameField.contains(courseCode)) {
            courseCode = nameField.split(' ').take(2).join(' ');
          }
        } else {

          courseCode = nameField;
        }
      }

      String instructorName = data['instructor'] as String? ??
                             data['Instructure'] as String? ??
                             data['Instructor'] as String? ??
                             '';

      List<dynamic>? sessionsList;

      if (data.containsKey('sessions')) {
        final sessionsData = data['sessions'];

        if (sessionsData is List) {
          sessionsList = sessionsData;
        } else if (sessionsData is Map) {

          sessionsList = sessionsData.values.toList();
          print('Course $id: Converted sessions map to list (${sessionsList.length} items)');
        }
      } else if (data.containsKey('Sessions')) {
        final sessionsData = data['Sessions'];
        if (sessionsData is List) {
          sessionsList = sessionsData;
        } else if (sessionsData is Map) {
          sessionsList = sessionsData.values.toList();
        }
      } else if (data.containsKey('schedule')) {
        final scheduleData = data['schedule'];
        if (scheduleData is List) {
          sessionsList = scheduleData;
        } else if (scheduleData is Map) {
          sessionsList = scheduleData.values.toList();
        }
      } else if (data.containsKey('Schedule')) {
        final scheduleData = data['Schedule'];
        if (scheduleData is List) {
          sessionsList = scheduleData;
        } else if (scheduleData is Map) {
          sessionsList = scheduleData.values.toList();
        }
      } else if (data.containsKey('times')) {
        final timesData = data['times'];
        if (timesData is List) {
          sessionsList = timesData;
        } else if (timesData is Map) {
          sessionsList = timesData.values.toList();
        }
      } else if (data.containsKey('Times')) {
        final timesData = data['Times'];
        if (timesData is List) {
          sessionsList = timesData;
        } else if (timesData is Map) {
          sessionsList = timesData.values.toList();
        }
      } else if (data.containsKey('classTimes')) {
        final classTimesData = data['classTimes'];
        if (classTimesData is List) {
          sessionsList = classTimesData;
        } else if (classTimesData is Map) {
          sessionsList = classTimesData.values.toList();
        }
      } else if (data.containsKey('meetingTimes')) {
        final meetingTimesData = data['meetingTimes'];
        if (meetingTimesData is List) {
          sessionsList = meetingTimesData;
        } else if (meetingTimesData is Map) {
          sessionsList = meetingTimesData.values.toList();
        }
      }

      if (sessionsList == null || sessionsList.isEmpty) {
        sessionsList = _buildSessionsFromDateFields(data);
      }

      sessionsList ??= [];
      final sessions = <CourseSession>[];

      print('Course $id ($courseCode): Parsing sessions...');
      print('  Sessions list length: ${sessionsList.length}');
      if (sessionsList.isEmpty) {
        print('  No sessions array found. Available fields: ${data.keys.join(", ")}');

        data.forEach((key, value) {
          final valueStr = value.toString();
          final truncated = valueStr.length > 100 ? '${valueStr.substring(0, 100)}...' : valueStr;
          print('  $key: $truncated (${value.runtimeType})');
        });
      } else {
        print('  Found ${sessionsList.length} session(s) in data');
      }

      for (var sessionData in sessionsList) {
        try {
          if (sessionData is Map) {

            final sessionMap = sessionData.map((key, value) =>
              MapEntry(key.toString(), value));

            final session = CourseSession.fromMap(sessionMap);
            if (session.day.isNotEmpty && session.time.isNotEmpty) {
              sessions.add(session);
              print('Course $id: Successfully parsed session - ${session.day} at ${session.time}');
            } else {
              print('Course $id: Skipping invalid session - day: "${session.day}", time: "${session.time}"');
              print('Session data keys: ${sessionMap.keys.join(", ")}');
              print('Session data values: ${sessionMap.values.join(", ")}');
            }
          } else {
            print('Course $id: Session data is not a Map: ${sessionData.runtimeType}');
            print('Session data: $sessionData');
          }
        } catch (e, stackTrace) {
          print('Error parsing session for course $id: $e');
          print('Stack trace: $stackTrace');
          print('Session data: $sessionData');
        }
      }

      if (sessionsList.isNotEmpty && sessions.isEmpty) {
        print('Course $id: Found ${sessionsList.length} sessions in data but none were valid');
        print('Sessions data: $sessionsList');
      } else if (sessions.isNotEmpty) {
        print('Course $id: Successfully parsed ${sessions.length} sessions');
      }

      return CourseModel(
        id: id,
        name: courseCode,
        courseName: fullCourseName,
        instructor: instructorName,
        quota: (data['quota'] as num?)?.toInt() ??
               (data['capacity'] as num?)?.toInt() ??
               0,
        requested: (data['requested'] as num?)?.toInt() ?? 0,
        seniorRequested: (data['seniorRequested'] as num?)?.toInt() ?? 0,
        sessions: sessions,
      );
    } catch (e) {
      print('Error creating CourseModel from doc $id: $e');
      print('Data: $data');
      rethrow;
    }
  }

  static List<dynamic> _buildSessionsFromDateFields(Map<String, dynamic> data) {
    final sessions = <Map<String, dynamic>>[];

    final date = data['date'] ?? data['Date'] ?? data['classDate'] ?? data['startDate'];
    final time = data['time'] ?? data['Time'] ?? data['startTime'] ?? data['classTime'];

    if (date != null && time != null) {
      final day = _extractDayFromDate(date);
      final timeStr = _extractTimeString(time);
      if (day.isNotEmpty && timeStr.isNotEmpty) {
        sessions.add({'day': day, 'time': timeStr});
      }
    }

    final dates = data['dates'] ?? data['Dates'] ?? data['classDates'];
    if (dates is List && dates.isNotEmpty) {
      for (var dateItem in dates) {
        if (dateItem is Map<String, dynamic>) {
          final d = dateItem['date'] ?? dateItem['Date'] ?? dateItem;
          final t = dateItem['time'] ?? dateItem['Time'] ?? time;
          if (d != null && t != null) {
            final day = _extractDayFromDate(d);
            final timeStr = _extractTimeString(t);
            if (day.isNotEmpty && timeStr.isNotEmpty) {
              sessions.add({'day': day, 'time': timeStr});
            }
          }
        }
      }
    }

    final dateTime = data['dateTime'] ?? data['DateTime'] ?? data['startDateTime'];
    if (dateTime != null) {
      final day = _extractDayFromDateTime(dateTime);
      final timeStr = _extractTimeFromDateTime(dateTime);
      if (day.isNotEmpty && timeStr.isNotEmpty) {
        sessions.add({'day': day, 'time': timeStr});
      }
    }

    return sessions;
  }

  static String _extractDayFromDate(dynamic date) {
    if (date == null) return '';

    DateTime? dateTime;

    if (date is DateTime) {
      dateTime = date;
    } else if (date is Timestamp) {
      dateTime = date.toDate();
    } else if (date is String) {
      dateTime = DateTime.tryParse(date);
    }

    if (dateTime != null) {
      final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      final dayIndex = dateTime.weekday - 1;
      if (dayIndex >= 0 && dayIndex < days.length) {
        return days[dayIndex];
      }
    }

    if (date is String) {
      final dayLower = date.toLowerCase();
      if (dayLower.contains('monday')) return 'Monday';
      if (dayLower.contains('tuesday')) return 'Tuesday';
      if (dayLower.contains('wednesday')) return 'Wednesday';
      if (dayLower.contains('thursday')) return 'Thursday';
      if (dayLower.contains('friday')) return 'Friday';
      if (dayLower.contains('saturday')) return 'Saturday';
      if (dayLower.contains('sunday')) return 'Sunday';
    }

    return '';
  }

  static String _extractTimeString(dynamic time) {
    if (time == null) return '';

    if (time is String) {

      String timeStr = time.trim();
      timeStr = timeStr.replaceAll(RegExp(r'\s*(am|pm)', caseSensitive: false), '');

      if (timeStr.contains(':') && timeStr.split(':').length == 3) {
        final parts = timeStr.split(':');
        timeStr = '${parts[0]}:${parts[1]}';
      }
      return timeStr;
    } else if (time is DateTime) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (time is Timestamp) {
      final dt = time.toDate();
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }

    return '';
  }

  static String _extractDayFromDateTime(dynamic dateTime) {
    return _extractDayFromDate(dateTime);
  }

  static String _extractTimeFromDateTime(dynamic dateTime) {
    return _extractTimeString(dateTime);
  }
}
