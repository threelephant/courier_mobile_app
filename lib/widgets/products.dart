import 'package:flutter/material.dart';

class Product {
  final String title;
  final int count;
  final int weight;

  Product({
    @required this.title, 
    @required this.count, 
    @required this.weight
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      count: json['count'],
      weight: json['weight'],
    );
  }
}

class ProductsWidget extends StatelessWidget {
  final List<Product> products;

  const ProductsWidget({
    Key key, 
    @required this.products 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: products.map((p) => ListTile(
                    title: Text(p.title),
                    subtitle: Text("${p.weight}г, ${p.count} шт."),
                  )).toList(),
      );
  }
}