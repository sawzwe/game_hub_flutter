import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HighScore {
  final String playerName;
  final int score;

  HighScore(this.playerName, this.score);

  factory HighScore.fromMap(Map<String, dynamic> data) {
    return HighScore(data['username'] ?? '', data['score'] ?? 0);
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createUser(String email, String userName) async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        "id": _auth.currentUser!.uid,
        "email": email,
        "username": userName,
        "score": 0, // Initial score when creating a user
      });
    } catch (err) {
      print(err);
    }
  }

  Future<String> getUserUsername() async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      return documentSnapshot.get('username') ?? '';
    } catch (err) {
      print(err);
      return '';
    }
  }

  Future<int> getUserScore() async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      return documentSnapshot.get('score') ?? 0;
    } catch (err) {
      print(err);
      return 0;
    }
  }

  Future<void> updateUserScore(int newScore) async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        "score": newScore,
      });
    } catch (err) {
      print(err);
    }
  }

  Future<List<HighScore>> getHighScores() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .orderBy('score', descending: true)
          .limit(5) // Adjust the limit as needed
          .get();

      return querySnapshot.docs.map((doc) {
        return HighScore.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (err) {
      print(err);
      return [];
    }
  }
}

