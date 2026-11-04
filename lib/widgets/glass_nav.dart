import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jojo/constants/colors.dart';

class GlassNav extends StatelessWidget {
  final int index;
  final int cartCount;
  final ValueChanged<int> onTap;
  const GlassNav({
    super.key,
    required this.index,
    required this.cartCount,
    required this.onTap,
  });

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'Home'),
    (Icons.grid_view_outlined, Icons.grid_view_rounded, 'Explore'),
    (Icons.shopping_bag_outlined, Icons.shopping_bag_rounded, 'Cart'),
    (Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: ink.withValues(alpha: .12),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: .78),
                    const Color(0xFFE5F1FF).withValues(alpha: .55),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: .9),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: Row(
                  children: List.generate(_items.length, (i) {
                    final selected = index == i;
                    Widget icon = Icon(
                      selected ? _items[i].$2 : _items[i].$1,
                      size: 23,
                      color: selected ? blue : ink.withValues(alpha: .55),
                    );
                    if (i == 2) {
                      icon = Badge(
                        isLabelVisible: cartCount > 0,
                        label: Text('$cartCount'),
                        child: icon,
                      );
                    }
                    return Expanded(
                      child: Semantics(
                        selected: selected,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => onTap(i),
                            borderRadius: BorderRadius.circular(23),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 240),
                              curve: Curves.easeOutCubic,
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.white.withValues(alpha: .8)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(23),
                                border: Border.all(
                                  color: selected
                                      ? Colors.white
                                      : Colors.transparent,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  icon,
                                  const SizedBox(height: 4),
                                  Text(
                                    _items[i].$3,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: selected
                                          ? FontWeight.w800
                                          : FontWeight.w500,
                                      color: selected ? blue : muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
