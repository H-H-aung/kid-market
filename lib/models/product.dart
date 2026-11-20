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

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['price'] ?? json['sale_price'] ?? 0;
    final price = rawPrice is num
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice.toString()) ?? 0;
    return Product(
      (json['title'] ?? json['name'] ?? 'Untitled product').toString(),
      (json['age'] ?? json['age_group'] ?? '').toString(),
      price,
      Icons.menu_book_rounded,
      const Color(0xFFDCEEFF),
      id: (json['id'] ?? json['product_id'] ?? json['slug'] ?? '').toString(),
      categoryId: (json['category_id'] ?? json['category'] ?? '').toString(),
    );
  }
}
