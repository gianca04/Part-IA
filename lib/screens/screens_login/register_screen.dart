import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:part_ia/services/usuario_service.dart';
import 'package:part_ia/objs/usuarioObj.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Usuario usuarioCre = Usuario();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File? _profileImage;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _createUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await usuarioCre.createUser(
        username: _usernameController.text,
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
        email: _emailController.text,
        password: _passwordController.text,
        profileImage: _profileImage!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario creado con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registro de Usuario',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Color.fromRGBO(99, 162, 177, 1),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondo.jpg'),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: Container(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 20),
                    _buildProfileImagePicker(),
                    SizedBox(height: 20),
                    _buildTextField(_usernameController, 'Nombre de usuario'),
                    SizedBox(height: 10),
                    _buildTextField(_nombreController, 'Nombre'),
                    SizedBox(height: 10),
                    _buildTextField(_apellidoController, 'Apellido'),
                    SizedBox(height: 10),
                    _buildTextField(_emailController, 'Correo'),
                    SizedBox(height: 10),
                    _buildTextField(_passwordController, 'Contraseña', obscureText: true),
                    SizedBox(height: 20),
                    _buildCreateUserButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImagePicker() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('Cámara'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.image),
                    title: Text('Galería'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        height: 120.0,
        padding: EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
              child: _profileImage == null ? Icon(Icons.person, size: 50) : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                backgroundColor: Color.fromRGBO(99, 162, 177, 1),
                radius: 20,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(99, 162, 177, 1)),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(99, 162, 177, 1)),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(99, 162, 177, 1), width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
      maxLength: 50,
      obscureText: obscureText,
    );
  }

  Widget _buildCreateUserButton() {
    return ElevatedButton(
      onPressed: _createUser,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(99, 162, 177, 1),
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Text(
        'Crear Usuario',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
