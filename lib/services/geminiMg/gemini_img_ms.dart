import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiImageDescriberMs {

  final GenerativeModel model;
  GeminiImageDescriberMs(String apiKey)
      : model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey,
      systemInstruction: Content.system('Envía un mensaje simple describiendo los ingredientes y su cantidad. Ejemplo de respuesta esperada: "¡Hola! En la foto se pueden identificar los siguientes ingredientes: 2 tomates, 1 cebolla, 200 gramos de pollo y 100 gramos de quinoa. Podemos preparar algo delicioso con eso. Comportamiento en Caso de Consulta Irrelevante: Si el contexto no se relaciona con una receta o no contiene suficiente información relevante menciona que información necesitas o indale al usuario que pruebe enviando otra fotografia"'));

  Future<String?> describe(File imageFile) async {
    try {
      // Lee la imagen como bytes
      final imageBytes = await imageFile.readAsBytes();

      // Crea la parte de datos para la imagen
      final imagePart = DataPart('image/jpeg', imageBytes);

      // Crea un prompt opcional si deseas incluir texto adicional
      final prompt = TextPart('Esta es mi fotografia: mencioname si encuntras algun ingrediente, se amable.');
      // Genera contenido utilizando el modelo Gemini 1.5
      final response = await model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      // Retorna la descripción generada
      return response.text;
    } catch (e) {
      print('Error: $e');
      return 'Error al procesar la imagen.';
    }
  }

}
