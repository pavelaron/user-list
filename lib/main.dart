import 'package:flutter/material.dart';
import 'package:user_list/screens/home.dart';
import 'package:user_list/screens/user_info.dart';

void main() {
  runApp(const UserListApp());
}

class UserListApp extends StatelessWidget {
  const UserListApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const UserListHome(),
      routes: {
        '/user_info': (context) => const UserInfo(),
      },
    );
  }
}
