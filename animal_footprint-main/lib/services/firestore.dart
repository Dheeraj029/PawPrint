import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:animal/services/auth.dart';
import 'package:animal/services/models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Reads all documents from the animals collection
  Future<List<Animal>> getAnimals() async {
    var ref = _db.collection('animals');
    var snapshot = await ref.get();

    // Safely map data from the snapshot, handling any missing fields
    var animals = snapshot.docs.map((doc) {
      return Animal.fromJson(doc.data());
    }).toList();

    return animals;
  }

  Stream<List<ClassificationHistory>> streamClassificationHistory() {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var userRef =
            _db.collection('users').doc(user.uid).collection('history');
        return userRef.snapshots().map((snapshot) {
          return snapshot.docs.map((doc) {
            // Ensure the fields are properly parsed
            return ClassificationHistory.fromJson(
                doc.data() as Map<String, dynamic>);
          }).toList();
        });
      } else {
        return Stream.value(
            []); // Return an empty list if the user is not logged in
      }
    });
  }

  /// Fetches the classification history of a specific user from Firestore
  Future<List<ClassificationHistory>> getClassificationHistory(
      String userId) async {
    try {
      var userHistoryRef =
          _db.collection('users').doc(userId).collection('history');
      var snapshot = await userHistoryRef.get();

      // Map snapshot documents to ClassificationHistory objects
      var history = snapshot.docs.map((doc) {
        return ClassificationHistory.fromJson(
            doc.data() as Map<String, dynamic>);
      }).toList();

      return history;
    } catch (e) {
      print("Error fetching classification history: $e");
      return [];
    }
  }

  /// Updates classification history for the user (geoTag is not required here)
  Future<void> updateClassificationHistory(String footprintImage,
      String predictedAnimalName, double accuracy) async {
    User? currentUser =
        await AuthService().getCurrentUser(); // Get current user asynchronously
    if (currentUser == null) {
      print("User is not logged in.");
      return;
    }

    // Create a new ClassificationHistory object
    ClassificationHistory history = ClassificationHistory(
      footprintImage: footprintImage,
      predictedAnimalName: predictedAnimalName,
      classifiedAt: DateTime.now(),
      classificationAccuracy: accuracy,
    );

    try {
      // Add the classification history under the correct path in Firestore
      var historyRef = _db
          .collection('users')
          .doc(currentUser.uid)
          .collection('history')
          .doc();
      await historyRef.set(history.toJson());

      print("Classification history added to Firestore.");
    } catch (e) {
      print("Error updating classification history: $e");
    }
  }

  /// Adds or updates a report document for a user
  Future<void> updateUserReport(
      String uid, int totalClassifications, Map<String, int> topics) async {
    var reportRef = _db.collection('reports').doc(uid);

    await reportRef.set({
      'uid': uid,
      'totalClassifications': totalClassifications,
      'topics': topics,
    }, SetOptions(merge: true)).catchError((e) {
      print("Error updating report: $e");
    });
  }
}
