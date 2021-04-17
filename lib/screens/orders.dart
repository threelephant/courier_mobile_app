import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/new_orders_list.dart';
import '../widgets/current_orders_list.dart';
import '../widgets/old_orders_list.dart';
import 'settings.dart';

class Orders extends StatefulWidget {
  _Orders createState() => _Orders();
}

class _Orders extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Список заказов'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings), 
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => Settings()
                  )
                );
              }
            ),
            IconButton(
              icon: Icon(Icons.logout), 
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("login", "");

                Navigator.pushNamed(context, "/");
              }
            ),
          ],
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
        body: TabBarView(
          children: <Widget>[
            NewOrdersList(),
            CurrentOrdersList(),
            OldOrdersList(),
          ]
        ),
      )
    );
  }
}