import 'package:flutter/material.dart';
import 'package:jojo/constants/colors.dart';

class OrderCard extends StatelessWidget {
  final String id;
  final String status;
  final double progress;
  final Color color;
  const OrderCard(this.id, this.status, this.progress, this.color, {super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE4ECF4)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: const Icon(Icons.inventory_2_outlined),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #$id',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    status,
                    style: const TextStyle(fontSize: 11, color: muted),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
        const SizedBox(height: 13),
        LinearProgressIndicator(
          value: progress,
          minHeight: 7,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    ),
  );
}
