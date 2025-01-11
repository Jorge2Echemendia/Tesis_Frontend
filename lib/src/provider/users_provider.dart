import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_3/src/api/enviroment.dart';
import 'package:flutter_application_3/src/model/response_api.dart';
import 'package:flutter_application_3/src/model/user.dart';
import 'package:flutter_application_3/src/utils/shared_pref.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UsersProvider extends ChangeNotifier {
  final String _url = Enviroment.API_Tesis;

  final String _api = '/usuario';

  String _message = '';
  String? _token; // Agregamos un campo para almacenar el mensaje
  String? _tokenlogin;

  String get message => _message;
  String? get token => _token; // Getter para acceder al mensaje
  String? get tokenlogin => _tokenlogin;

  void setMessage(String message) {
    _message = message;
  }

  BuildContext? context;
  User? useroriginal;
  final SharedPref _sharedPref = SharedPref();

  Future<void>? init(BuildContext context, {required User useroriginal}) async {
    this.context = context;
    this.useroriginal = useroriginal;
    useroriginal = User.fromJson(await _sharedPref.read('user') ?? {});
  }

  Future<Stream<Map<String, dynamic>>> createUserOrUpdateWithImage(
      User user, File? image) async {
    try {
      Uri url = Uri.http(_url, '$_api/registrar');
      Map<String, String> headers = {
        'Content-type': 'application/json',
      };
      Map<String, dynamic> responseData;

      if (image != null) {
        // Lógica para crear con imagen
        final request = http.MultipartRequest('POST', url);
        request.files.add(http.MultipartFile('imagen',
            http.ByteStream(image.openRead().cast()), await image.length(),
            filename: basename(image.path)));
        request.fields['usuar'] = json.encode(user);
        final response = await request.send();
        // Convertimos el Stream a un Map<String, dynamic>
        final responseBody =
            await response.stream.transform(utf8.decoder).join();
        responseData = json.decode(responseBody);
      } else {
        // Lógica para crear sin imagen
        String bodyParams = json.encode(user);
        final res = await http.post(url, headers: headers, body: bodyParams);
        responseData = json.decode(res.body);
      }

      if (responseData.containsKey("token")) {
        _token = responseData["token"];
        print('Token: $_token');
      } else {
        _token = null; // O maneja el caso en que no hay token
        print('No token received');
      }

      // Aseguramos que el token siempre se incluya en la respuesta
      return Stream.fromIterable([
        {
          'token': _token ?? 'No token received',
          'responseApi': ResponseApi.fromJson(responseData),
        }
      ]);
    } catch (e) {
      print('Error: $e');
      // Aseguramos que se retorne un objeto con el token en caso de error
      return Stream.fromIterable([
        {
          'token': 'No token available',
          'error': 'An unexpected error occurred',
          'details': e.toString(),
        }
      ]);
    }
  }

  Future<Stream<Map<String, dynamic>>> update(User user, File? image) async {
    try {
      Uri url = Uri.http(_url, '$_api/actualizar/${user.id}');
      Map<String, String> headers = {
        'Content-type': 'application/json'
      };
      Map<String, dynamic> responseData;

      if (image != null) {
        // Lógica para actualizar con imagen
        final request = http.MultipartRequest('PUT', url);
        // Agregar la imagen
        request.files.add(http.MultipartFile(
          'imagen',
          http.ByteStream(image.openRead().cast()), 
          await image.length(),
          filename: basename(image.path)
        ));
        
        // Agregar los datos del usuario
        request.fields['nombre'] = user.nombre ?? '';
        request.fields['apellido'] = user.apellido ?? '';
        request.fields['email'] = user.email ?? '';
        request.fields['telefono'] = user.telefono ?? '';
        if (user.password != null && user.password!.isNotEmpty) {
          request.fields['password'] = user.password!;
        }

        final response = await request.send();
        final responseBody = await response.stream.transform(utf8.decoder).join();
        responseData = json.decode(responseBody);
      } else {
        // Lógica para actualizar sin imagen
        Map<String, dynamic> userMap = {
          'nombre': user.nombre,
          'apellido': user.apellido,
          'email': user.email,
          'telefono': user.telefono,
        };
        // Solo incluir password si se proporcionó uno nuevo
        if (user.password != null && user.password!.isNotEmpty) {
          userMap['password'] = user.password;
        }

        final res = await http.put(
          url, 
          headers: headers, 
          body: json.encode(userMap)
        );
        responseData = json.decode(res.body);
      }

      print('Response Data: $responseData');

      if (responseData.containsKey("token")) {
        _token = responseData["token"];
      } else {
        _token = null;
        print('No token received');
      }

      return Stream.fromIterable([
        {
          'token': _token ?? 'No token received',
          'responseApi': ResponseApi.fromJson(responseData),
        }
      ]);
    } catch (e) {
      print('Error: $e');
      return Stream.fromIterable([
        {
          'token': 'No token available',
          'responseApi': ResponseApi(
            success: false,
            msg: 'Error al actualizar el usuario: $e',
            token: null,
            error: e.toString()
          )
        }
      ]);
    }
  }

  Future<ResponseApi?> login(String email, String password) async {
    try {
      Uri url = Uri.http(_url, '$_api/login');

      String bodyParams = json.encode({'email': email, 'password': password});

      Map<String, String> headers = {
        'Content-type': 'application/json',
      };

      final res = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      // _tokenlogin = data["token"];
      notifyListeners();
      ResponseApi responseApi = ResponseApi.fromJson(data);
      if (responseApi.success == true) {
        setMessage(responseApi
            .msg!); // Actualizamos el mensaje si la operación fue exitosa
      } else {
        setMessage(responseApi
            .msg!); // También actualizamos el mensaje en caso de error
      }
      return responseApi;
    } catch (e) {
      print('Error:$e');
      return null;
    }
  }

    Future<ResponseApi?> cambiarPassword(String nombre, String email, String password) async {
    try {
      Uri url = Uri.http(_url, '$_api/olvidePassword');

      String bodyParams = json.encode({'nombre':nombre,'email': email, 'password': password});

      Map<String, String> headers = {
        'Content-type': 'application/json',
      };

      final res = await http.put(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      notifyListeners();
      ResponseApi responseApi = ResponseApi.fromJson(data);
      if (responseApi.success == true) {
        setMessage(responseApi
            .msg!); // Actualizamos el mensaje si la operación fue exitosa
      } else {
        setMessage(responseApi
            .msg!); // También actualizamos el mensaje en caso de error
      }
      return responseApi;
    } catch (e) {
      print('Error:$e');
      return null;
    }
  }

  Future<ResponseApi?> updateNotificacionToken(String id, String token) async {
    try {
      Uri url = Uri.http(_url, '$_api/updateToken/${useroriginal?.id}');

      String bodyParams = json.encode({'id': id, 'token': token});

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${useroriginal!.token!.trim()}'
      };

      final res = await http.put(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      // _tokenlogin = data["token"];
      notifyListeners();
      ResponseApi responseApi = ResponseApi.fromJson(data);
      if (responseApi.success == true) {
        setMessage(responseApi
            .msg!); // Actualizamos el mensaje si la operación fue exitosa
      } else {
        setMessage(responseApi
            .msg!); // También actualizamos el mensaje en caso de error
      }
      return responseApi;
    } catch (e) {
      print('Error:$e');
      return null;
    }
  }

  Future<User?> getUser(String userid) async {
    try {
      Uri url = Uri.http(
          _url, '$_api/getUser/$userid'); // Usa el token codificado en la URL

      Map<String, String> headers = {
        'Content-type': 'application/json',
      };

      final res = await http.get(url, headers: headers);
      final data = json.decode(res.body);
      User user = User.fromJson(data);

      return user;
    } catch (e) {
      print('Error:$e');
    }
    return null;
  }

  Future<ResponseApi?> getConfirmar() async {
    try {
      print('$_token');
      if (_token == null) {
        throw Exception("No hay token disponible");
      }
      Uri url = Uri.http(_url,
          '$_api/confirmar/${Uri.encodeComponent(_token!)}'); // Usa el token codificado en la URL

      Map<String, String> headers = {
        'Content-type': 'application/json',
      };

      final res = await http.get(url, headers: headers);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      if (responseApi.success == true) {
        setMessage(responseApi
            .msg!); // Actualizamos el mensaje si la operación fue exitosa
      } else {
        setMessage(responseApi
            .msg!); // También actualizamos el mensaje en caso de error
      }
      return responseApi;
    } catch (e) {
      print('Error:$e');
    }
    return null;
  }
}
