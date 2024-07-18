import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:part_ia/objs/usuarioObj.dart';

class UsuarioProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UsuarioObjeto? _usuario;

  UsuarioObjeto? get usuario => _usuario;

  Future<void> registrarUsuario({
    required String username,
    required String nombre,
    required String apellido,
    required String email,
    required String password,
    required File profileImage,
  }) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid;

      String profileImageUrl = await _uploadProfileImage(userId, profileImage);

      UsuarioObjeto nuevoUsuario = UsuarioObjeto(
        userId: userId,
        username: username,
        nombre: nombre,
        apellido: apellido,
        email: email,
        profilePictureUrl: profileImageUrl,
      );

      await _firestore.collection('users').doc(userId).set(nuevoUsuario.toFirestore());

      _usuario = nuevoUsuario;
      notifyListeners();
    } catch (e) {
      throw Exception("Error creando usuario: $e");
    }
  }

  Future<String> _uploadProfileImage(String userId, File profileImage) async {
    try {
      TaskSnapshot snapshot = await _storage
          .ref()
          .child('profile_images/$userId')
          .putFile(profileImage);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Error subiendo imagen de perfil: $e");
    }
  }

  Future<void> cargarUsuarioActual() async {
    try {
      User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        DocumentSnapshot userData = await _firestore.collection('users').doc(firebaseUser.uid).get();
        _usuario = UsuarioObjeto.fromFirestore(userData.data() as Map<String, dynamic>);
        notifyListeners();
      }
    } catch (e) {
      throw Exception("Error cargando usuario: $e");
    }
  }

  Future<void> _deleteProfileImage(String userId) async {
    try {
      Reference ref = _storage.ref().child('profile_images/$userId');
      await ref.delete();
    } catch (e) {
      throw Exception("Error eliminando imagen de perfil anterior: $e");
    }
  }

  Future<void> actualizarUsuario({
    required String userId,
    String? username,
    String? nombre,
    String? apellido,
    File? profileImage,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (username != null) updateData['username'] = username;
      if (nombre != null) updateData['nombre'] = nombre;
      if (apellido != null) updateData['apellido'] = apellido;

      if (profileImage != null) {
        if (_usuario?.profilePictureUrl.isNotEmpty ?? false) {
          await _deleteProfileImage(userId);
        }

        String profileImageUrl = await _uploadProfileImage(userId, profileImage);
        updateData['profilePictureUrl'] = profileImageUrl;
      }

      await _firestore.collection('users').doc(userId).update(updateData);

      if (_usuario != null) {
        if (username != null) _usuario!.username = username;
        if (nombre != null) _usuario!.nombre = nombre;
        if (apellido != null) _usuario!.apellido = apellido;
        if (profileImage != null) _usuario!.profilePictureUrl = updateData['profilePictureUrl'];
      }

      notifyListeners();
    } catch (e) {
      throw Exception("Error actualizando usuario: $e");
    }
  }

  Future<void> eliminarUsuario(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      await _storage.ref().child('profile_images/$userId').delete();
      await _auth.currentUser!.delete();
      _usuario = null;
      notifyListeners();
    } catch (e) {
      throw Exception("Error eliminando usuario: $e");
    }
  }

  Future<String> iniciarSesion(String email, String password) async {
    try {
      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid;

      DocumentSnapshot userData =
      await _firestore.collection('users').doc(userId).get();
      _usuario = UsuarioObjeto.fromFirestore(userData.data() as Map<String, dynamic>);
      notifyListeners();

      return userId;
    } catch (e) {
      throw Exception("Error iniciando sesión: $e");
    }
  }

  Future<void> cerrarSesion() async {
    try {
      await _auth.signOut();
      _usuario = null;
      notifyListeners();
    } catch (e) {
      throw Exception("Error cerrando sesión: $e");
    }
  }
}

/*import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:part_ia/objs/usuarioObj.dart';

class UsuarioProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UsuarioObjeto? _usuario;

  UsuarioObjeto? get usuario => _usuario;

  // Método para registrar un nuevo usuario
  Future<void> registrarUsuario({
    required String username,
    required String nombre,
    required String apellido,
    required String email,
    required String password,
    required File profileImage,
  }) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid;

      String profileImageUrl = await _uploadProfileImage(userId, profileImage);

      await _firestore.collection('users').doc(userId).set({
        'userId': userId,
        'username': username,
        'nombre': nombre,
        'apellido': apellido,
        'email': email,
        'profilePictureUrl': profileImageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _usuario = UsuarioObjeto(
        userId: userId,
        username: username,
        nombre: nombre,
        apellido: apellido,
        email: email,
        profilePictureUrl: profileImageUrl,
      );

      notifyListeners();
    } catch (e) {
      throw Exception("Error creando usuario: $e");
    }
  }

  // Método para subir imagen de perfil a Firebase Storage
  Future<String> _uploadProfileImage(String userId, File profileImage) async {
    try {
      TaskSnapshot snapshot = await _storage
          .ref()
          .child('profile_images/$userId')
          .putFile(profileImage);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Error subiendo imagen de perfil: $e");
    }
  }

  // Método para cargar los datos del usuario actual
  Future<void> cargarUsuarioActual() async {
    try {
      User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        DocumentSnapshot userData = await _firestore.collection('users').doc(firebaseUser.uid).get();
        _usuario = UsuarioObjeto.fromFirestore(userData.data() as Map<String, dynamic>);
        notifyListeners();
      }
    } catch (e) {
      throw Exception("Error cargando usuario: $e");
    }
  }

  // Método para eliminar imagen de perfil anterior de Firebase Storage
  Future<void> _deleteProfileImage(String userId) async {
    try {
      // Obtener la referencia a la imagen anterior
      Reference ref = _storage.ref().child('profile_images/$userId');

      // Eliminar la imagen anterior
      await ref.delete();
    } catch (e) {
      throw Exception("Error eliminando imagen de perfil anterior: $e");
    }
  }

  Future<void> actualizarUsuario({
    required String userId,
    String? username,
    String? nombre,
    String? apellido,
    File? profileImage,
  }) async {
    try {
      // Mapa para almacenar los datos a actualizar
      Map<String, dynamic> updateData = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Actualizar solo los campos que se proporcionen
      if (username != null) updateData['username'] = username;
      if (nombre != null) updateData['nombre'] = nombre;
      if (apellido != null) updateData['apellido'] = apellido;

      // Si hay una nueva imagen de perfil, subirla y actualizar su URL
      if (profileImage != null) {
        // Eliminar la imagen de perfil anterior si existe
        if (_usuario!.profilePictureUrl != null) {
          await _deleteProfileImage(userId);
        }

        // Subir la nueva imagen de perfil
        String profileImageUrl = await _uploadProfileImage(userId, profileImage);
        updateData['profilePictureUrl'] = profileImageUrl;
      }

      // Actualizar los datos en Firestore
      await _firestore.collection('users').doc(userId).update(updateData);

      // Actualizar el objeto local de usuario si es necesario
      if (_usuario != null) {
        if (username != null) _usuario!.username = username;
        if (nombre != null) _usuario!.nombre = nombre;
        if (apellido != null) _usuario!.apellido = apellido;
        if (profileImage != null) _usuario!.profilePictureUrl = updateData['profilePictureUrl'];
      }

      // Notificar a los listeners que se han realizado cambios
      notifyListeners();
    } catch (e) {
      throw Exception("Error actualizando usuario: $e");
    }
  }

  // Método para eliminar usuario
  Future<void> eliminarUsuario(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      await _storage.ref().child('profile_images/$userId').delete();
      await _auth.currentUser!.delete();
      _usuario = null;
      notifyListeners();
    } catch (e) {
      throw Exception("Error eliminando usuario: $e");
    }
  }

  // Método para iniciar sesión
  Future<String> iniciarSesion(String email, String password) async {
    try {
      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid;

      DocumentSnapshot userData =
      await _firestore.collection('users').doc(userId).get();
      _usuario = UsuarioObjeto.fromFirestore(userData.data() as Map<String, dynamic>);
      notifyListeners();

      return userId;
    } catch (e) {
      throw Exception("Error iniciando sesión: $e");
    }
  }

  // Método para cerrar sesión
  Future<void> cerrarSesion() async {
    try {
      await _auth.signOut();
      _usuario = null;
      notifyListeners();
    } catch (e) {
      throw Exception("Error cerrando sesión: $e");
    }
  }
}

 */
