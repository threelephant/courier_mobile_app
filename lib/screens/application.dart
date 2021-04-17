import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Application extends StatefulWidget {
  @override
  _Application createState() => _Application();
}

class _Application extends State<Application> {
  final dateController = TextEditingController();
  Map<String, String> _applicationRequest = {
    "citizenship": "Россия",
  };

  _sendApplication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var login = prefs.getString("login");
    var token = prefs.getString("token");

    _applicationRequest["date_begin"] = DateTime.now().toString().substring(0, 10);

    var res = await http.post(Uri.parse("http://192.168.1.4:5000/api/courier/$login"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(_applicationRequest)
    );

    if (res.statusCode != 200) {
      Toast.show("Something wrong...", context);
      return;
    }
    
    Navigator.pushNamed(context, "/");
  }

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
              "Заявка на работу",
              style: Theme.of(context).textTheme.headline3,
            ),
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Гражданство",
                    ),
                    isExpanded: true,
                    value: _applicationRequest["citizenship"],
                    items: <String>["Россия", "Казахстан"]
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        _applicationRequest["citizenship"] = newValue;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Номер паспорта"
                    ),
                    validator: (String value) {
                      if (value.trim().isEmpty) {
                        return "Пожалуйста, введите номер паспорта";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        _applicationRequest["number"] = val;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Дата рождения"
                    ),
                    readOnly: true,
                    controller: dateController,
                    onTap: () async {
                      var date = await showDatePicker(
                        context: context, 
                        initialDate: DateTime.now(), 
                        firstDate: DateTime(1900), 
                        lastDate: DateTime(2100)
                      );

                      if (date == null) {
                        dateController.text = "";
                        return;
                      }

                      _applicationRequest["birth"] = date.toString().substring(0, 10);
                      dateController.text = date.toString().substring(0, 10);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: _sendApplication, 
                          child: Text("Подать заявку"),
                        ),
                        TextButton(
                          child: Text('Выйти'),
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString("login", "");

                            Navigator.pushNamed(context, "/");
                          },
                        )
                      ]
                    )
                  ),
                ]
              )
            )
          ],
        ),
      ),
    );
  }
}