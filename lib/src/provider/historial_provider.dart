import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/src/api/enviroment.dart';
import 'package:flutter_application_3/src/model/historial_de_tratamiento.dart';
import 'package:flutter_application_3/src/model/paciente.dart';
import 'package:flutter_application_3/src/model/tratamiento.dart';
import 'package:flutter_application_3/src/model/user.dart';
import 'package:flutter_application_3/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class HistorialProvider extends ChangeNotifier {
  final String _url = Enviroment.API_Tesis;

  final String _api = '/historialtratamientos';

  String _message = '';
  //String? _token; // Agregamos un campo para almacenar el mensaje

  String get message => _message;
  // String? get token => _token; // Getter para acceder al mensaje

  void setMessage(String message) {
    _message = message;
  }

  BuildContext? context;
  User? token;
  SharedPref sharedPref = SharedPref();

  Future<void>? init(BuildContext context, User token) async {
    this.context = context;
    this.token = token;
  }
  Future<List<Historial>> listarHistorial(Paciente paciente) async {
    try {
      Uri url = Uri.http(_url, '$_api/crear/${paciente.idPaciente}');
      if (token!.token == null) {
        throw Exception('Token de autenticación no disponible');
      }
      Map<String, String> headers = {
        'Content-type': 'application/json',
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesion expirada');
        SharedPref().logout(context!, token?.id as String?);
      }

      final data = json.decode(res.body);
      // Verifica si la respuesta es una lista o un objeto con una propiedad que contiene la lista
      if (data is List<dynamic>) {
        Historial historial = Historial.fromJsonList(data);
        return historial.toList;
      } else if (data != null && data is Map<String, dynamic> && data.containsKey('data')) {
        // Suponiendo que el objeto contiene una propiedad 'data' con la lista

        List<dynamic> historialList = data['data'];
        Historial historial = Historial.fromJsonList(historialList);
        return historial.toList;
      } else {
        throw Exception('Respuesta inesperada de la API');
      }
    } catch (e) {
      print('Error:$e');
      return [];
    }
  }

  Future<List<Historial>> obtenerHistorial(Tratamiento tratamiento) async {
    try {
      Uri url = Uri.http(_url, '$_api/obtenerHistorial/${tratamiento.idTratamiento}');
      print('$url');
      if (token!.token == null) {
        throw Exception('Token de autenticación no disponible');
      }
      Map<String, String> headers = {
        'Content-type': 'application/json',
      };
      final res = await http.get(url, headers: headers);
      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesion expirada');
        SharedPref().logout(context!, token?.id as String?);
      }
      final data = json.decode(res.body);
      // Verifica si la respuesta es una lista o un objeto con una propiedad que contiene la lista
      if (data is List<dynamic>) {
        Historial historial = Historial.fromJsonList(data);
        return historial.toList;
      } else if (data != null && data is Map<String, dynamic> && data.containsKey('data')) {
        // Suponiendo que el objeto contiene una propiedad 'data' con la lista

        List<dynamic> historialList = data['data'];
        Historial historial = Historial.fromJsonList(historialList);
        return historial.toList;
      } else {
        throw Exception('Respuesta inesperada de la API');
      }
    } catch (e) {
      print('Error:$e');
      return [];
    }
  }
}
