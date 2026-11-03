import 'package:flutter/material.dart';
import 'package:jojo/constants/colors.dart';
import 'package:jojo/widgets/brand_logo.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
    child: Row(
      children: [
        BrandLogo(),
        Spacer(),
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.notifications_none_rounded, color: ink),
        ),
      ],
    ),
  );
}
