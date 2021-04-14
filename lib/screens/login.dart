import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:toast/toast.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Войти",
              style: Theme.of(context).textTheme.headline3,
            ),
            LoginForm(),
            Center(
              child: TextButton(
                child: Text("Нет аккаунта"), 
                onPressed: () {
                  Navigator.pushNamed(context, "/register");
                },
              )
            ),            
          ],
        )
      )
    );
  }
}

class LoginForm extends StatefulWidget {
  @override 
  _LoginForm createState() => _LoginForm();
}

class _LoginForm extends State<LoginForm> {
  Map<String, String> _user = {};

  _login() async {
    Toast.show(_user["username"], context);

    var res = await http.post(Uri.parse("http://192.168.1.4:5000/api/account/login"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(_user)
    );

    if (res.statusCode != 200) {
      Toast.show("Something wrong...", context);
      return;
    }

    var response = json.decode(res.body);

    Toast.show(response["username"], context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Логин"
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return "Пожалуйста, введите логин";
              }
              return null;
            },
            onChanged: (val) {
              setState(() {
                _user["username"] = val;
              });
            },
          ),
          TextFormField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: "Пароль",
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return "Пожалуйста, введите пароль";
              }
              return null;
            },
            onChanged: (val) {
              setState(() {
                _user["password"] = val;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              child: Text(
                "Войти",
                ), 
              onPressed: () {
                _login();
              },
            ),
          ),
        ],
      )
    );
  }
}