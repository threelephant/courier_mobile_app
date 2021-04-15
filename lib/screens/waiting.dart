import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Waiting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text('Ожидайте ответа на вашу заявку'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pushNamed(context, "/");
              }, 
              child: Text('Обновить'),
            ),
            TextButton(
              child: Text('Выйти из аккаунта'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("login", "");

                Navigator.pushNamed(context, "/");
              },
            )
          ]
        )
      )
    );
  }
}