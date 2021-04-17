import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePassword createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  Map<String, String> _changePassword = { };

  _changeCourierInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var login = prefs.getString("login");
    var token = prefs.getString("token");

    _changePassword["username"] = login;

    var res = await http.post(Uri.parse("http://192.168.1.4:5000/api/account/reset"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(_changePassword)
    );

    if (res.statusCode != 200) {
      Toast.show("Something wrong...", context);
      return;
    }

    Toast.show("Пароль успешно заменён", context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Изменение пароля"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: "Старый пароль",
              ),
              onChanged: (String newValue) {
                setState(() {
                  _changePassword["old_password"] = newValue;
                });
              },
            ),
            TextFormField(
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: "Новый пароль",
              ),
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return "Пожалуйста, введите пароль";
                }

                if (value.length < 6) {
                  return "Введите больше 5 символов";
                }

                return null;
              },
              onChanged: (String newValue) {
                setState(() {
                  _changePassword["new_password"] = newValue;
                });
              },
            ),
            TextFormField(
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: "Повторите новый пароль",
              ),
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return "Пожалуйста, повторите новый пароль";
                }

                return null;
              },
              onChanged: (String newValue) {
                setState(() {
                  _changePassword["confirm_new_password"] = newValue;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: (){ _changeCourierInfo(); }, 
                child: Text("Изменить пароль"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}