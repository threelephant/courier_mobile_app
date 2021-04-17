import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

Future<NewOrderInfo> fetchNewOrderInfo(BuildContext context, int id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString("token");

  final response = await http.get(Uri.parse("http://192.168.1.4:5000/api/courier/new/$id"),
  headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    },
  );

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);

    return NewOrderInfo.fromJson(responseJson);

  } else {
    throw Exception('Failed to load new orders');
  }
}

class NewOrderInfo {
  final int id;
  final String title;
  final String address;
  final int weight;

  NewOrderInfo({
    @required this.id, 
    @required this.title, 
    @required this.address,
    @required this.weight,
  });

  factory NewOrderInfo.fromJson(Map<String, dynamic> json) {
    return NewOrderInfo(
      id: json['id'],
      title: json['title'],
      address: json['address'],
      weight: json['weight'],
    );
  }
}

class NewOrder extends StatelessWidget {
  final int id;

  NewOrder({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Новый заказ'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder<NewOrderInfo>(
          future: fetchNewOrderInfo(context, id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              NewOrderInfo order = snapshot.data;
              return NewOrderWidget(
                id: order.id,
                title: order.title,
                address: order.address,
                weight: order.weight,
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

class NewOrderWidget extends StatelessWidget {
  final int id;
  final String title;
  final String address;
  final int weight;

  const NewOrderWidget({
    Key key, 
    @required this.id, 
    @required this.title, 
    @required this.address, 
    @required this.weight,
  }) : super(key: key);

  _acceptOrder(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    var res = await http.post(Uri.parse("http://192.168.1.4:5000/api/courier/order/$id/accept"),
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

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text(
            this.address,
            style: Theme.of(context).textTheme.headline4,
          )
        ),
        Text(
          this.title,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Text(
            "${this.weight} г",
            style: Theme.of(context).textTheme.bodyText1,
          )
        ),
        ElevatedButton(
          onPressed: () { _acceptOrder(context); }, 
          child: Text('Принять заказ')
        ),
      ],
    );
  }
}