import 'package:flutter/material.dart';

class Product {
  final String id;
  final String categoryId;
  final String title;
  final String age;
  final double price;
  final IconData icon;
  final Color color;
  final String description;
  final String? imageUrl;

  const Product(
    this.title,
    this.age,
    this.price,
    this.icon,
    this.color, {
    String? id,
    this.categoryId = '',
    this.description = '',
    this.imageUrl,
  }) : id = id ?? title;
}
