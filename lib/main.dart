import 'package:awsweb/view/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AwsApp());
}

class AwsApp extends StatelessWidget {
  const AwsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AWS Quiz',
      home: AwsHomeView(),
    );
  }
}

