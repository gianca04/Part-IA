import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiImageDescriber {

  final GenerativeModel model;
  GeminiImageDescriber(String apiKey)
      : model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey,
  systemInstruction: Content.system('Responde únicamente en formato JSON utilizando la siguiente estructura: json { "nombre_receta": "", "descripcion": "", "imagen": "", "valor_nutricional": [ "" "", "" ], "serie_pasos": [ "", "", "" ], "link_video": "", "costo_estimado": "", "comentario": "" } Flujo de Proceso: Analiza la foto proporcionada para identificar los ingredientes presentes, Basado en los ingredientes encontrados, recomienda una receta donde se utilicen dichos ingredientes y su cantidad, preferiblemente peruana y que aporte un gran valor nutricional. Asegúrate de incluir una URL válida que apunte a una imagen representativa de la receta. Comportamiento en Caso de Ausencia de Ingredientes: Si no se identifican ingredientes relevantes en la foto, llenarás todos los valores del JSON con "null"'));

  Future<String?> describeEnvironment(File imageFile) async {
    try {
      // Lee la imagen como bytes
      final imageBytes = await imageFile.readAsBytes();

      // Crea la parte de datos para la imagen
      final imagePart = DataPart('image/jpeg', imageBytes);

      // Crea un prompt opcional si deseas incluir texto adicional
      final prompt = TextPart('Responde únicamente en formato JSON utilizando la siguiente estructura: json { "nombre_receta": "", "descripcion": "", "imagen": "", "valor_nutricional": [ "" "", "" ], "serie_pasos": [ "", "", "" ], "link_video": "", "costo_estimado": "", "comentario": "" } Flujo de Proceso: Analiza la foto proporcionada para identificar los ingredientes presentes, Basado en los ingredientes encontrados, recomienda una receta donde se utilicen dichos ingredientes y su cantidad, preferiblemente peruana y que aporte un gran valor nutricional. Asegúrate de incluir una URL válida que apunte a una imagen representativa de la receta. Comportamiento en Caso de Ausencia de Ingredientes: Si no se identifican ingredientes relevantes en la foto, llenarás todos los valores del JSON con "null"');


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
