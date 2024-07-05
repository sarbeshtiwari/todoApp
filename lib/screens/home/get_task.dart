import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoapp/screens/home/model.dart';

class FetchTask {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get userId => _auth.currentUser?.uid;

  Future<List<TaskModel>> fetchUserTasks() async {
    List<TaskModel> tasks = [];

    try {
      if (userId != null) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('tasks')
            .orderBy('created at', descending: false)
            .get();

        tasks = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return TaskModel(
            docid: doc.id,
            task: data['task'] ?? '',
            id: data['id'] ?? '',
            status: data['status'] ?? false,
          );
        }).toList();
      }
    } catch (e) {
      print("Error fetching tasks: $e");
    }

    return tasks;
  }

  Future<void> updateTaskStatus(String docId, bool newStatus) async {
    try {
      if (userId != null) {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('tasks')
            .doc(docId)
            .update({'status': newStatus});
      }
      print('Done');
    } catch (e) {
      print("Error updating task status: $e");
      throw e; // Optional: Throw the error for handling in UI or caller
    }
  }
}
