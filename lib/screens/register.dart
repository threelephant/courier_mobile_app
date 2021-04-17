import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "Регистрация",
                style: Theme.of(context).textTheme.headline3,
              ),
              RegisterForm(),
            ],
          ),
        )
      )
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override 
  _RegisterForm createState() => _RegisterForm();
}

class _RegisterForm extends State<RegisterForm> {
  Map<String, String> _registerInfo = { };

  _register() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var login = prefs.getString("login");
    var token = prefs.getString("token");

    _registerInfo["login"] = login;

    var res = await http.post(Uri.parse("http://192.168.1.4:5000/api/account/register"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(_registerInfo)
    );

    if (res.statusCode != 200) {
      Toast.show("Something wrong...", context);
      return;
    }

    var response = json.decode(res.body);
    
    prefs.setString("login", response["username"]);
    prefs.setString("token", response["token"]);

    Navigator.pushNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return Form(
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Фамилия"
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return "Пожалуйста, введите свою фамилию";
              }
              return null;
            },
            onChanged: (String newValue) {
              setState(() {
                _registerInfo["last_name"] = newValue;
              });
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Имя"
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return "Пожалуйста, введите своё имя";
              }
              return null;
            },
            onChanged: (String newValue) {
              setState(() {
                _registerInfo["first_name"] = newValue;
              });
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Отчество"
            ),
            onChanged: (String newValue) {
              setState(() {
                _registerInfo["middle_name"] = newValue;
              });
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Телефон"
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return "Пожалуйста, введите свой телефон";
              }
              return null;
            },
            onChanged: (String newValue) {
              setState(() {
                _registerInfo["phone"] = newValue;
              });
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Логин"
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return "Пожалуйста, введите свой логин";
              }
              return null;
            },
            onChanged: (String newValue) {
              setState(() {
                _registerInfo["username"] = newValue;
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

              if (value.length < 6) {
                return "Введите больше 5 символов";
              }

              return null;
            },
            onChanged: (String newValue) {
              setState(() {
                _registerInfo["password"] = newValue;
              });
            },
          ),
          TextFormField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: "Повторите пароль",
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return "Пожалуйста, повторите пароль";
              }

              return null;
            },
            onChanged: (String newValue) {
              setState(() {
                _registerInfo["confirmPassword"] = newValue;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  child: Text(
                    "Регистрация",
                    ), 
                  onPressed: () {
                    _register();
                  },
                ),
                TextButton(
                  child: Text(
                    "Есть аккаунт",
                    ), 
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ]
            )
          ),
        ]
      )
    );
  }
}