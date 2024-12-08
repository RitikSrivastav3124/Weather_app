import "package:flutter/material.dart";

class HourlyForecast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;
  const HourlyForecast(
      {super.key,
      required this.time,
      required this.icon,
      required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        width: 115,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              temperature,
              style: const TextStyle(
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
