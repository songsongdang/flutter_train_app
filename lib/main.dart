import 'package:flutter/material.dart';
import 'package:flutter_train_app/HomePage.dart';

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
        // 필요시 추가 커스터마이징
      ),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}
