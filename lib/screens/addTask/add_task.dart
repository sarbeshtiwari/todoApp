import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/const/colors.dart';
import 'package:todoapp/const/custom_button.dart';
import 'package:todoapp/const/custom_textfield.dart';
import 'package:todoapp/screens/addTask/add_task_controller.dart';
import 'package:todoapp/screens/home/home_screen.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController _taskController = TextEditingController();
  String newTask = '';
  final addTasks _addTaskController =
      addTasks(); // Instance of FirebaseController
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          "Add Task",
          style: TextStyle(color: AppColors.text),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.appBar,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * .09, vertical: h * .05),
        child: Column(
          children: [
            CustomTextField(
              controller: _taskController,
              labelText: 'Add Task',
              onChanged: (value) {
                setState(() {
                  newTask = value;
                });
              },
            ),
            SizedBox(height: 25),
            GestureDetector(
              onTap: () async {
                setState(() {
                  _isLoading = true;
                });
                bool result = await _addTaskController.addTask(newTask);
                setState(() {
                  _isLoading = false;
                });
                if (result) {
                  Get.off(HomeScreen());
                } else {
                  Get.snackbar('Failed', 'Task Not Added');
                }
                // Get.to(HomeScreen());
              },
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : CustomButton(text: "Add Task"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the TextEditingController when done using it
    _taskController.dispose();
    super.dispose();
  }
}
