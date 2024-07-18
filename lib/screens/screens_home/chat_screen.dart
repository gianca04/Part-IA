import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:part_ia/objs/recetajson.dart';
import 'package:part_ia/services/geminiMg/gemini_img_ms.dart';
import 'package:part_ia/services/gemini_service.dart';
import 'package:part_ia/widgets/receta_gemini.dart'; // Asegúrate de importar tu servicio Gemini aquí
import 'package:part_ia/services/gemini_service_img.dart';
import 'package:part_ia/services/geminiMg/gemini_text_ms.dart';

class ChatScreen extends StatefulWidget {
  final String apiKey;

  ChatScreen({Key? key, required this.apiKey}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late GeminiService _geminiService;
  late GeminiImageDescriber _geminiServiceImg;

  late GeminiServiceMs _geminiServiceMs;
  late GeminiImageDescriberMs _geminiServiceImgMs;

  final TextEditingController _messageController = TextEditingController();
  List<Widget> messages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _geminiService = GeminiService(widget.apiKey);
    _geminiServiceImg = GeminiImageDescriber(widget.apiKey);

    _geminiServiceMs = GeminiServiceMs(widget.apiKey);
    _geminiServiceImgMs = GeminiImageDescriberMs(widget.apiKey);
  }

  void _sendMessage() async {
    String userMessage = _messageController.text;
    _messageController.clear();

    setState(() {
      messages.add(_buildUserMessageBubble(userMessage));
    });

    String? response = await _geminiService.generateResponse(userMessage);
    String? responseMs = await _geminiServiceMs.generateResponse(userMessage);

    if (response != null && responseMs != null) {
      try {
        messages.add(_buildSystemMessageBubble(responseMs));
        Receta receta = Receta.fromJson(response);

        if (receta.nombreReceta != "null" && receta.nombreReceta != "") {
          setState(() {
            messages.add(RecetaWidget(receta: receta));
          });
        } else {
          setState(() {
            messages.add(_buildErrorTile());
          });
        }
      } catch (e) {
        setState(() {
          messages.add(_buildErrorTile());
        });
      }
    } else {
      setState(() {
        messages.add(_buildErrorTile());
      });
    }
  }

  Widget _buildUserMessageBubble(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 80.0, top: 8.0, bottom: 8.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSystemMessageBubble(String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 80.0, top: 8.0, bottom: 8.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorTile() {
    return ListTile(
      title: Text('Error: Tu consulta es incorrecta.'),
    );
  }

  void _showImagePickerMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Seleccionar de la galería'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Tomar una foto'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        messages.add(_buildImageBubble(File(pickedFile.path)));
      });

      try {
        String? description = await _geminiServiceImg.describeEnvironment(File(pickedFile.path));
        String? descriptionMs = await _geminiServiceImgMs.describe(File(pickedFile.path));

        if (description != null) {
          try {
            messages.add(_buildSystemMessageBubble(descriptionMs!));

            Receta receta = Receta.fromJson(description);

            if (receta.nombreReceta != "null" && receta.nombreReceta != "") {
              setState(() {
                messages.add(RecetaWidget(receta: receta));
              });
            } else {
              setState(() {
                messages.add(_buildErrorTile());
              });
            }
          } catch (e) {
            setState(() {
              messages.add(_buildErrorTile());
            });
          }
        } else {
          setState(() {
            messages.add(_buildErrorTile());
          });
        }
      } catch (e) {
        print('Error al procesar la imagen con Gemini: $e');
        setState(() {
          messages.add(_buildErrorTile());
        });
      }
    }
  }

  Widget _buildImageBubble(File imageFile) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 80.0, top: 8.0, bottom: 8.0),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Image.file(imageFile),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con Part-IA'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/fondo.jpg',
                    fit: BoxFit.cover,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.85)
                        : Colors.white,
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
                ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) => messages[index],
                ),
              ],
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Escribe y yo buscaré la receta ;)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _showImagePickerMenu,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
          ),

        ],
      ),
    );
  }
}

/*

class ChatScreen extends StatefulWidget {
  final String apiKey;

  ChatScreen({Key? key, required this.apiKey}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late GeminiService _geminiService;
  late GeminiImageDescriber _geminiServiceImg;

  late GeminiServiceMs _geminiServiceMs;
  late GeminiImageDescriberMs _geminiServiceImgMs;


  final TextEditingController _messageController = TextEditingController();
  List<Widget> messages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _geminiService = GeminiService(widget.apiKey);
    _geminiServiceImg = GeminiImageDescriber(widget.apiKey); // Inicialización en initState

    _geminiServiceMs = GeminiServiceMs(widget.apiKey);
    _geminiServiceImgMs = GeminiImageDescriberMs(widget.apiKey);
  }

  void _sendMessage() async {
    String userMessage = _messageController.text;
    _messageController.clear();

    setState(() {
      messages.add(_buildUserMessageBubble(userMessage));
    });

    // Envía el mensaje al modelo Gemini y obtén la respuesta
    String? response = await _geminiService.generateResponse(userMessage);
    String? responseMs = await _geminiServiceMs.generateResponse(userMessage);

    if (response != null && responseMs != null) {
      // Procesa la respuesta
      try {
        messages.add(_buildSystemMessageBubble(responseMs));
        // Intenta convertir la respuesta en un objeto Receta
        Receta receta = Receta.fromJson(response);

        // Verifica si la respuesta es válida antes de agregarla
        if (receta.nombreReceta != "null" && receta.nombreReceta != "") {
          setState(() {
            messages.add(RecetaWidget(receta: receta));
          });
        } else {
          // Maneja el caso donde la respuesta no contiene una receta válida
          setState(() {
            messages.add(_buildErrorTile());
          });
        }
      } catch (e) {
        // Captura cualquier error al convertir la respuesta
        setState(() {
          messages.add(_buildErrorTile());
        });
      }
    } else {
      // Maneja el caso donde no se recibe una respuesta válida
      setState(() {
        messages.add(_buildErrorTile());
      });
    }
  }


  Widget _buildUserMessageBubble(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 80.0, top: 8.0, bottom: 8.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorTile() {
    return ListTile(
      title: Text('Error: Tu consulta es incorrecta.'),
    );
  }

  void _showImagePickerMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Seleccionar de la galería'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Tomar una foto'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSystemMessageBubble(String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 80.0, top: 8.0, bottom: 8.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      // Muestra la imagen seleccionada
      setState(() {
        messages.add(_buildImageBubble(File(pickedFile.path)));
      });

      // Envía la imagen al servicio Gemini y obtén la descripción
      try {
        String? description = await _geminiServiceImg.describeEnvironment(File(pickedFile.path));
        String? descriptionMs = await _geminiServiceImgMs.describe(File(pickedFile.path));


        // Maneja la respuesta según lo necesario en tu aplicación
        if (description != null) {
          try {
            messages.add(_buildSystemMessageBubble(descriptionMs!));

            // Intenta convertir la descripción en un objeto Receta
            Receta receta = Receta.fromJson(description);

            // Verifica si la respuesta es válida antes de agregarla
            if (receta.nombreReceta != "null" && receta.nombreReceta != "") {
              setState(() {
                messages.add(RecetaWidget(receta: receta));
              });
            } else {
              // Maneja el caso donde la descripción no contiene una receta válida
              setState(() {
                messages.add(_buildErrorTile());
              });
            }
          } catch (e) {
            // Captura cualquier error al convertir la descripción
            setState(() {
              messages.add(_buildErrorTile());
            });
          }
        } else {
          // Maneja el caso donde no se recibe una descripción válida
          setState(() {
            messages.add(_buildErrorTile());
          });
        }
      } catch (e) {
        print('Error al procesar la imagen con Gemini: $e');
        // Captura cualquier error al procesar la imagen
        setState(() {
          messages.add(_buildErrorTile());
        });
      }
    }
  }


  Widget _buildImageBubble(File imageFile) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 80.0, top: 8.0, bottom: 8.0),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Image.file(imageFile),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con Part-IA'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Container(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.9)
                    : Colors.white.withOpacity(0.9),
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) => messages[index],
                ),
              ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Escribe y yo buscaré la receta ;)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _showImagePickerMenu,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}


 */
/*import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:part_ia/services/gemini_service.dart';
import 'package:part_ia/widgets/receta_gemini.dart';
import 'package:part_ia/objs/recetajson.dart';

class ChatScreen extends StatefulWidget {
  final String apiKey;

  ChatScreen({Key? key, required this.apiKey}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late GeminiService _geminiService;
  final TextEditingController _messageController = TextEditingController();
  List<Widget> messages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _geminiService = GeminiService(widget.apiKey);
  }

  void _sendMessage() async {
    String userMessage = _messageController.text;
    _messageController.clear();
    setState(() {
      messages.add(_buildUserMessageBubble(userMessage));
    });

    // Envía el mensaje al modelo Gemini y obtén la respuesta
    String? response = await _geminiService.generateResponse(userMessage);

    if (response != null) {
      try {
        Receta receta = Receta.fromJson(response);
        setState(() {
          messages.add(RecetaWidget(receta: receta));
        });
      } catch (e) {
        setState(() {
          messages.add(_buildErrorTile());
        });
      }
    } else {
      setState(() {
        messages.add(_buildErrorTile());
      });
    }
  }

  Widget _buildUserMessageBubble(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 80.0, top: 8.0, bottom: 8.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorTile() {
    return ListTile(
      title: Text('Error: Unable to process response'),
    );
  }

  void _showImagePickerMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Seleccionar de la galería'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Tomar una foto'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSystemMessageBubble(String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 80.0, top: 8.0, bottom: 8.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        messages.add(_buildImageBubble(File(pickedFile.path)));
      });
    }
  }

  Widget _buildImageBubble(File imageFile) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 80.0, top: 8.0, bottom: 8.0),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Image.file(imageFile),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con Part-IA'),
      ),
      body: Column(
        children: <Widget>[

          Expanded(

            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) => messages[index],

            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Escribe y yo buscare la receta ;)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),

          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _showImagePickerMenu,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}

 */
