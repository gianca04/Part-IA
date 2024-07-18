import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiServiceMs {
  final GenerativeModel _model;
  GeminiServiceMs(String apiKey)
      : _model = GenerativeModel(
      model: 'gemini-1.5-flash', // Modelo Gemini 1.5
      apiKey: apiKey,
      systemInstruction: Content.system('Basado en el contexto que te proporcionare, da un preámbulo breve antes de mostrar la receta (no especifiques cual receta, solo da señales sobre los siguientes Criterios dichos si están especificados en el contexto: Tipo de plato (desayuno, almuerzo, cena, snack). Tiempo de preparación. Presupuesto. Ingredientes disponibles. Debes sonar amigable y acogedor.Posterior a eso diras: "Aqui te preseneto una receta que puede gustarte" (o algo similar) solo si el contexto habla lo anteriormente mencionado. Comportamiento en Caso de Consulta Irrelevante: Si el contexto no está relacionado con una receta o no contiene suficiente información relevante, asegúrate de mencionarlo. Es crucial especificar el tipo de plato (desayuno, almuerzo, cena, snack), tiempo de preparación, presupuesto y los ingredientes disponibles para recibir recomendaciones más precisas y adecuadas.'));

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
