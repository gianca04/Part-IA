import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GreetingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtenemos la hora actual en la zona horaria de Lima, Perú
    var now = DateTime.now().toUtc().subtract(Duration(hours: 5));
    var hour = now.hour;

    // Determinamos el mensaje y el emoji basado en la hora del día
    String greeting;
    IconData emoji;

    if (hour >= 6 && hour < 12) {
      greeting = '¡Buenos días!';
      emoji = Icons.wb_sunny_outlined;
    } else if (hour >= 12 && hour < 18) {
      greeting = '¡Buenas tardes!';
      emoji = Icons.wb_cloudy_outlined;
    } else {
      greeting = '¡Buenas noches!';
      emoji = Icons.nightlight_round;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(emoji, size: 24, color: Colors.amber), // Emoji
        SizedBox(width: 8),
        Text(
          greeting,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
