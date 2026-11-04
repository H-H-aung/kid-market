import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback? onTap;
  const ProfileTile(this.icon, this.title, this.color, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final plain = color == Colors.transparent;
    return Container(
      margin: EdgeInsets.only(bottom: plain ? 0 : 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(plain ? 0 : 15),
        border: plain
            ? const Border(bottom: BorderSide(color: Color(0xFFE8EEF5)))
            : Border.all(color: const Color(0xFFE4ECF4)),
      ),
      child: ListTile(
        dense: plain,
        contentPadding: EdgeInsets.symmetric(horizontal: plain ? 2 : 16),
        onTap: onTap,
        leading: Container(
          width: plain ? 30 : 40,
          height: plain ? 30 : 40,
          decoration: BoxDecoration(
            color: plain ? const Color(0xFFEAF5FF) : color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: plain ? 18 : 21, color: plain ? blue : ink),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      ),
    );
  }
}
