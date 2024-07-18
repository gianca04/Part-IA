import 'package:cloud_firestore/cloud_firestore.dart';

/// Clase que representa una receta.
class Receta {
  final String recetaId;
  final String nombre;
  final String descripcion;
  final String imagen;
  final double tiempo;
  final double porciones;
  final double costo;
  final List<Ingrediente> ingredientes;
  final double calorias;
  final double proteinas;
  final double grasas;
  final double carbohidratos;
  final int likes;
  final String video;
  final String linkVideo;
  final String plato;
  final String dificultad;
  final List<String> pasos;

  /// Constructor para inicializar una receta.
  Receta({
    required this.recetaId,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    required this.tiempo,
    required this.porciones,
    required this.costo,
    required this.ingredientes,
    required this.calorias,
    required this.proteinas,
    required this.grasas,
    required this.carbohidratos,
    required this.likes,
    required this.video,
    required this.linkVideo,
    required this.plato,
    required this.dificultad,
    required this.pasos,
  });

  /// Método para crear un objeto Receta desde un documento de Firebase.
  factory Receta.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    double parseDouble(dynamic value) {
      if (value is double) {
        return value;
      } else if (value is int) {
        return value.toDouble();
      } else if (value is String) {
        return double.tryParse(value) ?? 0.0;
      } else {
        return 0.0;
      }
    }

    return Receta(
      recetaId: doc.id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      imagen: data['imagen'] ?? '',
      tiempo: parseDouble(data['tiempo']),
      porciones: parseDouble(data['porciones']),
      costo: parseDouble(data['costo']),
      ingredientes: (data['ingredientes'] as List<dynamic>?)
          ?.map((item) => Ingrediente.fromMap(item))
          .toList() ?? [],
      calorias: parseDouble(data['calorias']),
      proteinas: parseDouble(data['proteinas']),
      grasas: parseDouble(data['grasas']),
      carbohidratos: parseDouble(data['carbohidratos']),
      likes: data['likes'] ?? 0,
      video: data['video'] ?? '',
      linkVideo: data['linkVideo'] ?? '',
      plato: data['plato'] ?? '',
      dificultad: data['dificultad'] ?? '',
      pasos: (data['pasos'] as List<dynamic>?)
          ?.map((paso) => paso.toString())
          .toList() ?? [],
    );
  }

  /// Método para obtener el link de video, priorizando el campo 'video' sobre 'linkVideo'.
  String getVideoLink() {
    return video.isNotEmpty ? video : linkVideo;
  }

  /// Método para convertir una receta a un mapa de datos.
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'imagen': imagen,
      'tiempo': tiempo,
      'porciones': porciones,
      'costo': costo,
      'ingredientes': ingredientes.map((i) => i.toMap()).toList(),
      'calorias': calorias,
      'proteinas': proteinas,
      'grasas': grasas,
      'carbohidratos': carbohidratos,
      'likes': likes,
      'video': video,
      'linkVideo': linkVideo,
      'plato': plato,
      'dificultad': dificultad,
      'pasos': pasos,
    };
  }
}



/// Clase que representa un ingrediente.
class Ingrediente {
  final String nombre;
  final double cantidad;

  Ingrediente({
    required this.nombre,
    required this.cantidad,
  });



  factory Ingrediente.fromMap(Map<String, dynamic> data) {
    double parseDouble(dynamic value) {
      if (value is double) {
        return value;
      } else if (value is int) {
        return value.toDouble();
      } else if (value is String) {
        return double.tryParse(value) ?? 0.0;
      } else {
        return 0.0;
      }
    }

    return Ingrediente(
      nombre: data['nombre'] ?? '',
      cantidad: parseDouble(data['cantidad']),
    );
  }




  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'cantidad': cantidad,
    };
  }
}
