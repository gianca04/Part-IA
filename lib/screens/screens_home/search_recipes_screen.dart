import 'package:flutter/material.dart';
import 'package:part_ia/services/receta_service.dart';
import 'package:part_ia/objs/recetaObj.dart'; // Asegúrate de importar correctamente tu clase Receta
import 'package:part_ia/screens/screens_home/receta_full_screen.dart';
import 'package:part_ia/widgets/card_receta.dart';
import 'package:part_ia/widgets/greetingwidget.dart';
import 'package:provider/provider.dart';

import '../../providers/Usuario_provider.dart';

class SearchRecipesScreen extends StatefulWidget {
  @override
  _SearchRecipesScreenState createState() => _SearchRecipesScreenState();
}

class _SearchRecipesScreenState extends State<SearchRecipesScreen> {
  final RecetaService _recetaService = RecetaService();
  late Stream<List<Receta>> _recetasStream;

  @override
  void initState() {
    super.initState();
    // Inicializa el stream con todas las recetas ordenadas por likes
    _recetasStream = _recetaService.getRecetas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Row(
          children: [
            GreetingWidget(),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                // Actualiza el stream de recetas al cambiar el texto de búsqueda
                setState(() {
                  _recetasStream = _recetaService.buscarRecetas(value);
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar recetas...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Receta>>(
              stream: _recetasStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No se encontraron recetas'));
                }
                // Lista las recetas en tarjetas
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Receta receta = snapshot.data![index];
                    return InkWell(
                      onTap: () {
                        // Navega a la pantalla de detalle al hacer tap en la tarjeta
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(receta: receta),
                          ),
                        );
                      },

                      child: RecipeCardWidget(receta: receta,),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
