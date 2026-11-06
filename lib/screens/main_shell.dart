import 'package:flutter/material.dart';
import 'package:kids_mart/models/product.dart';
import 'package:kids_mart/screens/cart_screen.dart';
import 'package:kids_mart/screens/explore_screen.dart';
import 'package:kids_mart/screens/home_screen.dart';
import 'package:kids_mart/screens/profile_screen.dart';
import 'package:kids_mart/widgets/glass_nav.dart';
import 'package:kids_mart/data/app_store.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  void _addToCart(Product product) {
    saveAction(
      context,
      () => AppScope.of(context).addToCart(product),
      success: '${product.title} added to cart',
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onAdd: _addToCart),
      ExploreScreen(onAdd: _addToCart),
      CartScreen(onContinueShopping: () => setState(() => index = 0)),
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
        cartCount: AppScope.of(context).cartCount,
        onTap: (value) => setState(() => index = value),
      ),
    );
  }
}
