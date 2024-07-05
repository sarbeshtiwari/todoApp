import 'package:flutter/material.dart';
import 'package:todoapp/screens/home/delete_task.dart';

Future<bool?> showDeleteConfirmationDialog(BuildContext context, docId) async {
  final DeleteTask _delete = DeleteTask();
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirm"),
        content: Text("Are you sure you want to delete this task?"),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text("Delete"),
            onPressed: () {
              _delete.deleteUserTasks(docId);
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
