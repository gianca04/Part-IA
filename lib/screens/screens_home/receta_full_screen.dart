import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa el paquete de Firebase Firestore
import 'package:part_ia/objs/recetaObj.dart';
import 'package:url_launcher/url_launcher.dart'; // Asegúrate de importar correctamente tu clase Receta

class RecipeDetailScreen extends StatelessWidget {
  final Receta receta;

  RecipeDetailScreen({required this.receta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ficha de Receta: "),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildRecipeImage(receta.imagen),
            SizedBox(height: 4),
            _builNombreReceta(receta.nombre),
            _buildSection('Descripción', _buildTextContent(receta.descripcion)),
            _buildSection('Ingredientes', _buildIngredientsList(receta.ingredientes)),
            _buildSection('Pasos', _buildStepsList(receta.pasos)),
            _buildSection('Detalles de la receta', _buildRecipeDetails()),
            _buildVideoButton(context, receta.video),
          ],
        ),
      ),
      floatingActionButton: _buildLikeButton(context),
    );
  }

  Widget _buildRecipeImage(String imageUrl) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _builNombreReceta(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildTextContent(String content) {
    return Text(
      content,
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildIngredientsList(List<Ingrediente> ingredientes) {
    return Column(
      children: ingredientes.map((ingrediente) {
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.restaurant_menu, color: Colors.orange),
                    SizedBox(width: 10),
                    Text(
                      ingrediente.nombre,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Text(
                  ingrediente.cantidad.toString(),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStepsList(List<String> pasos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: pasos.asMap().entries.map((entry) {
        int index = entry.key + 1;
        String paso = entry.value;
        return ListTile(
          contentPadding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          leading: CircleAvatar(
            child: Text('$index'),
          ),
          title: Text(paso),
        );
      }).toList(),
    );
  }

  Widget _buildRecipeDetails() {
    return Column(
        children: [
        _buildDetailRow(Icons.access_time, 'Tiempo de preparación', '${receta.tiempo.toInt()} min'),
    _buildDetailRow(Icons.attach_money, 'Costo', '\$${receta.costo.toStringAsFixed(2)}'),
    _buildDetailRow(Icons.local_fire_department, 'Calorías', '${receta.calorias.toInt()} kcal'),
    _buildDetailRow(Icons.fitness_center, 'Proteínas', '${receta.proteinas.toInt()} g'),
    _buildDetailRow(Icons.fastfood, 'Grasas', '${receta.grasas.toInt()} g'),
    _buildDetailRow(Icons.grain, 'Carbohidratos', '${receta.carbohidratos.toInt()} g'),
    _buildDetailRow(Icons.restaurant, 'Plato', receta.plato),
    _buildDetailRow(Icons.leaderboard, 'Dificultad', receta.dificultad),
    ],
    );
    }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          SizedBox(width: 10),
          Text(
            '$title: ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoButton(BuildContext context, String videoLink) {
    return Container(
      padding: EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: () async {
          String url = videoLink.trim(); // Asegúrate de que la URL no tenga espacios innecesarios
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No se pudo abrir el link: $url')),
            );
          }
        },
        icon: Icon(Icons.play_arrow),
        label: Text('Ver Video'),
      ),
    );
  }



  Future<void> _launchURL(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el link: $url')),
      );
    }
  }

  Widget _buildLikeButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: FloatingActionButton.extended(
        onPressed: () async {
          try {
            DocumentReference recetaRef = FirebaseFirestore.instance.collection('recetas').doc(receta.recetaId);
            DocumentSnapshot snapshot = await recetaRef.get();

            if (snapshot.exists) {
              int currentLikes = snapshot['likes'] ?? 0;
              await recetaRef.update({'likes': currentLikes + 1});
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('¡Te ha gustado esta receta!')));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('La receta no existe.')));
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al dar like: $e')));
          }
        },
        icon: Icon(Icons.favorite_border),
        label: Text('Me gusta'),
      ),
    );
  }
}
