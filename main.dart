import 'package:dog_exaple/home.dart';
import 'package:flutter/material.dart';

void main() async{
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sqflite DB',

      home: Home(),
    );
  }
}