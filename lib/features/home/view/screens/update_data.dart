import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mvvm/core/local_storage/shared_pref.dart';
import 'package:mvvm/features/home/models/data_model.dart';
import 'package:mvvm/features/home/view/widgets/repeated_textfield.dart';

class UpdateData extends StatefulWidget {
  List itemsList = [];
  TodoModel? items;
  UpdateData({super.key, required this.itemsList, this.items});

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

  int index = 0;

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
          var temp = jsonEncode(widget.itemsList);
          List temppp = [];
          temppp.add(temp);

          var index = temp.indexOf(widget.items!.title);
          temppp[15] = titleController.text;
          print(temppp);
        },
        child: Text("Save", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
