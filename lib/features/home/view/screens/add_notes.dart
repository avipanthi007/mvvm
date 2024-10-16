import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mvvm/core/local_storage/init_shared_pref.dart';
import 'package:mvvm/core/local_storage/shared_pref.dart';
import 'package:mvvm/features/home/models/data_model.dart';
import 'package:mvvm/features/home/view/screens/home_screen.dart';
import 'package:mvvm/features/home/view/widgets/repeated_textfield.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Notes"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              kRepeatedTextField(
                validator: (val) {
                  return val!.length == 0 ? "Please enter Title" : null;
                },
                controller: titleController,
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: kRepeatedTextField(
                  validator: (val) {
                    return val!.length == 0 ? "Please enter Description" : null;
                  },
                  controller: descriptionController,
                  maxLines: 10,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<TodoModel> dataList = await LocalStorage().getData() ?? [];

          TodoModel data = TodoModel(
              title: titleController.text,
              description: descriptionController.text,
              disableText: false);

          bool isRepeatedTitle = dataList.any((p) => p.title == data.title);

          if (isRepeatedTitle) {
            Get.snackbar("Message", "Title is already exist");
          } else {
            LocalStorage()
                .saveData(data)
                .then((value) => Get.offAll(ToDoHomeScreen()));
          }
        },
        child: Text(
          "Save",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
