import 'package:bigpay_app003/screens/welcome.dart';
import 'package:flutter/material.dart';

class BigPayApp extends StatefulWidget {
  const BigPayApp({Key? key}) : super(key: key);

  @override
  State<BigPayApp> createState() => _BigPayAppState();
}

class _BigPayAppState extends State<BigPayApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Julia set explorer',
      theme: ThemeData(
          primaryColor: Colors.amber[300],
          primarySwatch: Colors.amber,
          textTheme: const TextTheme(
            bodyText1: TextStyle(fontSize: 18),
            bodyText2: TextStyle(fontSize: 16),
          ),
          inputDecorationTheme: InputDecorationTheme(
              isDense: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade300)))),
      home: const WelcomeScreen(),
    );
  }
}
