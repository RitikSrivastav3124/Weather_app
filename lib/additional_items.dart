import "package:flutter/material.dart";

class Additionalltems extends StatelessWidget {
  final IconData icon;
  final String condition;
  final String value;
  const Additionalltems(
      {super.key,
      required this.icon,
      required this.condition,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 39,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          condition,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
