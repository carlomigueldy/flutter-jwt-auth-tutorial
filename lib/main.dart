import 'package:flutter/material.dart';
import 'package:jwt_auth_tut/app/locator.dart';
import 'package:jwt_auth_tut/ui/views/home/home_view.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JWT Auth',
      home: HomeView(),
    );
  }
}
