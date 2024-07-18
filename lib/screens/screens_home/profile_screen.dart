import 'dart:io';
import 'package:flutter/material.dart';
import 'package:part_ia/objs/usuarioObj.dart';
import 'package:provider/provider.dart';
import 'package:part_ia/providers/usuario_provider.dart';
import '../../providers/theme_provider.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isEditing = false;
  late TextEditingController _usernameController;
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _nombreController = TextEditingController();
    _apellidoController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UsuarioProvider>(context, listen: false).cargarUsuarioActual();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final UsuarioObjeto? usuario = usuarioProvider.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Usuario'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveProfileChanges(context);
              } else {
                setState(() {
                  _isEditing = true;
                  _usernameController.text = usuario!.username;
                  _nombreController.text = usuario.nombre;
                  _apellidoController.text = usuario.apellido;
                });
              }
            },
          ),
        ],
      ),
      body: usuario != null
          ? _isEditing
          ? _buildEditProfileForm(usuario)
          : _buildUserProfile(usuario, themeProvider)
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildUserProfile(UsuarioObjeto usuario, ThemeProvider themeProvider) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProfileImage(usuario.profilePictureUrl),
          SizedBox(height: 20),
          _buildUserInfo(usuario),
          SizedBox(height: 20),
          _buildLogoutButton(context),
          SizedBox(height: 20),
          SwitchListTile(
            title: const Text('Modo oscuro'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileForm(UsuarioObjeto usuario) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProfileImage(usuario.profilePictureUrl),
          SizedBox(height: 20),
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Usuario'),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _nombreController,
            decoration: InputDecoration(labelText: 'Nombre'),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _apellidoController,
            decoration: InputDecoration(labelText: 'Apellido'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _saveProfileChanges(context);
            },
            child: Text('Guardar Cambios'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(String imageUrl) {
    return CircleAvatar(
      radius: 80,
      backgroundImage: NetworkImage(imageUrl),
    );
  }

  Widget _buildUserInfo(UsuarioObjeto usuario) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          usuario.username,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          '${usuario.nombre} ${usuario.apellido}',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 10),
        Text(
          usuario.email,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showLogoutConfirmationDialog(context);
      },
      child: Text('Cerrar Sesión'),
    );
  }

  void _saveProfileChanges(BuildContext context) async {
    try {
      final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
      await usuarioProvider.actualizarUsuario(
        userId: usuarioProvider.usuario!.userId,
        username: _usernameController.text.trim(),
        nombre: _nombreController.text.trim(),
        apellido: _apellidoController.text.trim(),
      );
      setState(() {
        _isEditing = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar los cambios'),
        ),
      );
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cerrar Sesión'),
          content: Text('¿Estás seguro que deseas cerrar sesión?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cerrar Sesión'),
              onPressed: () async {
                await Provider.of<UsuarioProvider>(context, listen: false).cerrarSesion();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/'); // Navega a la pantalla de inicio

              },
            ),
          ],
        );
      },
    );
  }
}



/*import 'package:flutter/material.dart';
import 'package:part_ia/widgets/receta_widget.dart';
import 'package:part_ia/providers/theme_provider.dart'; // Importa el provider de tema
import 'package:provider/provider.dart'; // Importa provider para consumir el tema

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Center(
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return RecetaWidget(
              receta: Receta(
                titulo: 'Ensalada de Verano',
                descripcion: 'Una ensalada fresca y saludable perfecta para el verano.',
                imagenUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQdovdorGCcWcYSamm9rIhXUIrKcKPtTuh3iw&s',
                tiempoPreparacion: 20,
                informacionNutricional: {
                  'Calorías': '150 kcal',
                  'Carbohidratos': '20 g',
                  'Proteínas': '8 g',
                  'Grasas': '5 g',
                },
              ),
              modoOscuro: themeProvider.themeMode == ThemeMode.dark, // Determina el modo oscuro basado en el estado actual del tema
            );
          },
        ),
      ),
    );
  }
}

 */
