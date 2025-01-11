import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/src/api/enviroment.dart';
import 'package:flutter_application_3/src/model/historial_de_notas.dart';
import 'package:flutter_application_3/src/model/notas.dart';
import 'package:flutter_application_3/src/model/paciente.dart';
import 'package:flutter_application_3/src/model/response_api.dart';
import 'package:flutter_application_3/src/model/user.dart';
import 'package:flutter_application_3/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class NotasProvider {
  final String _url = Enviroment.API_Tesis;

  final String _api = '/notas';

  String _message = '';
  //String? _token; // Agregamos un campo para almacenar el mensaje

  String get message => _message;
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

  Future<ResponseApi?> create(Notas notas, Paciente paciente) async {
    try {
      print('${paciente.idPaciente}');
      Uri url = Uri.http(_url, '$_api/crearNota/${paciente.idPaciente}');
      String bodyParams = json.encode(notas);
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

  Future<List<Notas>> listar(Paciente paciente) async {
    try {
      Uri url = Uri.http(_url, '$_api/listar/${paciente.idPaciente}');
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
        Notas notas = Notas.fromJsonList(data);
        return notas.toList;
      } else if (data is Map<String, dynamic> || data.containsKey('data')) {
        // Suponiendo que el objeto contiene una propiedad 'data' con la lista

        List<dynamic> notasList = data['data'];
        Notas notas = Notas.fromJsonList(notasList);
        return notas.toList;
      } else {
        throw Exception('Respuesta inesperada de la API');
      }
    } catch (e) {
      print('Error:$e');
      return [];
    }
  }

  Future<List<HistorialNotas>> listarHistorial(Paciente paciente) async {
    try {
      Uri url = Uri.http(_url, '$_api/historialNotas/${paciente.idPaciente}');
      Map<String, String> headers = {
        'Content-type': 'application/json',
      };
      final res = await http.get(url, headers: headers);
      final data = json.decode(res.body);

      // Verifica si la respuesta es una lista o un objeto con una propiedad que contiene la lista
      if (data is List<dynamic>) {
        HistorialNotas notashistorial = HistorialNotas.fromJsonList(data);
        return notashistorial.toList;
      } else if (data is Map<String, dynamic> || data.containsKey('data')) {
        // Suponiendo que el objeto contiene una propiedad 'data' con la lista

        List<dynamic> notashistorialList = data['data'];
        HistorialNotas notashistorial =
            HistorialNotas.fromJsonList(notashistorialList);
        return notashistorial.toList;
      } else {
        throw Exception('Respuesta inesperada de la API');
      }
    } catch (e) {
      print('Error:$e');
      return [];
    }
  }

  Future<ResponseApi?> modificar(Notas notas) async {
    try {
      Uri url = Uri.http(_url, '$_api/modificarNota/${notas.idNotas}');
      String bodyParams = json.encode(notas);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${token!.token!.trim()}'
      };
      final res = await http.put(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
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

  Future<ResponseApi?> eliminar(Notas notas) async {
    try {
      Uri url = Uri.http(_url, '$_api/eliminarNota/${notas.idNotas}');
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
