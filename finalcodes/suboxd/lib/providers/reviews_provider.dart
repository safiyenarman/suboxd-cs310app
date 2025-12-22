import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/review_model.dart';
import '../models/review_like_model.dart';

class ReviewsProvider extends ChangeNotifier {
  final _reviewsRef =
      FirebaseFirestore.instance.collection('reviews').withConverter<Review>(
            fromFirestore: (snap, _) =>
                Review.fromDoc(snap.id, snap.data() ?? {}),
            toFirestore: (review, _) => review.toMap(),
          );

  final _likesRef = FirebaseFirestore.instance
      .collection('reviewLikes')
      .withConverter<ReviewLike>(
        fromFirestore: (snap, _) =>
            ReviewLike.fromDoc(snap.id, snap.data() ?? {}),
        toFirestore: (like, _) => like.toMap(),
      );

  Stream<List<Review>> reviewsStream() {
    return _reviewsRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((d) => d.data()).toList());
  }


  Future<bool> hasUserLikedReview(String reviewId, String userId) async {
    if (userId.isEmpty) return false;
    try {
      final likeQuery = await _likesRef
          .where('reviewId', isEqualTo: reviewId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();
      return likeQuery.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }


  Stream<Set<String>> getUserLikedReviews(String userId) {
    if (userId.isEmpty) {
      return Stream.value(<String>{});
    }
    return _likesRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data().reviewId)
            .toSet());
  }


  Future<void> toggleLike(String reviewId, String userId) async {
    if (userId.isEmpty) {
      throw 'User must be logged in to like reviews';
    }

    try {
      
      final existingLike = await _likesRef
          .where('reviewId', isEqualTo: reviewId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      final reviewRef = _reviewsRef.doc(reviewId);
      final reviewDoc = await reviewRef.get();
      
      if (!reviewDoc.exists) {
        throw 'Review not found';
      }

      final currentLikes = (reviewDoc.data()?.likes ?? 0) as int;

      if (existingLike.docs.isNotEmpty) {
       
        await existingLike.docs.first.reference.delete();
        await reviewRef.update({'likes': currentLikes - 1});
      } else {
        
        await _likesRef.add(ReviewLike(
          id: '',
          reviewId: reviewId,
          userId: userId,
          createdAt: DateTime.now(),
        ));
        await reviewRef.update({'likes': currentLikes + 1});
      }
    } catch (e) {
      throw 'Failed to toggle like: $e';
    }
  }

  Future<void> addReview(Review review) async {
    await _reviewsRef.add(review);
  }

  Future<void> deleteReview(String reviewId) async {
    
    final likes = await _likesRef
        .where('reviewId', isEqualTo: reviewId)
        .get();
    
    final batch = FirebaseFirestore.instance.batch();
    for (var likeDoc in likes.docs) {
      batch.delete(likeDoc.reference);
    }
    await batch.commit();
    
    
    await _reviewsRef.doc(reviewId).delete();
  }

  Future<void> updateReview(Review review) async {
    await _reviewsRef.doc(review.id).update(review.toMap());
  }

  Future<List<Map<String, dynamic>>> getCoursesByReviewCount() async {
    try {
      final reviews = await _reviewsRef.get();
      final courseCounts = <String, Map<String, dynamic>>{};
      
      for (var doc in reviews.docs) {
        final review = doc.data();
        final courseCode = review.courseCode;
        
        if (courseCounts.containsKey(courseCode)) {
          courseCounts[courseCode]!['count'] = 
              (courseCounts[courseCode]!['count'] as int) + 1;
        } else {
          courseCounts[courseCode] = {
            'courseCode': courseCode,
            'courseName': review.courseName,
            'imageAsset': review.imageAsset,
            'count': 1,
          };
        }
      }
      
      final sorted = courseCounts.values.toList()
        ..sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));
      
      return sorted;
    } catch (e) {
      print('Error getting courses by review count: $e');
      return [];
    }
  }

  Future<List<Review>> getReviewsByLikes({int limit = 10}) async {
    try {
      final reviews = await _reviewsRef
          .orderBy('likes', descending: true)
          .limit(limit)
          .get();
      
      return reviews.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error getting reviews by likes: $e');
      return [];
    }
  }

  Future<int> getUserReviewCount(String userId) async {
    try {
      
      final reviews = await _reviewsRef
          .where('username', isEqualTo: userId)
          .get();
      return reviews.docs.length;
    } catch (e) {
      return 0;
    }
  }

  // Get reviews for a user
  Stream<List<Review>> getUserReviews(String userId) {
    return _reviewsRef
        .where('username', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((d) => d.data()).toList());
  }

  // Get total ratings count for a user (same as review count)
  Future<int> getUserRatingsCount(String userId) async {
    return getUserReviewCount(userId);
  }

  // Get average rating for a course (by courseCode or courseName)
  Future<double> getAverageRatingForCourse(String courseIdentifier) async {
    try {
      // Try to find reviews by courseCode first
      var reviews = await _reviewsRef
          .where('courseCode', isEqualTo: courseIdentifier)
          .get();
      
      // If not found, try by courseName
      if (reviews.docs.isEmpty) {
        reviews = await _reviewsRef
            .where('courseName', isEqualTo: courseIdentifier)
            .get();
      }
      
      if (reviews.docs.isEmpty) {
        return 0.0;
      }
      
      double totalRating = 0.0;
      for (var doc in reviews.docs) {
        final review = doc.data();
        totalRating += review.rating;
      }
      
      return totalRating / reviews.docs.length;
    } catch (e) {
      print('Error getting average rating for course $courseIdentifier: $e');
      return 0.0;
    }
  }

  // Get average ratings for multiple courses
  Future<Map<String, double>> getAverageRatingsForCourses(List<String> courseIdentifiers) async {
    final Map<String, double> ratings = {};
    
    for (var courseIdentifier in courseIdentifiers) {
      ratings[courseIdentifier] = await getAverageRatingForCourse(courseIdentifier);
    }
    
    return ratings;
  }

  // Stream of average ratings for multiple courses (real-time updates)
  Stream<Map<String, double>> getAverageRatingsStreamForCourses(List<String> courseIdentifiers) {
    return _reviewsRef.snapshots().map((snapshot) {
      final allReviews = snapshot.docs.map((d) => d.data()).toList();
      final Map<String, List<double>> courseRatings = {};
      
      // Group ratings by course
      for (var review in allReviews) {
        // Try to match by courseCode first
        String? matchedIdentifier;
        for (var identifier in courseIdentifiers) {
          if (review.courseCode == identifier || review.courseName == identifier) {
            matchedIdentifier = identifier;
            break;
          }
        }
        
        if (matchedIdentifier != null) {
          if (!courseRatings.containsKey(matchedIdentifier)) {
            courseRatings[matchedIdentifier] = [];
          }
          courseRatings[matchedIdentifier]!.add(review.rating);
        }
      }
      
      final Map<String, double> averages = {};
      for (var identifier in courseIdentifiers) {
        final ratings = courseRatings[identifier];
        if (ratings != null && ratings.isNotEmpty) {
          final sum = ratings.fold(0.0, (a, b) => a + b);
          averages[identifier] = sum / ratings.length;
        } else {
          averages[identifier] = 0.0;
        }
      }
      
      return averages;
    });
  }

  
  Stream<Map<String, double>> getUserRatingsStreamForCourses(String username, List<String> courseIdentifiers) {
    return _reviewsRef
        .where('username', isEqualTo: username)
        .snapshots()
        .map((snapshot) {
      final userReviews = snapshot.docs.map((d) => d.data()).toList();
      final Map<String, double> ratings = {};
      
      // Initialize all courses with 0.0
      for (var identifier in courseIdentifiers) {
        ratings[identifier] = 0.0;
      }
      
      // For each course, find the user's review (if exists)
      for (var identifier in courseIdentifiers) {
        // Find all reviews for this course
        final courseReviews = userReviews.where((review) {
          return review.courseCode == identifier || review.courseName == identifier;
        }).toList();
        
        if (courseReviews.isNotEmpty) {
          // If multiple reviews exist, take the latest one (most recent)
          courseReviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          ratings[identifier] = courseReviews.first.rating;
        }
      }
      
      return ratings;
    });
  }

  Stream<List<int>> getUserRatingDistributionStream(String username) {
    return _reviewsRef
        .where('username', isEqualTo: username)
        .snapshots()
        .map((snapshot) {
      final userReviews = snapshot.docs.map((d) => d.data()).toList();
      
      final List<int> distribution = [0, 0, 0, 0, 0]; 
      
      for (var review in userReviews) {
        final rating = review.rating.round(); 
        if (rating >= 1 && rating <= 5) {
          distribution[rating - 1]++; 
        }
      }
      
      return distribution;
    });
  }
}


