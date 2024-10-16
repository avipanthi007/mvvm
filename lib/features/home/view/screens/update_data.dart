import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:mvvm/core/local_storage/shared_pref.dart';
import 'package:mvvm/error/server_exception/server_exception.dart';
import 'package:mvvm/features/home/models/data_model.dart';
import 'package:mvvm/features/home/view/screens/home_screen.dart';
import 'package:mvvm/features/home/view/widgets/repeated_textfield.dart';

class UpdateData extends StatefulWidget {
  TodoModel? items;
  UpdateData({super.key, this.items});

  @override
  State<UpdateData> createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  @override
  void initState() {
    titleController.text = widget.items!.title;
    descriptionController.text = widget.items!.description;

    super.initState();
  }

  updateData() async {
    try {
      itemList = await LocalStorage().getData() ?? [];
      List<TodoModel> item = itemList;
      int index = item.indexWhere((p) => p.title == widget.items!.title);

      TodoModel data = TodoModel(
          title: titleController.text,
          description: descriptionController.text,
          disableText: false);
      debugPrint(jsonEncode(data));
      debugPrint(index.toString());
      await LocalStorage()
          .updateData(data, index)
          .then((value) => Get.offAll(ToDoHomeScreen()));
    } catch (e) {
      Logger().e(e.toString());
    }
  }

  int index = 0;
  List<TodoModel> itemList = [];
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do App"),
      ),
      body: Column(
        children: [
          kRepeatedTextField(
            controller: titleController,
          ),
          SizedBox(
            height: 20,
          ),
          kRepeatedTextField(
            controller: descriptionController,
            maxLines: 10,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          updateData();
        },
        child: Text("Save", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
