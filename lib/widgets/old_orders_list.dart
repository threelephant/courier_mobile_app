import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/old_order.dart';

Future<List<OldOrderElement>> fetchNewOrdersElement(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString("token");

  final response = await http.get(Uri.parse("http://192.168.1.4:5000/api/courier/old"),
  headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    },
  );

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);

    return (responseJson as List)
              .map((o) => OldOrderElement.fromJson(o))
              .toList();
  } else {
    throw Exception('Failed to load current orders');
  }
}

class OldOrderElement {
  final int id;
  final String info;
  final String status;

  OldOrderElement({
    @required this.id, 
    @required this.status, 
    @required this.info
  });

  factory OldOrderElement.fromJson(Map<String, dynamic> json) {
    return OldOrderElement(
      id: json['id'],
      status: json['status'],
      info: json['info'],
    );
  }
}

class OldOrdersList extends StatefulWidget {
  _OldOrdersList createState() => _OldOrdersList();
}

class _OldOrdersList extends State<OldOrdersList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: FutureBuilder<List<OldOrderElement>>(
        future: fetchNewOrdersElement(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<OldOrderElement> orders = snapshot.data;
            return Column(
              children: orders.map((o) => ListTile(
                title: Text(o.info),
                subtitle: Text(o.status),
                onTap: () { 
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => OldOrder(id: o.id)
                    )
                  );
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