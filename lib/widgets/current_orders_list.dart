import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/current_order_before.dart';
import '../screens/current_order_after.dart';

Future<List<CurrentOrderElement>> fetchNewOrdersElement(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString("token");

  final response = await http.get(Uri.parse("http://192.168.1.4:5000/api/courier/current"),
  headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    },
  );

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);

    return (responseJson as List)
              .map((o) => CurrentOrderElement.fromJson(o))
              .toList();
  } else {
    throw Exception('Failed to load current orders');
  }
}

class CurrentOrderElement {
  final int id;
  final String address;
  final String info;
  final bool isAfter;

  CurrentOrderElement({
    @required this.id, 
    @required this.address, 
    @required this.info,
    @required this.isAfter,
  });

  factory CurrentOrderElement.fromJson(Map<String, dynamic> json) {
    return CurrentOrderElement(
      id: json['id'],
      address: json['address'],
      info: json['info'],
      isAfter: json['is_after']
    );
  }
}

class CurrentOrdersList extends StatefulWidget {
  _CurrentOrdersList createState() => _CurrentOrdersList();
}

class _CurrentOrdersList extends State<CurrentOrdersList> {
 @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: FutureBuilder<List<CurrentOrderElement>>(
        future: fetchNewOrdersElement(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CurrentOrderElement> orders = snapshot.data;
            return Column(
              children: orders.map((o) => ListTile(
                title: Text(o.address),
                subtitle: Text(o.info),
                onTap: () {
                  if (o.isAfter) {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => CurrentOrderAfter(id: o.id)
                      )
                    );
                  } else {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => CurrentOrderBefore(id: o.id)
                      )
                    );
                  }
                }
              )).toList(),
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
        }
      ),
    );
  }
}