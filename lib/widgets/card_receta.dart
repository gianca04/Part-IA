import 'package:flutter/material.dart';
import 'package:part_ia/objs/recetaObj.dart'; // Importa la clase Receta desde el archivo correcto

class RecipeCardWidget extends StatelessWidget {
  final Receta receta;

  RecipeCardWidget({required this.receta}); // Constructor que recibe una receta obligatoria

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Elevación de la tarjeta para darle profundidad visual
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Bordes redondeados de la tarjeta
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)), // Bordes redondeados para la imagen
            child: AspectRatio(
              aspectRatio: 16 / 9, // Relación de aspecto de la imagen
              child: Image.network(
                receta.imagen, // URL de la imagen de la receta
                fit: BoxFit.cover, // Ajuste de la imagen para cubrir el espacio
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/fondo.jpg', // Imagen predeterminada en caso de error
                    fit: BoxFit.cover, // Ajuste de la imagen para cubrir el espacio
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 10), // Espacio entre la imagen y el texto del nombre
                Text(
                  receta.nombre, // Nombre de la receta
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Estilo del texto
                ),
                SizedBox(height: 10), // Espacio entre el nombre y la descripción
                Text(
                  receta.descripcion, // Descripción de la receta
                  maxLines: 2, // Máximo de líneas permitidas
                  overflow: TextOverflow.ellipsis, // Manejo de desbordamiento de texto
                  style: TextStyle(fontSize: 14, color: Colors.grey), // Estilo del texto
                ),
                SizedBox(height: 20), // Espacio entre la descripción y los detalles
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey), // Icono de tiempo
                        SizedBox(width: 4), // Espacio entre icono y texto
                        Text(
                          '${receta.tiempo.toInt()} min', // Tiempo de preparación de la receta
                          style: TextStyle(fontSize: 14, color: Colors.grey), // Estilo del texto
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.attach_money, size: 16, color: Colors.grey), // Icono de costo
                        SizedBox(width: 4), // Espacio entre icono y texto
                        Text(
                          '${receta.costo.toStringAsFixed(2)}', // Costo de la receta formateado
                          style: TextStyle(fontSize: 14, color: Colors.grey), // Estilo del texto
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.favorite, size: 16, color: Colors.red), // Icono de favorito
                        SizedBox(width: 4), // Espacio entre icono y texto
                        Text(
                          '${receta.likes}', // Número de likes de la receta
                          style: TextStyle(fontSize: 14, color: Colors.grey), // Estilo del texto
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
