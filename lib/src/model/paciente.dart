import 'dart:convert';

import 'package:intl/intl.dart';

Paciente pacienteApiFromJson(String str) => Paciente.fromJson(json.decode(str));
String pacienteApiToJson(Paciente data) => json.encode(data.toJson());

class Paciente {
  String? idPaciente;
  String? nombre;
  String? apellido;
  String? apellidoSegundo;
  DateTime? fechaNacimiento;
  String? afeccion;
  String? etapaDeTratamiento;
  String? idUsuario;
  bool? lente;
  bool? parche;
  String? tipoLente;
  String? tipoParche;
  String? horasParche;
  String? observacionesParche;
  DateTime? fechaParche;
  String? graduacionLente;
  DateTime? fechaLente;
  DateTime? fechaDiagnostico;
  String? gradoMiopia;
  String? examenes;
  String? recomendaciones;
  String? correccionOptica;
  String? ejerciciosVisuales;
  String? cambioOptico;
  String? consejosHigiene;
  String? cirujia;
  DateTime? cirujiaFecha;
  String? cirujiaResultados;
  String? progreso;
  List<Paciente> toList=[];

  Paciente({
    this.idPaciente,
    required this.nombre,
    required this.apellido,
    required this.apellidoSegundo,
    required this.fechaNacimiento,
    required this.afeccion,
    required this.etapaDeTratamiento,
    this.idUsuario,
    required this.lente,
    required this.parche,
    required this.tipoLente,
    required this.tipoParche,
    required this.horasParche,
    required this.observacionesParche,
    required this.fechaParche,
    required this.graduacionLente,
    required this.fechaLente,
    required this.fechaDiagnostico,
    required this.gradoMiopia,
    required this.examenes,
    required this.recomendaciones,
    required this.correccionOptica,
    required this.ejerciciosVisuales,
    required this.cambioOptico,
    required this.consejosHigiene,
    required this.cirujia,
    required this.cirujiaFecha,
    required this.cirujiaResultados,
    required this.progreso,
  });

  factory Paciente.fromJson(Map<String, dynamic> json) => Paciente(
        idPaciente: json["_id"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        apellidoSegundo: json["apellido_segundo"],
        fechaNacimiento: DateTime.parse(json["fecha_nacimiento"]),
        afeccion: json["afeccion"],
        etapaDeTratamiento: json["etapa_de_tratamiento"],
        idUsuario: json["id_usuario"],
        lente: json["lente"],
        parche: json["parche"],
        tipoLente: json["tipo_lente"],
        tipoParche: json["tipo_parche"],
        horasParche: json["horas_parche"],
        observacionesParche: json["observaciones_parche"],
        graduacionLente: json["graduacion_lente"],
        fechaLente: DateTime.parse(json["fecha_lente"]),
        fechaParche: DateTime.parse(json["fecha_parche"]),
        fechaDiagnostico: DateTime.parse(json["fecha_diagnostico"]),
        gradoMiopia: json["grado_miopia"],
        examenes: json["examenes"],
        recomendaciones: json["recomendaciones"],
        correccionOptica: json["correcion_optica"],
        ejerciciosVisuales: json["ejercicios_visuales"],
        cambioOptico: json["cambio_optico"],
        consejosHigiene: json["consejos_higiene"],
        cirujia: json["cirujia"],
        cirujiaFecha:DateTime.parse(json["cirujia_fecha"]),
        cirujiaResultados: json["cirujia_resultados"],
        progreso: json["progreso"],
      );

    Paciente.fromJsonList(List<dynamic> jsonList ){
    for (var item in jsonList) {
      Paciente paciente =Paciente.fromJson(item);
        toList.add(paciente);
    }
  }

  Map<String, dynamic> toJson() => {
        "_id": idPaciente,
        "nombre": nombre,
        "apellido": apellido,
        "apellido_segundo": apellidoSegundo,
        "fecha_nacimiento":DateFormat("yyyy-MM-dd").format(fechaNacimiento!),
        "afeccion": afeccion,
        "etapa_de_tratamiento": etapaDeTratamiento,
        "id_usuario": idUsuario,
        "lente": lente,
        "parche": parche,
        "tipo_lente": tipoLente,
        "tipo_parche": tipoParche,
        "horas_parche": horasParche,
        "observaciones_parche": observacionesParche,
        "graduacion_lente": graduacionLente,
        "fecha_lente":DateFormat("yyyy-MM-dd").format(fechaLente!),
          "fecha_parche":DateFormat("yyyy-MM-dd").format(fechaParche!),
        "fecha_diagnostico":
            DateFormat("yyyy-MM-dd").format(fechaDiagnostico!),
        "grado_miopia": gradoMiopia,
        "examenes": examenes,
        "recomendaciones": recomendaciones,
        "correcion_optica": correccionOptica,
        "ejercicios_visuales": ejerciciosVisuales,
        "cambio_optico": cambioOptico,
        "consejos_higiene": consejosHigiene,
        "cirujia": cirujia,
        "cirujia_fecha":
            DateFormat("yyyy-MM-dd").format(cirujiaFecha!),
        "cirujia_resultados":cirujiaResultados,
        "progreso": progreso,
      };
}
