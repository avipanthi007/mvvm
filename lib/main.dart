import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mvvm/core/local_storage/init_shared_pref.dart';
import 'package:mvvm/core/local_storage/shared_pref.dart';
import 'package:mvvm/features/home/view/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 1000),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: ToDoHomeScreen(),
    );
  }
}
