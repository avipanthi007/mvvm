import 'dart:convert';

import 'package:mvvm/core/local_storage/init_shared_pref.dart';
import 'package:mvvm/error/server_exception/server_exception.dart';
import 'package:mvvm/features/home/models/data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future saveData(TodoModel data) async {
    List<String> dataList =
        await SharedPref.preferences.getStringList("data") ?? [];
    dataList.add(jsonEncode(data));
    await SharedPref.preferences.setStringList("data", dataList);
    print(dataList);
  }

  Future<List<TodoModel>?>? getData() async {
    List<TodoModel> data = [];
    List<String> dataList =
        await SharedPref.preferences.getStringList("data") ?? [];
    if (dataList != []) {
      for (var item in dataList) {
        data.add(TodoModel.fromJson(jsonDecode(item)));
      }
    }
    return data;
  }

  removeData(String title) async {
    try {
      List<String> dataList = [];
      List<TodoModel>? data = await getData();
      data!.removeWhere((element) => element.title == title);
      for (var item in data) {
        dataList.add(jsonEncode(item));
      }
      print(dataList);
      await SharedPref.preferences.setStringList("data", dataList);
    } catch (e) {
      throw ServerException().errorMessage();
    }
  }
}
