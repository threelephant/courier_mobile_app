import 'package:flutter/material.dart';

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
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Отчество"
            ),
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