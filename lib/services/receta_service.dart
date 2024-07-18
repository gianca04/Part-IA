import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:part_ia/objs/recetaObj.dart'; // Asegúrate de importar correctamente tu clase Receta

/// Clase que maneja la interacción con Firebase para la colección de recetas.
class RecetaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obtener todas las recetas ordenadas por likes
  Stream<List<Receta>> getRecetas() {
    return _firestore
        .collection('recetas')
        .orderBy('likes', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      return _convertirQuerySnapshot(query);
    });
  }

  // Método para obtener recetas filtradas por tipo de plato
  Stream<List<Receta>> getRecetasPorCategoria(String categoria) {
    return _firestore
        .collection('recetas')
        .where('plato', isEqualTo: categoria)
        .orderBy('likes', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      return _convertirQuerySnapshot(query);
    });
  }

  // Método para buscar recetas por nombre
  Stream<List<Receta>> buscarRecetas(String query) {
    return _firestore
        .collection('recetas')
        .where('nombre', isGreaterThanOrEqualTo: query)
        .where('nombre', isLessThanOrEqualTo: query + '\uf8ff')
        .orderBy('likes', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      return _convertirQuerySnapshot(query);
    });
  }

  // Método para buscar recetas por ingredientes
  Stream<List<Receta>> buscarRecetasPorIngredientes(String nombreIngrediente) {
    return _firestore
        .collection('recetas')
        .where('ingredientes', arrayContains: {'nombre': nombreIngrediente})
        .orderBy('likes', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      return _convertirQuerySnapshot(query);
    });
  }

  // Método para buscar recetas por tiempo
  Stream<List<Receta>> buscarRecetasPorTiempo(int tiempo) {
    return _firestore
        .collection('recetas')
        .where('tiempo', isEqualTo: tiempo)
        .orderBy('likes', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      return _convertirQuerySnapshot(query);
    });
  }

  // Método para buscar recetas por costo
  Stream<List<Receta>> buscarRecetasPorCosto(double costo) {
    return _firestore
        .collection('recetas')
        .where('costo', isEqualTo: costo)
        .orderBy('likes', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      return _convertirQuerySnapshot(query);
    });
  }

  // Método para buscar recetas por tipo de plato y nivel de dificultad
  Stream<List<Receta>> buscarRecetasPorTipoYDificultad(String tipoPlato, String dificultad) {
    return _firestore
        .collection('recetas')
        .where('plato', isEqualTo: tipoPlato)
        .where('dificultad', isEqualTo: dificultad)
        .orderBy('likes', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      return _convertirQuerySnapshot(query);
    });
  }

  // Método privado para convertir el QuerySnapshot en una lista de Receta
  List<Receta> _convertirQuerySnapshot(QuerySnapshot query) {
    List<Receta> recetas = [];
    for (var doc in query.docs) {
      final receta = Receta.fromFirestore(doc);
      recetas.add(receta);
    }
    return recetas;
  }
}


/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:part_ia/objs/recetaObj.dart';

/// Clase que maneja la interacción con Firebase para la colección de recetas.
class RecetaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Obtiene todas las recetas desde Firebase, ordenadas por la cantidad de likes.
  Stream<List<Receta>> getRecetas() {
    return _firestore
        .collection('recetas')
        .orderBy('likes', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Receta> recetas = [];
      for (var doc in query.docs) {
        final receta = Receta.fromFirestore(doc);
        recetas.add(receta);
      }
      return recetas;
    });
  }

  // Método para buscar recetas por ingredientes, tiempo y categoría
  Future<List<Receta>> buscarRecetasGemini({List<String>? ingredientes, int? tiempo, String? categoria}) async {
    Query query = _firestore.collection('recetas');

    if (ingredientes != null && ingredientes.isNotEmpty) {
      query = query.where('ingredientes.nombre', arrayContainsAny: ingredientes);
    }

    if (tiempo != null) {
      query = query.where('tiempo', isLessThanOrEqualTo: tiempo);
    }

    if (categoria != null) {
      query = query.where('categoria', isEqualTo: categoria);
    }

    QuerySnapshot querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) => Receta.fromFirestore(doc)).toList();
  }

  /// Obtiene recetas filtradas por tipo de plato.
  Stream<List<Receta>> getRecetasPorCategoria(String categoria) {
    return _firestore
        .collection('recetas')
        .where('plato', isEqualTo: categoria)
        .orderBy('likes', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Receta> recetas = [];
      for (var doc in query.docs) {
        final receta = Receta.fromFirestore(doc);
        recetas.add(receta);
      }
      return recetas;
    });
  }

  /// Busca recetas por nombre.
  Stream<List<Receta>> buscarRecetas(String query) {
    return _firestore
        .collection('recetas')
        .where('nombre', isGreaterThanOrEqualTo: query)
        .where('nombre', isLessThanOrEqualTo: query + '\uf8ff')
        .orderBy('likes', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Receta> recetas = [];
      for (var doc in query.docs) {
        final receta = Receta.fromFirestore(doc);
        recetas.add(receta);
      }
      return recetas;
    });
  }
}
*/