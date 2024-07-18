import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:part_ia/objs/usuarioObj.dart';

class Usuario {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Método para crear un usuario
  Future<void> createUser({
    required String username,
    required String nombre,
    required String apellido,
    required String email,
    required String password,
    required File profileImage,
  }) async {
    try {
      // Crear usuario en Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid;

      // Subir imagen de perfil a Firebase Storage
      String profileImageUrl = await _uploadProfileImage(userId, profileImage);


      // Guardar datos del usuario en Firestore
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
    } catch (e) {
      throw Exception("Error creando usuario: $e");
    }
  }

  // Método para subir imagen de perfil a Firebase Storage
  Future<String> _uploadProfileImage(String userId, File profileImage) async {
    try {
      print("El user ID de la foto es: " + userId);
      TaskSnapshot snapshot = await _storage
          .ref()
          .child('profile_images/$userId')
          .putFile(profileImage);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Error subiendo imagen de perfil: $e");
    }
  }

  // Método para editar datos del usuario
  Future<void> updateUser({
    required String userId,
    String? username,
    String? nombre,
    String? apellido,
    String? email,
    File? profileImage,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (username != null) updateData['username'] = username;
      if (nombre != null) updateData['nombre'] = nombre;
      if (apellido != null) updateData['apellido'] = apellido;
      if (email != null) {
        await _auth.currentUser!.updateEmail(email);
        updateData['email'] = email;
      }

      if (profileImage != null) {
        String profileImageUrl = await _uploadProfileImage(userId, profileImage);
        updateData['profilePictureUrl'] = profileImageUrl;
      }

      await _firestore.collection('users').doc(userId).update(updateData);
    } catch (e) {
      throw Exception("Error actualizando usuario: $e");
    }
  }

  // Método para borrar un usuario
  Future<void> deleteUser(String userId) async {
    try {
      // Borrar datos del usuario en Firestore
      await _firestore.collection('users').doc(userId).delete();

      // Borrar imagen de perfil del usuario en Firebase Storage
      await _storage.ref().child('profile_images/$userId').delete();

      // Cerrar sesión del usuario actual
      await signOut();

      // Borrar usuario en Firebase Auth
      await _auth.currentUser!.delete();
    } catch (e) {
      throw Exception("Error borrando usuario: $e");
    }
  }

  // Método para iniciar sesión
  Future<String> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!.uid;
    } catch (e) {
      throw Exception("Error iniciando sesión: $e");
    }
  }

  // Método para obtener un UsuarioObjeto desde Firestore
  Future<UsuarioObjeto> getUsuarioObjeto(String userId) async {
    try {
      DocumentSnapshot userData = await _firestore.collection('users').doc(userId).get();
      return UsuarioObjeto.fromFirestore(userData.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception("Error obteniendo datos del usuario: $e");
    }
  }

  Future<User?> getUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception("Error iniciando sesión: $e");
    }
  }


  // Método para cerrar sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Error cerrando sesión: $e");
    }
  }

  // Método para enviar email de verificación
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
    } catch (e) {
      throw Exception("Error enviando email de verificación: $e");
    }
  }

  // Método para recuperar contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception("Error enviando email de recuperación: $e");
    }
  }

  // Método para obtener el usuario actual
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Método para obtener los datos del usuario actual desde Firestore
  Future<DocumentSnapshot> getUserData(String userId) async {
    try {
      return await _firestore.collection('users').doc(userId).get();
    } catch (e) {
      throw Exception("Error obteniendo datos del usuario: $e");
    }
  }
}
