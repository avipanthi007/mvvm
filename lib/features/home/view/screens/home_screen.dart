import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mvvm/core/local_storage/shared_pref.dart';
import 'package:mvvm/error/server_exception/server_exception.dart';
import 'package:mvvm/features/home/models/data_model.dart';
import 'package:mvvm/features/home/view/screens/add_notes.dart';
import 'package:mvvm/features/home/view/screens/update_data.dart';

class ToDoHomeScreen extends StatefulWidget {
  const ToDoHomeScreen({super.key});

  @override
  State<ToDoHomeScreen> createState() => _ToDoHomeScreenState();
}

class _ToDoHomeScreenState extends State<ToDoHomeScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  final searchController = TextEditingController();

  List<TodoModel> dataList = [];
  List<TodoModel> filteredDataList = [];
  bool isLoading = false;

  final isSearch = true.obs;

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      dataList = await LocalStorage().getData() ?? [];
      filteredDataList = dataList;
      Logger().e(filteredDataList.toString());
    } catch (e) {
      Logger().f(e.toString());
      throw ServerException().errorMessage();
    } finally {
      Future.delayed(Duration(seconds: 1)).whenComplete(() => setState(() {
            isLoading = false;
          }));
    }
  }

  searchTitle(String title) {
    if (title.isEmpty) {
      filteredDataList = dataList;
    } else {
      filteredDataList = dataList
          .where((items) => items.title.toLowerCase().contains(title))
          .toList();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: Obx(
            () => Container(
              child: isSearch.isTrue
                  ? Text("To-Do App")
                  : TextFormField(
                      controller: searchController,
                      onChanged: (val) => searchTitle(val),
                    ),
            ),
          ),
          actions: [
            Obx(
              () => IconButton(
                  onPressed: () {
                    isSearch.toggle();

                    searchTitle("");
                  },
                  icon: Icon(
                    isSearch.isTrue ? Icons.search : Icons.cancel,
                    size: 25,
                  )),
            )
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  ...List.generate(filteredDataList.length, (index) {
                    TodoModel data = filteredDataList[index];

                    return GestureDetector(
                      onTap: () {
                        Get.to(() => UpdateData(
                              itemsList: filteredDataList,
                              items: filteredDataList[index],
                            ));
                      },
                      onDoubleTap: () {
                        data.disableText = !data.disableText;
                        setState(() {});
                      },
                      child: Dismissible(
                        key: Key(data.title),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (value) {
                          setState(() {
                            filteredDataList.removeWhere(
                                (item) => item.title == data.title);
                            LocalStorage().removeData(data.title);
                          });

                          Get.snackbar("Message", "${data.title} deleted");
                        },
                        child: ListTile(
                          title: Text(
                            data.title,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                decoration: data.disableText
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
                          ),
                        ),
                      ),
                    );
                  })
                ],
              ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            onPressed: () {
              Get.to(() => AddNotes());
            },
            child: Icon(Icons.add),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
