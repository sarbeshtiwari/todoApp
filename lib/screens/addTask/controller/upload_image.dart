import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:todoapp/screens/addTask/controller/add_task_controller.dart';
import 'package:todoapp/screens/auth/controller/firebase_auth_service.dart';

class UploadImage {
  String? userId = FirebaseAuthService().userId;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  final addTasks _addTaskController = addTasks();

  Future<bool> uploadTask(
      String task, quill.QuillController description, File image) async {
    User? user = auth.currentUser;

    // Check for signed-in user
    if (user == null) {
      print('No user is signed in.');
      return false;
    }
    Reference ref = storage.ref('users/$userId/$image');

    try {
      // Log file size and type for debugging
      print(image.lengthSync());
      print(image.path.split('.').last);

      // Upload the image 
      await ref.putFile(image).then((snapshot) {
        print('Image upload complete: ${snapshot.state}');
      }).catchError((error) {
        print('Error uploading image: $error');
      });

      // Get the download URL
      String imageUrl = await ref.getDownloadURL();
      print('Image URL: $imageUrl');

      await _addTaskController.addTask(task, description, imageUrl);
      return true;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
