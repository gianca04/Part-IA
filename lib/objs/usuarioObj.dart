class UsuarioObjeto {
  String userId;
  String username;
  String nombre;
  String apellido;
  String email;
  String profilePictureUrl;

  UsuarioObjeto({
    required this.userId,
    required this.username,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.profilePictureUrl,
  });

  factory UsuarioObjeto.fromFirestore(Map<String, dynamic> data) {
    return UsuarioObjeto(
      userId: data['userId'],
      username: data['username'],
      nombre: data['nombre'],
      apellido: data['apellido'],
      email: data['email'],
      profilePictureUrl: data['profilePictureUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'username': username,
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}

