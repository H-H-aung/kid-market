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
    (Icons.person_outline, Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              height: 62,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .88),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withValues(alpha: .8)),
                boxShadow: [
                  BoxShadow(
                    color: ink.withValues(alpha: .12),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(_items.length, (i) {
                  final selected = index == i;
                  Widget icon = AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: Icon(
                      selected ? _items[i].$2 : _items[i].$1,
                      key: ValueKey(selected),
                      size: 21,
                      color: selected ? Colors.white : muted,
                    ),
                  );

                  if (i == 2) {
                    icon = Badge(
                      isLabelVisible: cartCount > 0,
                      label: Text('$cartCount', style: const TextStyle(fontSize: 9)),
                      child: icon,
                    );
                  }

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTap(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 7,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: selected
                              ? blue.withValues(alpha: .13)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: selected ? blue : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: icon,
                            ),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 240),
                              opacity: selected ? 1 : .72,
                              child: Text(
                                _items[i].$3,
                                maxLines: 1,
                                style: TextStyle(
                                  color: selected ? blue : muted,
                                  fontSize: 10,
                                  fontWeight: selected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
