import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  String _login = "";
  String _token = "";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString("login", "");

    _login = (prefs.getString("login") ?? "");
    _token = (prefs.getString("token") ?? "");

    if (_login == "") {
      Navigator.pushNamedAndRemoveUntil(
        context, 
        "/login", 
        ModalRoute.withName("/login")
      );
    } else {
      var courierInfo = await http.get(Uri.parse("http://192.168.1.4:5000/api/courier/$_login/work"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (courierInfo.statusCode == 403 || courierInfo.statusCode == 404) {
          Navigator.pushNamedAndRemoveUntil(
            context, 
            "/application", 
            ModalRoute.withName("/application")
          );
      } else if (courierInfo.statusCode == 200) {
        if (json.decode(courierInfo.body)["status"] == "Одобрено") {
          Navigator.pushNamedAndRemoveUntil(
            context, 
            "/orders", 
            ModalRoute.withName("/orders")
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context, 
            "/waiting-job", 
            ModalRoute.withName("/waiting-job")
          );
        }
      } else {
        Toast.show("lol", context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
