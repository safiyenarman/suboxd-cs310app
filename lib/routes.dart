import 'package:flutter/material.dart';

import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/followers_screen.dart';
import 'screens/followings_screen.dart';
import 'screens/course_planner_screen.dart';
import 'screens/course_planner_info_screen.dart';
import 'screens/all_courses_screen.dart';
import 'screens/courses_history_screen.dart';
import 'screens/search_screen.dart';
import 'screens/home_screen.dart'; 
import 'screens/reviews_screen.dart' hide AddReviewScreen;
import 'screens/add_review_screen.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/join_screen.dart';
import 'screens/home_screen.dart';
import 'screens/friends_activity_screen.dart';

class Routes {

  static const splash = '/';
  static const login = '/login';
  static const join = '/join';
  static const home = '/home'; 
  static const search = '/search'; 
  static const friendsActivity = '/friends-activity'; 
  static const reviews = '/reviews'; 
  static const addReview = '/add-review'; 

  static const coursePlanner = '/course-planner';
  static const coursePlannerInfo = '/course-planner-info';
  static const allCourses = '/all-courses'; 
  static const coursesHistory = '/courses-history'; 

  
  static Map<String, WidgetBuilder> getRoutes() => {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    join: (_) => const JoinScreen(),

    home: (_) => const HomeScreen(), 
    search: (_) => const SearchScreen(), 
    friendsActivity: (_) => const FriendsActivityScreen(), 
    ProfileScreen.routeName: (_) => const ProfileScreen(), 
    reviews: (_) => const ReviewsScreen(),
    addReview: (_) => const AddReviewScreen(),
    
    SettingsScreen.routeName: (_) => const SettingsScreen(),
    FollowersScreen.routeName: (_) => const FollowersScreen(),
    FollowingsScreen.routeName: (_) => const FollowingsScreen(),
    coursePlanner: (_) => const CoursePlannerScreen(),
    coursePlannerInfo: (_) => const CoursePlannerInfoScreen(),
    allCourses: (_) => const CoursesGridScreen(), 
    coursesHistory: (_) => const CoursesScreen(), 
  };
}
