import 'package:flutter/material.dart';
import 'HomePage.dart';

void main() {
  runApp(const TrainApp());
}

class TrainApp extends StatelessWidget {
  const TrainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_train_app',
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
      ),
      themeMode: ThemeMode.dark, // 항상 다크테마 적용
      home: const HomePage(),
    );
  }
}
