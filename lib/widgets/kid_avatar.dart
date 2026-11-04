import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';

class KidAvatar extends StatelessWidget {
  final double size;
  const KidAvatar({super.key, required this.size});

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          bottom: 2,
          child: Container(
            width: size * .72,
            height: size * .38,
            decoration: BoxDecoration(
              color: blue,
              borderRadius: BorderRadius.circular(size),
            ),
          ),
        ),
        Positioned(
          top: size * .10,
          child: Container(
            width: size * .62,
            height: size * .62,
            decoration: const BoxDecoration(
              color: Color(0xFF593421),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: size * .20,
          child: Container(
            width: size * .51,
            height: size * .48,
            decoration: const BoxDecoration(
              color: Color(0xFFFFC89F),
              shape: BoxShape.circle,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _AvatarEye(size: size),
                SizedBox(width: size * .12),
                _AvatarEye(size: size),
              ],
            ),
          ),
        ),
        Positioned(
          top: size * .13,
          left: size * .21,
          child: Transform.rotate(
            angle: -.35,
            child: Container(
              width: size * .28,
              height: size * .18,
              decoration: BoxDecoration(
                color: const Color(0xFF593421),
                borderRadius: BorderRadius.circular(size),
              ),
            ),
          ),
        ),
        Positioned(
          top: size * .52,
          child: Container(
            width: size * .16,
            height: size * .06,
            decoration: BoxDecoration(
              color: const Color(0xFFE66B67),
              borderRadius: BorderRadius.circular(size),
            ),
          ),
        ),
      ],
    ),
  );
}

class _AvatarEye extends StatelessWidget {
  final double size;
  const _AvatarEye({required this.size});

  @override
  Widget build(BuildContext context) => Container(
    width: size * .055,
    height: size * .075,
    decoration: const BoxDecoration(color: ink, shape: BoxShape.circle),
  );
}
