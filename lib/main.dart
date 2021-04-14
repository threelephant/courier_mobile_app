import 'package:flutter/material.dart';
import 'landing.dart';
import 'screens/login.dart';
import 'screens/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Courier App',
      routes: {
        '/': (context) => Landing(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/application': (context) => throw Exception('asd'),
        '/waiting-job': (context) => throw Exception('asd'),
        '/orders': (context) => throw Exception('asd'),
        '/new-order': (context) => throw Exception('asd'),
        '/current-order': (context) => throw Exception('asd'),
        '/old-order': (context) => throw Exception('asd'),
        '/profile': (context) => throw Exception('asd'),
        '/change-profile': (context) => throw Exception('asd'),
        '/change-password': (context) => throw Exception('asd'),
      },
      theme: ThemeData(primarySwatch: Colors.deepPurple),
    );
  }
}
