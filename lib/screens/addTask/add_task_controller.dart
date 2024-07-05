import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/screens/auth/controller/firebase_auth_service.dart';

class addTasks {
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userId = FirebaseAuthService().userId;

  Future<bool> addTask(String task) async {
    String taskId =
        _firestore.collection('users').doc(userId).collection('tasks').doc().id;
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .doc()
          .set({
        'id': taskId,
        'task': task,
        'status': false,
        'created at': DateTime.now()
      });

      //.set({'name': name, 'email': email, 'created at': DateTime.now()});
      return true;
    } catch (e) {
      print("Error signing up: $e");
      return false;
    }
  }
}
