import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/favorite_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final _favoritesRef = FirebaseFirestore.instance
      .collection('favorites')
      .withConverter<FavoriteCourse>(
        fromFirestore: (snap, _) =>
            FavoriteCourse.fromDoc(snap.id, snap.data() ?? {}),
        toFirestore: (fav, _) => fav.toMap(),
      );

  Stream<List<FavoriteCourse>> favoritesForUser(String userId) {
    return _favoritesRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((s) {
          final list = s.docs.map((d) => d.data()).toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  Future<void> addFavorite(FavoriteCourse favorite) async {
    final existing = await _favoritesRef
        .where('userId', isEqualTo: favorite.userId)
        .where('courseCode', isEqualTo: favorite.courseCode)
        .get();
    
    if (existing.docs.isNotEmpty) {
      throw 'This course is already in your favorites';
    }
    
    await _favoritesRef.add(favorite);
  }

  Future<void> deleteFavorite(String favoriteId) async {
    await _favoritesRef.doc(favoriteId).delete();
  }

  Future<void> updateFavorite(String favoriteId, FavoriteCourse favorite) async {
    final existing = await _favoritesRef
        .where('userId', isEqualTo: favorite.userId)
        .where('courseCode', isEqualTo: favorite.courseCode)
        .get();
    
    final otherFavorites = existing.docs
        .where((doc) => doc.id != favoriteId)
        .toList();
    
    if (otherFavorites.isNotEmpty) {
      throw 'This course is already in your favorites';
    }
    
    await _favoritesRef.doc(favoriteId).update(favorite.toMap());
  }
}


