import 'package:flutter/material.dart';

class FilterPanel extends StatelessWidget {
  final Function(String)? onSearch;
  final Function(String)? onFilterByIngredients;
  final Function(String)? onFilterByTime;
  final Function(double)? onFilterByCost;
  final Function(String)? onFilterByPlato;
  final Function(String)? onFilterByNivel;

  FilterPanel({
    this.onSearch,
    this.onFilterByIngredients,
    this.onFilterByTime,
    this.onFilterByCost,
    this.onFilterByPlato,
    this.onFilterByNivel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Filtros',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar por nombre',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // Implementar búsqueda por nombre
                  // Llamar a la función onSearch pasando el texto del TextField
                  if (onSearch != null) {
                    onSearch!('Texto del TextField');
                  }
                },
              ),
            ),
          ),
        ),
        // Aquí puedes agregar más widgets para los filtros de ingredientes, tiempo, costo, plato y nivel
        // Por ejemplo:
        ListTile(
          title: Text('Filtrar por ingredientes'),
          onTap: () {
            // Implementar filtro por ingredientes
            // Llamar a la función onFilterByIngredients pasando el nombre del ingrediente
            if (onFilterByIngredients != null) {
              onFilterByIngredients!('Nombre del ingrediente');
            }
          },
        ),
        // Agrega más ListTile para los otros filtros
      ],
    );
  }
}
