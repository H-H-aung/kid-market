import 'package:flutter/material.dart';
import 'package:jojo/constants/colors.dart';

class KidArt extends StatelessWidget {
  final double size;
  const KidArt({super.key, required this.size});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size * .74,
          height: size * .74,
          decoration: const BoxDecoration(
            color: Color(0xFFFFE5C7),
            shape: BoxShape.circle,
          ),
        ),
        Positioned(
          top: size * .17,
          child: Icon(
            Icons.face_rounded,
            size: size * .42,
            color: const Color(0xFF25364C),
          ),
        ),
        Positioned(
          bottom: size * .12,
          left: size * .10,
          child: Transform.rotate(
            angle: -.12,
            child: Container(
              width: size * .43,
              height: size * .34,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD166),
                borderRadius: BorderRadius.circular(size * .07),
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Icon(
                Icons.menu_book_rounded,
                color: blue,
                size: size * .23,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: size * .12,
          right: size * .10,
          child: Transform.rotate(
            angle: .12,
            child: Container(
              width: size * .43,
              height: size * .34,
              decoration: BoxDecoration(
                color: const Color(0xFFFF8DA1),
                borderRadius: BorderRadius.circular(size * .07),
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Icon(
                Icons.auto_stories_rounded,
                color: Colors.white,
                size: size * .22,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: size * .14,
          child: Icon(
            Icons.star_rounded,
            color: const Color(0xFFFFB703),
            size: size * .16,
          ),
        ),
        Positioned(
          right: 0,
          top: size * .27,
          child: Icon(
            Icons.auto_awesome_rounded,
            color: const Color(0xFF4ED4B6),
            size: size * .14,
          ),
        ),
      ],
    ),
  );
}
