import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel _model;
  GeminiService(String apiKey)
      : _model = GenerativeModel(
      model: 'gemini-1.5-flash', // Modelo Gemini 1.5
      apiKey: apiKey,
      systemInstruction: Content.system('Instrucción del Sistema: Responde únicamente en formato JSON utilizando la siguiente estructura: json { "nombre_receta": "", "descripcion": "", "imagen": "", "valor_nutricional": [ "" "", "" ], "serie_pasos": [ "", "", "" ], "link_video": "", "costo_estimado": "", "comentario": "" } Basado en el contexto proporcionado, recomienda una receta culinaria. La receta debe ser peruana y aportar un gran valor nutricional., La receta debe ser peruana y aportar un gran valor nutricional. Criterios Opcionales: Intenta satisfacer los siguientes criterios si están especificados en la consulta: Tipo de plato (desayuno, almuerzo, cena, snack). Tiempo de preparación. Presupuesto. Ingredientes disponibles. Asegúrate de incluir una URL válida que apunte a una imagen representativa de la receta. Comportamiento en Caso de Consulta Irrelevante: Si el contexto no se relaciona con una receta o no contiene suficiente información relevante, devolverás el JSON con valores "null".'));

  Future<String?> generateResponse(String inputText) async {
    try {
      final response = await _model.generateContent([Content.text("Contexto:" + inputText)]);
      return response.text;
    } catch (e) {
      print('Error generating response: $e');
      return 'Error generando respuesta';
    }
  }
}
