import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:todoapp/const/custom_button.dart';

void viewTask(
  BuildContext context, {
  required String task,
  required String description,
  required String image_url,
}) {
  // Decode the description JSON string back to Delta object
  final List<dynamic> deltaList = jsonDecode(description);
  final quill.QuillController controller = quill.QuillController(
    document: quill.Document.fromJson(deltaList),
    selection: TextSelection.collapsed(offset: 0),
    readOnly: true,
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      minChildSize: 0.5,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) => LayoutBuilder(
        builder: (context, constraints) {
          final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
          return AnimatedPadding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Task Details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Text(
                              'Task:- ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              task,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Description:- ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        quill.QuillEditor.basic(
                          configurations: quill.QuillEditorConfigurations(
                            controller: controller,
                            sharedConfigurations:
                                const quill.QuillSharedConfigurations(
                              locale: Locale('de'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Image.network(
                          image_url,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: CustomButton(
                            text: 'Back',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
