import 'package:flutter/material.dart';

// KENDİ EKRANLARINIZIN IMPORTLARI
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/followers_screen.dart';
import 'screens/followings_screen.dart';
import 'screens/course_planner_screen.dart';
import 'screens/course_planner_info_screen.dart';
import 'screens/all_courses_screen.dart';
import 'screens/courses_history_screen.dart';
import 'screens/search_screen.dart';
import 'screens/home_screen.dart'; // Ana sayfaya dönüş için
import 'screens/reviews_screen.dart' hide AddReviewScreen;
import 'screens/add_review_screen.dart';

// ARKADAŞININ EKRANLARININ IMPORTLARI (Home, Splash, Login, Join ve Friends Activity)
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/join_screen.dart';
import 'screens/home_screen.dart';
import 'screens/friends_activity_screen.dart';

class Routes {
  // ================== ROUTE NAME SABİTLERİ (TÜMÜ) ==================

  // Ana Navigasyon Çubuğu Ekranları
  static const splash = '/';
  static const login = '/login';
  static const join = '/join';
  static const home = '/home'; // Index 0
  static const search = '/search'; // Index 1
  static const friendsActivity = '/friends-activity'; // Index 3 (Flash ikonu)
  static const reviews = '/reviews'; // ⭐️ Yeni
  static const addReview = '/add-review'; // ⭐️ Yeni

  // Diğer Ekranlar
  static const coursePlanner = '/course-planner';
  static const coursePlannerInfo = '/course-planner-info';
  static const allCourses = '/all-courses'; // Courses ekranı
  static const coursesHistory = '/courses-history'; // Plan to Take/More Activity

  // Not: Profile, Settings, Followers ve Followings kendi routeName sabitlerini kullanıyor.


  // ================== TÜM ROUTE MAP'İNİN BİRLEŞTİRİLMESİ ==================
  static Map<String, WidgetBuilder> getRoutes() => {
    // 1. Giriş Akışı (Arkadaşının Ekranları)
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    join: (_) => const JoinScreen(),

    // 2. Ana Navigasyon Çubuğu Ekranları
    home: (_) => const HomeScreen(), // Index 0
    search: (_) => const SearchScreen(), // Index 1
    friendsActivity: (_) => const FriendsActivityScreen(), // Index 3
    ProfileScreen.routeName: (_) => const ProfileScreen(), // Index 4
    reviews: (_) => const ReviewsScreen(),
    addReview: (_) => const AddReviewScreen(),
    // 3. Diğer Ekranlar (Senin Ekranların)
    SettingsScreen.routeName: (_) => const SettingsScreen(),
    FollowersScreen.routeName: (_) => const FollowersScreen(),
    FollowingsScreen.routeName: (_) => const FollowingsScreen(),
    coursePlanner: (_) => const CoursePlannerScreen(),
    coursePlannerInfo: (_) => const CoursePlannerInfoScreen(),
    allCourses: (_) => const CoursesGridScreen(), // all_courses_screen.dart içindeki sınıf adı
    coursesHistory: (_) => const CoursesScreen(), // courses_history_screen.dart içindeki sınıf adı
  };
}