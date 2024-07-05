import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteTask {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get userId => _auth.currentUser?.uid;

  Future<void> deleteUserTasks(String docId) async {
    try {
      if (userId != null) {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('tasks')
            .doc(docId)
            .delete();
      }
      print('Done');
    } catch (e) {
      print("Error updating task status: $e");
      throw e; // Optional: Throw the error for handling in UI or caller
    }
  }
}
