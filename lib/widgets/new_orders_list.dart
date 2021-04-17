import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/new_order.dart';

Future<List<NewOrderElement>> fetchNewOrdersElement(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString("token");

  final response = await http.get(Uri.parse("http://192.168.1.4:5000/api/courier/locality/Томск"),
  headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    },
  );

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);

    return (responseJson as List)
              .map((o) => NewOrderElement.fromJson(o))
              .toList();
  } else {
    throw Exception('Failed to load new orders');
  }
}

class NewOrderElement {
  final int id;
  final String title;
  final String address;

  NewOrderElement({
    @required this.id, 
    @required this.title, 
    @required this.address
  });

  factory NewOrderElement.fromJson(Map<String, dynamic> json) {
    return NewOrderElement(
      id: json['id'],
      title: json['store']['title'],
      address: "${json['store']['address']['street']}, ${json['store']['address']['building_number']}",
    );
  }
}

class NewOrdersList extends StatefulWidget {
  _NewOrdersList createState() => _NewOrdersList();
}

class _NewOrdersList extends State<NewOrdersList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: FutureBuilder<List<NewOrderElement>>(
        future: fetchNewOrdersElement(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<NewOrderElement> orders = snapshot.data;
            return Column(
              children: orders.map((o) => ListTile(
                title: Text(o.address),
                subtitle: Text(o.title),
                onTap: () { 
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => NewOrder(id: o.id)
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