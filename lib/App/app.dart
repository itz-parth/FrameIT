import 'package:flutter/material.dart';
import 'package:my_app/Views/home_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Demo App",
      home:  HomeView()
    );
  }
}