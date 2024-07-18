import 'package:flutter/material.dart';
import 'package:part_ia/screens/home_page.dart';
import 'package:part_ia/screens/screens_login/forgot_password_screen.dart';
import 'package:part_ia/screens/screens_login/register_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/usuario_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/fondo.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ), // Transparencia
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20), // Aumentar padding
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                // Hacer los bordes más redondeados
                side: BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ), // Color azul en los bordes
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(15), // Aumentar padding
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildLogo(),
                      buildTitle(),
                      buildUsernameTextField(),
                      buildPasswordTextField(),
                      buildForgotPasswordButton(),
                      buildLoginButton(usuarioProvider),
                      buildSignUpRow(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLogo() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Image.asset(
        'assets/images/iconapp.png',
        width: 250,
        height: 250,
      ),
    );
  }

  Widget buildTitle() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(3),
      child: const Text(
        '¡Inicia sesión y empieza a cocinar!',
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildUsernameTextField() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            // Color azul para el borde
            borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
          ),
          labelText: 'Correo',
        ),
      ),
    );
  }

  Widget buildPasswordTextField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextField(
        obscureText: true,
        controller: passwordController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            // Color azul para el borde
            borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
          ),
          labelText: 'Contraseña',
        ),
      ),
    );
  }

  Widget buildForgotPasswordButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
        );
      },
      child: const Text('Olvidé mi contraseña'),
    );
  }

  Widget buildLoginButton(UsuarioProvider usuarioProvider) {
    return Container(
      height: 50,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () => _login(usuarioProvider),
        child: const Text(
          'Acceder',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildSignUpRow(BuildContext context) {
    return Row(
      children: <Widget>[
        const Text('¿Aún no tienes cuenta?'),
        TextButton(
          child: const Text(
            'Registrarse',
            style: TextStyle(fontSize: 16),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterScreen()),
            );
          },
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  void _showSnackbar(String msg) {
    final snack = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  Future<void> _login(UsuarioProvider usuarioProvider) async {
    //Navigator.pushReplacementNamed(context, '/home',);
    try {
      if (nameController.text.isEmpty || passwordController.text.isEmpty) {
        _showSnackbar(
          "${nameController.text.isEmpty ? "Correo " : ""}${passwordController.text.isEmpty ? "Contraseña " : ""} requerido",
        );
        return;
      } else {
        _showSnackbar("Validando credenciales...");
        String email = nameController.text;
        String password = passwordController.text;

        try {
          String userId = await usuarioProvider.iniciarSesion(email, password);
          if (userId.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          } else {
            _showSnackbar("Usuario inexistente");
          }
        } catch (e) {
          _showSnackbar("Error al validar: $e");
        }
      }
    } catch (e) {
      _showSnackbar("Error inesperado: $e");
    }
  }
}


/*import 'package:flutter/material.dart';
import 'package:part_ia/screens/home_page.dart';
import 'package:part_ia/screens/screens_login/forgot_password_screen.dart';
import 'package:part_ia/screens/screens_login/register_screen.dart';
import 'package:part_ia/services/usuario_service.dart';
import 'package:provider/provider.dart';

import '../providers/Usuario_provider.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Usuario _usuario = new Usuario();

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/fondo.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5),
                BlendMode.darken), // Transparencia
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20), // Aumentar padding
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                // Hacer los bordes más redondeados
                side: BorderSide(
                    color: Colors.blue, width: 2.0), // Color azul en los bordes
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(15), // Aumentar padding
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildLogo(),
                      buildTitle(),
                      buildUsernameTextField(),
                      buildPasswordTextField(),
                      buildForgotPasswordButton(),
                      buildLoginButton(),
                      buildSignUpRow(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLogo() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Image.asset(
        'assets/images/iconoapp.png',
        width: 250,
        height: 250,
      ),
    );
  }

  Widget buildTitle() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(3),
      child: const Text(
          '¡Inicia sesión y empieza a cocinar!',
          style: TextStyle(fontSize: 20), textAlign: TextAlign.center
      ),
    );
  }

  Widget buildUsernameTextField() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            // Color azul para el borde
            borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
          ),
          labelText: 'Correo',
        ),
      ),
    );
  }

  Widget buildPasswordTextField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextField(
        obscureText: true,
        controller: passwordController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            // Color azul para el borde
            borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
          ),
          labelText: 'Contraseña',
        ),
      ),
    );
  }

  Widget buildForgotPasswordButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
        );
      },
      child: const Text('Olvidé mi contraseña'),
    );
  }

  Widget buildLoginButton() {
    return Container(
      height: 50,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: _login,
        child: const Text(
          'Acceder',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildSignUpRow(BuildContext context) {

    return Row(
      children: <Widget>[
        const Text('¿Aún no tienes cuenta?'),
        TextButton(
          child: const Text(
            'Registrarse',
            style: TextStyle(fontSize: 16),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterScreen()),
            );
          },
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }


  void _showSnackbar(String msg) {
    final snack = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  Future<void> _login() async {
    //Navigator.pushReplacementNamed(context, '/home',);
    try {
      if (nameController.text.isEmpty || passwordController.text.isEmpty) {
        _showSnackbar(
          "${nameController.text.isEmpty ? "Correo " : ""}${passwordController
              .text.isEmpty ? "Contraseña " : ""} requerido",
        );
        return;
      } else {
        _showSnackbar("Validando credenciales...");
        String email = nameController.text;
        String password = passwordController.text;

        try {
          String userId = await _usuario.signIn(email, password);
          if (userId.isNotEmpty) {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          } else {
            _showSnackbar("Usuario inexistente");
          }
        } catch (e) {
          _showSnackbar("Error al validar: $e");
        }
      }
    } catch (e) {
      _showSnackbar("Error inesperado: $e");
    }
  }
}

 */