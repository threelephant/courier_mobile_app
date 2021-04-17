import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../widgets/products.dart';

Future<OldOrderInfo> fetchOldOrderInfo(BuildContext context, int id) async {
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

    return OldOrderInfo.fromJson(responseJson);

  } else {
    throw Exception('Failed to load old order');
  }
}

class OldOrderInfo {
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

  OldOrderInfo({
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

  //TODO: проблема с кастом цены
  factory OldOrderInfo.fromJson(Map<String, dynamic> json) {
    return OldOrderInfo(
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

class OldOrder extends StatelessWidget {
  final int id;

  OldOrder({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Текущий заказ'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder<OldOrderInfo>(
          future: fetchOldOrderInfo(context, id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              OldOrderInfo order = snapshot.data;
              return CurrentOrderWidgetAfter(
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

class CurrentOrderWidgetAfter extends StatelessWidget {
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

  const CurrentOrderWidgetAfter({
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
              this.status,
              style: Theme.of(context).textTheme.headline4,
            )
          ),
          Text(
            this.time.replaceFirst(RegExp(r'T'), ' ').substring(0, 19),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                  "Отправитель: ${this.store}",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  "Адрес отправителя: ${this.storeAddress}",
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
        ],
      )
    );
  }
}