import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/src/api/enviroment.dart';
import 'package:flutter_application_3/src/model/configuracion.dart';
import 'package:flutter_application_3/src/model/paciente.dart';
import 'package:flutter_application_3/src/model/response_api.dart';
import 'package:flutter_application_3/src/model/user.dart';
import 'package:flutter_application_3/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ConfiguracionProvider extends ChangeNotifier {
  final String _url = Enviroment.API_Tesis;

  final String _api = '/configuracion';

  String _message = '';
  //String? _token; // Agregamos un campo para almacenar el mensaje

  String get message => _message;
  SharedPref sharedPref = SharedPref();
  // String? get token => _token; // Getter para acceder al mensaje

  void setMessage(String message) {
    _message = message;
  }

  BuildContext? context;
  User? token;

  Future<void>? init(BuildContext context, User token) async {
    this.context = context;
    this.token = token;
  }

  Future<ResponseApi?> createConfiguracion(Configuracion configuracion) async {
    print('User:${token?.toJson()}');
    try {
      Uri url = Uri.http(_url, '$_api/crear');
      String bodyParams = json.encode(configuracion);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${token!.token!.trim()}',
      };
      final res = await http.post(url, headers: headers, body: bodyParams);
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

  Future<List<Configuracion>> listarConfiguracion() async {
    try {
      Uri url = Uri.http(_url, '$_api/listarConfiguraciones');
      if (token!.token == null) {
        throw Exception('Token de autenticación no disponible');
      }
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${token!.token!.trim()}',
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesion expirada');
        SharedPref().logout(context!, token?.id as String?);
      }

      final data = json.decode(res.body);

      // Verifica si la respuesta es una lista o un objeto con una propiedad que contiene la lista
      if (data is List<dynamic>) {
        Configuracion configuracion = Configuracion.fromJsonList(data);
        return configuracion.toList;
      } else if (data is Map<String, dynamic> || data.containsKey('data')) {
        // Suponiendo que el objeto contiene una propiedad 'data' con la lista

        List<dynamic> configuracionList = data['data'];
        Configuracion configuracion =
            Configuracion.fromJsonList(configuracionList);
        print('Lista:${configuracionList.toList()}');
        return configuracion.toList;
      } else {
        throw Exception('Respuesta inesperada de la API');
      }
    } catch (e) {
      print('Error:$e');
      print('AS:${token!.toJson()}');
      return [];
    }
  }

Future<List<Configuracion>> listarClienteConfiguracion(
    Paciente paciente) async {
  try {
    if (token == null || token!.token == null) {
      throw Exception('Token no encontrado o inválido');
    }

    Uri url = Uri.http(_url, '$_api/listarConfiguracion/${paciente.idPaciente}');
    print('$url');
    
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer ${token!.token!.trim()}',
    };

    final res = await http.get(url, headers: headers);

    if (res.statusCode == 401) {
      Fluttertoast.showToast(msg: 'Sesión expirada');
      SharedPref().logout(context!, token?.id as String?);
    }

    final data = json.decode(res.body);

    if (data is List<dynamic>) {
      Configuracion configuracion = Configuracion.fromJsonList(data);
      return configuracion.toList;
    } else if (data is Map<String, dynamic> || data.containsKey('data')) {
      List<dynamic> configuracionList = data['data'];
      Configuracion configuracion = Configuracion.fromJsonList(configuracionList);
      return configuracion.toList;
    } else {
      throw Exception('Respuesta inesperada de la API');
    }
  } catch (e) {
    print('Error al obtener cliente configuración: $e');
    return [];
  }
}

  Future<ResponseApi?> modificarConfiguracion(
      Configuracion configuracion) async {
    try {
      Uri url = Uri.http(_url,
          '$_api/modificarConfiguracion/${configuracion.idConfiguracion}');
      String bodyParams = json.encode(configuracion);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${token!.token!.trim()}'
      };
      final res = await http.put(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      print('Respuesta2:$data');
      ResponseApi responseApi = ResponseApi.fromJson(data);
      if (responseApi.success == true) {
        setMessage(responseApi
            .msg!); // Actualizamos el mensaje si la operación fue exitosa
      } else {
        setMessage(responseApi
            .msg!); // También actualizamos el mensaje en caso de error
      }
      //print('$_token');
      return responseApi;
    } catch (e) {
      print('Error:$e');
    }
    return null;
  }

  Future<ResponseApi?> eliminarConfiguracion(
      Configuracion configuracion) async {
    try {
      Uri url = Uri.http(
          _url, '$_api/eliminarConfiguracion/${configuracion.idConfiguracion}');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${token!.token!.trim()}'
      };
      final res = await http.delete(url, headers: headers);
      final data = json.decode(res.body);
      //_token = data["token"];
      ResponseApi responseApi = ResponseApi.fromJson(data);
      if (responseApi.success == true) {
        setMessage(responseApi
            .msg!); // Actualizamos el mensaje si la operación fue exitosa
      } else {
        setMessage(responseApi
            .msg!); // También actualizamos el mensaje en caso de error
      }
      //print('$_token');
      return responseApi;
    } catch (e) {
      print('Error:$e');
    }
    return null;
  }
}
