import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:part_ia/objs/recetajson.dart'; // Asegúrate de importar el archivo correcto

class RecetaWidget extends StatelessWidget {
  final Receta receta;

  RecetaWidget({required this.receta});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildRecipeImage(receta.imagen),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 12.0),
                Text(
                  receta.nombreReceta,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  receta.descripcion,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16.0),
                _buildSectionWithIcon("Valor Nutricional", Icons.local_dining, _buildNutritionalValue(receta.valorNutricional)),
                SizedBox(height: 16.0),
                _buildSection("Pasos", _buildStepsList(receta.seriePasos)),
                SizedBox(height: 16.0),
                _buildVideoLink(receta.linkVideo),
                SizedBox(height: 16.0),
                _buildSectionWithIcon("Costo estimado", Icons.attach_money, Text(
                  "S/ ${receta.costoEstimado}",
                  style: TextStyle(fontSize: 16),
                )),
                SizedBox(height: 16.0),
                _buildSectionWithIcon("Recuerda", Icons.comment, Text(
                  receta.comentario,
                  style: TextStyle(fontSize: 16),
                )),
                SizedBox(height: 12.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeImage(String imageUrl) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: imageUrl.isNotEmpty
            ? Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/fondo.jpg', // Imagen de reemplazo local en caso de error
              fit: BoxFit.cover,
            );
          },
        )
            : Image.asset(
          'assets/images/fondo.jpg', // Imagen de reemplazo local si la URL es vacía
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildSectionWithIcon(String title, IconData iconData, Widget content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          iconData,
          size: 20,
          color: Colors.blue,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              content,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionalValue(List<String> valores) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: valores.map((valor) => Text(valor)).toList(),
    );
  }

  Widget _buildStepsList(List<String> pasos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: pasos.asMap().entries.map((entry) {
        int index = entry.key + 1;
        String paso = entry.value;
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            child: Text('$index'),
          ),
          title: Text(paso),
        );
      }).toList(),
    );
  }

  Widget _buildVideoLink(String linkVideo) {
    return linkVideo.isNotEmpty
        ? TextButton(
      onPressed: () => _launchURL(linkVideo),
      child: Text(
        "Ver video",
        style: TextStyle(color: Colors.blue),
      ),
    )
        : SizedBox.shrink();
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('No se pudo lanzar la URL: $url');
    }
  }
}
