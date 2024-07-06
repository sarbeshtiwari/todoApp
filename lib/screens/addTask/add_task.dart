import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/const/colors.dart';
import 'package:todoapp/const/custom_button.dart';
import 'package:todoapp/const/custom_textfield.dart';
import 'package:todoapp/screens/addTask/controller/upload_image.dart';
import 'package:todoapp/screens/home/home_screen.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController _taskController = TextEditingController();
  final QuillController _taskDescriptionController = QuillController.basic();

  String newTask = '';
  String description = '';
  String image_url = '';

  final UploadImage _uploadData = UploadImage();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    final Rx<File?> _selectedFile = Rx<File?>(null);

//using imagepicker to pick a image
    Future<void> _pickFile() async {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      try {
        if (pickedFile != null) {
          _selectedFile.value = File(pickedFile.path);
        }
      } catch (e) {
        print('Error picking image: $e');
      }
    }

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
      body: SingleChildScrollView(
        child: Padding(
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
              Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)),
                height: 250,
                //adding description
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: QuillEditor.basic(
                    configurations: QuillEditorConfigurations(
                      controller: _taskDescriptionController,
                      sharedConfigurations: const QuillSharedConfigurations(
                        locale: Locale('de'),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              //picking image
              Obx(
                () => _selectedFile.value == null
                    ? GestureDetector(
                        onTap: _pickFile,
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 100,
                              ),
                              Text("Upload Image")
                            ],
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            child: Image.file(
                              _selectedFile.value!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
              ),
              SizedBox(height: 25),
              //toolbar for description
              QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                  controller: _taskDescriptionController,
                  sharedConfigurations: const QuillSharedConfigurations(
                    locale: Locale('de'),
                  ),
                ),
              ),
              // Container(),
              SizedBox(height: 25),

              GestureDetector(
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  //uploading the image and the task
                  bool result = await _uploadData.uploadTask(newTask,
                      _taskDescriptionController, _selectedFile.value!);
                  // _selectedFile.value!,

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
