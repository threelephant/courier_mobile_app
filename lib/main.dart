import 'package:flutter/material.dart';
import 'landing.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/application.dart';
import 'screens/waiting.dart';
import 'screens/orders.dart';

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
        '/application': (context) => Application(),
        '/waiting-job': (context) => Waiting(),
        '/orders': (context) => Orders(),
        '/new-order': (context) => throw Exception('new-order'),
        '/current-order': (context) => throw Exception('current-order'),
        '/old-order': (context) => throw Exception('old-order'),
        '/profile': (context) => throw Exception('profile'),
        '/change-profile': (context) => throw Exception('change-profile'),
        '/change-password': (context) => throw Exception('change-password'),
      },
      theme: ThemeData(primarySwatch: Colors.deepPurple),
    );
  }
}
