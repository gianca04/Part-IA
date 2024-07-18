import 'dart:convert';

class Receta {
  String nombreReceta;
  String descripcion;
  String imagen;
  List<String> valorNutricional;
  List<String> seriePasos;
  String linkVideo;
  String costoEstimado;
  String comentario;

  Receta({
    required this.nombreReceta,
    required this.descripcion,
    required this.imagen,
    required this.valorNutricional,
    required this.seriePasos,
    required this.linkVideo,
    required this.costoEstimado,
    required this.comentario,
  });

  factory Receta.fromJson(String jsonString) {
    try {
      final jsonStr = _extractJsonString(jsonString);
      final Map<String, dynamic> jsonMap = json.decode(jsonStr);

      return Receta(
        nombreReceta: jsonMap['nombre_receta'] ?? '',
        descripcion: jsonMap['descripcion'] ?? '',
        imagen: jsonMap['imagen'] ?? '',
        valorNutricional: List<String>.from(jsonMap['valor_nutricional'] ?? []),
        seriePasos: List<String>.from(jsonMap['serie_pasos'] ?? []),
        linkVideo: jsonMap['link_video'] ?? '',
        costoEstimado: jsonMap['costo_estimado'] ?? '',
        comentario: jsonMap['comentario'] ?? '',
      );
    } catch (e) {
      // Manejo de excepciones y creación de un objeto Receta vacío
      print("Error parsing JSON: $e");
      return Receta(
        nombreReceta: '',
        descripcion: '',
        imagen: '',
        valorNutricional: [],
        seriePasos: [],
        linkVideo: '',
        costoEstimado: '',
        comentario: 'Error parsing JSON',
      );
    }
  }

  static String _extractJsonString(String input) {
    final startIndex = input.indexOf('{');
    final endIndex = input.lastIndexOf('}');
    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      return input.substring(startIndex, endIndex + 1);
    } else {
      throw FormatException('Invalid JSON string');
    }
  }

  String toJson() {
    final Map<String, dynamic> jsonMap = {
      'nombre_receta': nombreReceta,
      'descripcion': descripcion,
      'imagen': imagen,
      'valor_nutricional': valorNutricional,
      'serie_pasos': seriePasos,
      'link_video': linkVideo,
      'costo_estimado': costoEstimado,
      'comentario': comentario,
    };

    return json.encode(jsonMap);
  }
}
