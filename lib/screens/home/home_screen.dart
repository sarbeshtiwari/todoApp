import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/const/colors.dart';
import 'package:todoapp/screens/addTask/add_task.dart';
import 'package:todoapp/screens/auth/login_screen.dart';
import 'package:todoapp/screens/home/get_task.dart';
import 'package:todoapp/screens/home/model.dart';
import 'package:todoapp/screens/initialScreen/initial_screen.dart';
import 'package:todoapp/widget/delete.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FetchTask _authService = FetchTask();
  List<TaskModel> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  //fetch the data from the firestore

  Future<void> _fetchTasks() async {
    try {
      List<TaskModel> tasks = await _authService.fetchUserTasks();

      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching tasks: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateTaskStatus(String taskId, bool newStatus) async {
    try {
      // Update the task status in Firestore
      await _authService.updateTaskStatus(taskId, newStatus);

      // Refresh the task list
      await _fetchTasks();
    } catch (e) {
      print("Error updating task status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          "Task Manager",
          style: TextStyle(color: AppColors.text),
        ),
        actions: [
          IconButton(
              onPressed: () {
                storeLoginState(false);
                Get.off(LoginScreen());
              },
              icon: Icon(
                Icons.logout_outlined,
                color: Colors.white,
              )),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.appBar,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _tasks.isEmpty
              ? Stack(
                  children: [
                    Center(child: Text("No tasks found")),
                    Positioned(
                      bottom: 16.0,
                      right: 16.0,
                      child: FloatingActionButton(
                        onPressed: () {
                          Get.to(() => AddTask());
                        },
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    ListView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        TaskModel task = _tasks[index];
                        return Dismissible(
                          key: Key(task.task),
                          direction: DismissDirection.horizontal,
                          background: Container(
                            color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 20.0),
                                  child:
                                      Icon(Icons.delete, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          confirmDismiss: (DismissDirection direction) async {
                            bool? confirm = await showDeleteConfirmationDialog(
                                context, task.docid);
                            return confirm;
                          },
                          onDismissed: (direction) {
                            // Remove the item from the data source
                            if (direction == DismissDirection.endToStart) {
                              setState(() {
                                _tasks.removeAt(index);
                              });

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Task deleted"),
                              ));
                            }
                          },
                          child: ListTile(
                            title: Text(
                              task.task,
                              style: task.status
                                  ? TextStyle(
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.lineThrough)
                                  : TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Checkbox(
                              value: task.status,
                              onChanged: (bool? value) {
                                setState(() {
                                  task.status = value ?? false;
                                });
                                print(task.id);
                                print(task.status);
                                print(task.docid);
                                _updateTaskStatus(task.docid, task.status);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 16.0,
                      right: 16.0,
                      child: FloatingActionButton(
                        onPressed: () {
                          Get.to(AddTask());
                        },
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
    );
  }
}
