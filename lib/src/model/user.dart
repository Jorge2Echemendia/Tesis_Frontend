import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    String? id;
    String ?nombre;
    String ?apellido;
    String ?email;
    String ?password;
    String ?telefono;
    String ?imagen;
    String ?token;
    String ?notificationToken;
    String ?tipoUsuario;
    

    User({
        this.id,
        required this.nombre,
        required this.apellido,
        required this.email,
        required this.password,
        required this.telefono,
        this.imagen,
        required this.token,
        this.notificationToken,
        required this.tipoUsuario
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id_usuario"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        email: json["email"],
        password: json["password"],
        telefono: json["telefono"],
        imagen: json["imagen"],
        token: json["token"],
        notificationToken: json["notificacion_token"],
        tipoUsuario: json["tipo_usuario"]
    );

    Map<String, dynamic> toJson() => {
        "id_usuario": id,
        "nombre": nombre,
        "apellido": apellido,
        "email": email,
        "password": password,
        "telefono": telefono,
        "imagen": imagen,
        "token": token,
        "notificacion_token": notificationToken,
        "tipo_usuario":tipoUsuario
    };
}
