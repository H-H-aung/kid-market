import 'package:flutter/material.dart';
import 'package:jojo/models/product.dart';
import 'package:jojo/screens/cart_screen.dart';
import 'package:jojo/screens/explore_screen.dart';
import 'package:jojo/screens/home_screen.dart';
import 'package:jojo/screens/profile_screen.dart';
import 'package:jojo/widgets/glass_nav.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;
  final cart = <Product>[];

  void _addToCart(Product product) {
    setState(() => cart.add(product));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('${product.title} added to cart')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onAdd: _addToCart),
      ExploreScreen(onAdd: _addToCart),
      CartScreen(
        items: cart,
        onRemove: (i) => setState(() => cart.removeAt(i)),
        onContinueShopping: () => setState(() => index = 0),
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: index, children: pages),
      ),
      bottomNavigationBar: GlassNav(
        index: index,
        cartCount: cart.length,
        onTap: (value) => setState(() => index = value),
      ),
    );
  }
}
