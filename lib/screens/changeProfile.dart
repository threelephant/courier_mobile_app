import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ChangeProfile extends StatefulWidget {
  @override
  _ChangeProfile createState() => _ChangeProfile();
}

class _ChangeProfile extends State<ChangeProfile> {
  final dateController = TextEditingController();
  Map<String, String> _changeCourier = {
    "citizenship": "Россия",
  };

  _changeCourierInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var login = prefs.getString("login");
    var token = prefs.getString("token");

    var res = await http.put(Uri.parse("http://192.168.1.4:5000/api/courier/$login"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(_changeCourier)
    );

    if (res.statusCode != 200) {
      Toast.show("Something wrong...", context);
      return;
    }
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Изменение профиля'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Гражданство",
                ),
                isExpanded: true,
                value: _changeCourier["citizenship"],
                items: <String>["Россия", "Казахстан"]
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                onChanged: (String newValue) {
                  setState(() {
                    _changeCourier["citizenship"] = newValue;
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
                    _changeCourier["number"] = val;
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

                  _changeCourier["birth"] = date.toString().substring(0, 10);
                  dateController.text = date.toString().substring(0, 10);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: (){ _changeCourierInfo(); }, 
                  child: Text("Изменить профиль"),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}