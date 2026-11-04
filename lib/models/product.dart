import 'package:flutter/material.dart';

class Product {
  final String categoryId;
  final String title;
  final String age;
  final double price;
  final IconData icon;
  final Color color;

  const Product(
    this.title,
    this.age,
    this.price,
    this.icon,
    this.color, {
    this.categoryId = '',
  });
}
