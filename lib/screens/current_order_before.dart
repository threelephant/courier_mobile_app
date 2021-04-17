import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import '../style/cancel_button.dart';
import '../widgets/products.dart';

Future<CurrentOrderBeforeInfo> fetchCurrentOrderBeforeInfo(BuildContext context, int id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _token = prefs.getString("token");

  final response = await http.get(Uri.parse("http://192.168.1.4:5000/api/courier/current/$id"),
  headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    },
  );

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);

    return CurrentOrderBeforeInfo.fromJson(responseJson);

  } else {
    throw Exception('Failed to load current order');
  }
}

class CurrentOrderBeforeInfo {
  final int id;
  final String time;
  final String status;
  final double price;
  final int weight;
  final String customer;
  final String customerAddress;
  final String store;
  final String storeAddress;
  final List<Product> products;

  CurrentOrderBeforeInfo({
    @required this.id, 
    @required this.time, 
    @required this.status,
    @required this.price,
    @required this.weight,
    @required this.customer,
    @required this.customerAddress,
    @required this.store,
    @required this.storeAddress,
    @required this.products,
  });

  factory CurrentOrderBeforeInfo.fromJson(Map<String, dynamic> json) {
    return CurrentOrderBeforeInfo(
      id: json['id'],
      time: json['time'],
      status: json['status'],
      price: json['price'],
      weight: json['weight'],
      customer: json['customer'],
      customerAddress: json['customer_address'],
      store: json['store'],
      storeAddress: json['store_address'],
      products: (json['products'] as List)
                  .map((p) => Product.fromJson(p))
                  .toList() 
    );
  }
}

class CurrentOrderBefore extends StatelessWidget {
  final int id;

  CurrentOrderBefore({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Текущий заказ'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder<CurrentOrderBeforeInfo>(
          future: fetchCurrentOrderBeforeInfo(context, id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              CurrentOrderBeforeInfo order = snapshot.data;
              return CurrentOrderWidgetBefore(
                id: order.id,
                time: order.time,
                status: order.status,
                price: order.price,
                weight: order.weight,
                customer: order.customer,
                customerAddress: order.customerAddress,
                store: order.store,
                storeAddress: order.storeAddress,
                products: order.products,
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

class CurrentOrderWidgetBefore extends StatelessWidget {
  final int id;
  final String time;
  final String status;
  final double price;
  final int weight;
  final String customer;
  final String customerAddress;
  final String store;
  final String storeAddress;
  final List<Product> products;

  const CurrentOrderWidgetBefore({
    Key key, 
    @required this.id,
    @required this.time, 
    @required this.status, 
    @required this.price, 
    @required this.weight, 
    @required this.customer, 
    @required this.customerAddress, 
    @required this.store, 
    @required this.storeAddress, 
    @required this.products 
  }) : super(key: key);

  _acceptOrder(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    var res = await http.post(Uri.parse("http://192.168.1.4:5000/api/courier/order/$id/take"),
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

  _denyOrder(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    var res = await http.post(Uri.parse("http://192.168.1.4:5000/api/courier/order/$id/deny"),
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              this.storeAddress,
              style: Theme.of(context).textTheme.headline4,
            )
          ),
          Text(
            this.store,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Время взятия заказа: ${this.time.replaceFirst(RegExp(r'T'), ' ')}",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  "Цена заказа: ${this.price} р.",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  "Вес заказа: ${this.weight} г",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Получатель: ${this.customer}",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  "Адрес получателя: ${this.customerAddress}",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          Text(
            "Список продуктов",
            style: Theme.of(context).textTheme.headline5,
          ),
          ProductsWidget(
            products: this.products,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton(
                onPressed: (){ _acceptOrder(context); }, 
                child: Text('Заказ взят')
              ),
              ElevatedButton(
                onPressed: (){ _denyOrder(context); }, 
                child: Text('Отменить'),
                style: cancelButtonStyle,
              ),
            ]
          ),
        ],
      )
    );
  }
}