import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  String _login = "";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _login = (prefs.getString("login") ?? "");

    if (_login == "") {
      Navigator.pushNamedAndRemoveUntil(
        context, 
        "/login", 
        ModalRoute.withName("/login")
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context, 
        "/orders", 
        ModalRoute.withName("/orders")
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
