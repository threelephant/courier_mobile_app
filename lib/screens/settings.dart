import 'dart:convert';
import 'package:courier_mobile_app/screens/changePassword.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../style/cancel_button.dart';
import 'changeProfile.dart';

Future<Courier> fetchCourierInfo(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _login = prefs.getString("login");
  var _token = prefs.getString("token");

  final response = await http.get(Uri.parse("http://192.168.1.4:5000/api/courier/$_login"),
  headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    },
  );

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);

    return Courier.fromJson(responseJson, _login);
  } else {
    throw Exception('Failed to load courier info');
  }
}

class Courier {
  final String login;
  final String firstName;
  final String phone;
  final int successOrderCount;
  final String birth;
  final String payroll;

  Courier({
    @required this.login, 
    @required this.firstName, 
    @required this.phone,
    @required this.successOrderCount,
    @required this.birth,
    @required this.payroll,
  });

  factory Courier.fromJson(Map<String, dynamic> json, String login) {
    return Courier(
      login: login,
      firstName: json['first_name'],
      phone: json['phone'],
      successOrderCount: json['success_order_count'],
      birth: json['passport']['birth'],
      payroll: json['payroll'],
    );
  }
}

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки профиля'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder<Courier>(
          future: fetchCourierInfo(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var courier = snapshot.data;
              return CourierInfoWidget(
                birth: courier.birth,
                firstName: courier.firstName,
                login: courier.login,
                payroll: courier.payroll,
                phone: courier.phone,
                successOrderCount: courier.successOrderCount,
              );
            } else if (snapshot.hasError) {
              return snapshot.error;
            }

            return new Center(
              child: new Column(
                children: <Widget>[
                  new Padding(padding: new EdgeInsets.all(50.0)),
                  new CircularProgressIndicator(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class CourierInfoWidget extends StatelessWidget {
  final String login;
  final String firstName;
  final String phone;
  final int successOrderCount;
  final String birth;
  final String payroll;

  const CourierInfoWidget({
    Key key, 
    @required this.login, 
    @required this.firstName, 
    @required this.phone,
    @required this.successOrderCount,
    @required this.birth,
    @required this.payroll,
  }) : super(key: key);

  _quitCourier(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var login = prefs.getString("login");
    var token = prefs.getString("token");

    var res = await http.delete(Uri.parse("http://192.168.1.4:5000/api/courier/$login"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      Toast.show("Something wrong...", context);
      return;
    }

    prefs.clear();
    Navigator.pushNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              this.firstName,
              style: Theme.of(context).textTheme.headline4,
            )
          ),
          Text(
            "Ваш счёт: ${this.payroll} р.",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            "Логин: ${this.login}",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            title: Text(this.phone),
            subtitle: Text("Телефон"),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            title: Text(this.birth.replaceFirst(RegExp(r'T'), ' ').substring(0, 10)),
            subtitle: Text("Дата рождения"),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            title: Text(this.successOrderCount.toString()),
            subtitle: Text("Количество успешных заказов"),
          ),
          ElevatedButton(
            onPressed: (){ 
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => ChangeProfile()
                )
              );
            }, 
            child: Text('Изменить профиль')
          ),
          ElevatedButton(
            onPressed: (){ 
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => ChangePassword()
                )
              );
            }, 
            child: Text('Изменить пароль')
          ),
          ElevatedButton(
            onPressed: (){ _quitCourier(context); }, 
            child: Text('Уволиться'),
            style: cancelButtonStyle,
          ),
        ],
      )
    );
  }
}