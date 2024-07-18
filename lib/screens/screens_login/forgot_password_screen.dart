import 'package:flutter/material.dart';
import 'package:part_ia/services/usuario_service.dart'; // Asegúrate de importar el servicio adecuado
import 'dart:async';

class ForgotPasswordScreen extends StatelessWidget {
  final Color primaryColor = Color.fromRGBO(99, 162, 177, 1);
  final Usuario user =
      Usuario(); // Considera inicializar el usuario según lo necesario
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Olvidé mi contraseña',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [
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
            padding: EdgeInsets.all(28.0),
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  children: [
                    _buildLogo(),
                    SizedBox(height: 0),
                    buildTitle(),
                    SizedBox(height: 20),
                    EmailInput(
                        primaryColor: primaryColor,
                        controller: _emailController),
                    SizedBox(height: 20),
                    _buildSendButton(context),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(3),
      child: const Text(
        'No te preocupes, suele pasar. Proporciona tu correo y te llegará un enlace para restablecer tu contraseña.',
        style: TextStyle(fontSize: 15),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Image.asset(
        'assets/images/robot.png',
        width: 150,
        height: 150,
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );

          await user.sendPasswordResetEmail(_emailController.text);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Correo de restablecimiento enviado')));
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error: $e')));
        } finally {
          Navigator.of(context).pop();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: const Text(
        'Restablecer contraseña',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  final Color primaryColor;
  final TextEditingController controller;

  EmailInput({required this.primaryColor, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
      maxLength: 50,
    );
  }
}
