import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton pattern: private constructor and instance
  FirebaseAuthService._privateConstructor();
  static final FirebaseAuthService _instance =
      FirebaseAuthService._privateConstructor();
  factory FirebaseAuthService() => _instance;

  // Getter for current user ID
  String? get userId => _auth.currentUser?.uid;

  // Example method for signing up
  Future<bool> signUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Create a new document for the user with the user's UID
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set({'name': name, 'email': email, 'created at': DateTime.now()});
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error signing up: $e");
      return false;
    }
  }

// Add other authentication methods as needed (sign in, sign out, etc.)
  Future<bool> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Signed in as: ${userCredential.user!.email}');

      return userCredential.user != null;
      // Navigate to the home screen or show a success message
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  void storeUserId() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', '1');
}
}
