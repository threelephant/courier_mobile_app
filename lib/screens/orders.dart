import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  _Orders createState() => _Orders();
}

class _Orders extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Список заказов'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Новые',
              ),
              Tab(
                text: 'Текущие',
              ),
              Tab(
                text: 'Старые',
              ),
            ]
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: Text('It\'s cloudy here'),
            ),
            Center(
              child: Text('It\'s rainy here'),
            ),
            Center(
              child: Text('It\'s sunny here'),
            ),
          ]
        ),
      )
    );
  }
}