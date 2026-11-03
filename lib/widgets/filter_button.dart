import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final IconData icon;
  final String text;
  const FilterButton({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: () {},
    icon: Icon(icon, size: 17),
    label: Text(text),
  );
}
