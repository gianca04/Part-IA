import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:part_ia/providers/theme_provider.dart';
import 'package:part_ia/services/usuario_service.dart';
import '../../providers/usuario_provider.dart';  // Asegúrate de que el nombre del archivo y la clase coincidan

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final usuarioProvider = Provider.of<UsuarioProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Modo oscuro'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
          TextButton.icon(
            onPressed: () async {
              try {
                await usuarioProvider.cerrarSesion();
                Navigator.pushReplacementNamed(context, '/');
              } catch (e) {
                print("Error al cerrar sesión: $e");
                // Manejar errores
              }
            },
            icon: Icon(Icons.logout),
            label: Text("Cerrar Sesión"),
          ),
        ],
      ),
    );
  }
}
