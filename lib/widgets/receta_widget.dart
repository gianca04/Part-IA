import 'package:flutter/material.dart';

// Definición de constantes para los colores del modo claro y oscuro
Color? _colorClaroPrimario = Colors.white;
Color? _colorClaroSecundario = Colors.grey[200];
Color? _colorOscuroPrimario = Colors.grey[800];
Color? _colorOscuroSecundario = Colors.grey[400];

// Definición de la clase `Receta` para representar la información de la receta
class Receta {
  final String titulo;
  final String descripcion;
  final String imagenUrl;
  final int tiempoPreparacion;
  final Map<String, String> informacionNutricional;

  const Receta({
    required this.titulo,
    required this.descripcion,
    required this.imagenUrl,
    required this.tiempoPreparacion,
    required this.informacionNutricional,
  });
}

// Definición de la clase `RecetaWidget` para representar el widget de la receta
class RecetaWidget extends StatelessWidget {
  final Receta receta;
  final bool modoOscuro;

  const RecetaWidget({
    Key? key,
    required this.receta,
    required this.modoOscuro,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: modoOscuro ? _colorOscuroSecundario : _colorClaroSecundario,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen de la receta
          Image.network(
            receta.imagenUrl,
            height: 200.0,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16.0),

          // Título de la receta
          Text(
            receta.titulo,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: modoOscuro ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8.0),

          // Descripción de la receta
          Text(
            receta.descripcion,
            style: TextStyle(
              fontSize: 16.0,
              color: modoOscuro ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 16.0),

          // Información nutricional
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tiempo de preparación
              Row(
                children: [
                  Icon(Icons.timer, color: modoOscuro ? Colors.white70 : Colors.black54),
                  const SizedBox(width: 8.0),
                  Text(
                    '${receta.tiempoPreparacion} min',
                    style: TextStyle(
                      color: modoOscuro ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),

              // Información nutricional detallada
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Icon(Icons.info, color: modoOscuro ? Colors.white70 : Colors.black54),
                    const SizedBox(width: 8.0),
                    Text(
                      'Información nutricional',
                      style: TextStyle(
                        color: modoOscuro ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}