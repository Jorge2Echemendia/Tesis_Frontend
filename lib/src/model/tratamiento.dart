import 'dart:convert';

Tratamiento tratamientoFromJson(String str) =>
    Tratamiento.fromJson(json.decode(str));

String tratamientoToJson(Tratamiento data) => json.encode(data.toJson());

class Tratamiento {
  String? idTratamiento;
  String? nombreTratamiento;
  String? nombreMedicamento;
  String? descripcion;
  int? frecuencia;
  DateTime? horaProgramada;
  String? idPaciente;
  String? idUsuario;
  String? tiempoDeLaMedicacion;
  String? etapa;
  bool? lente;
  bool? parche;
  List<Tratamiento> toList = [];

  Tratamiento({
    this.idTratamiento,
    required this.nombreTratamiento,
    required this.nombreMedicamento,
    required this.descripcion,
    required this.frecuencia,
    this.horaProgramada,
    this.idPaciente,
    this.idUsuario,
    required this.tiempoDeLaMedicacion,
    required this.etapa,
    required this.lente,
    required this.parche,
  });

  factory Tratamiento.fromJson(Map<String, dynamic> json) => Tratamiento(
        idTratamiento: json["_id"],
        nombreTratamiento: json["nombre_tratamiento"],
        nombreMedicamento: json["nombre_medicamento"],
        descripcion: json["descripcion"],
        frecuencia: json["frecuencia"] as int?,
        horaProgramada: json["hora_programada"] != null 
            ? DateTime.parse(json["hora_programada"])
            : null,
        idPaciente: json["id_paciente"],
        idUsuario: json["id_usuario"],
        tiempoDeLaMedicacion: json["tiempo_de_la_medicacion"],
        etapa: json["etapa"],
        lente: json["lente"],
        parche: json["parche"],
      );

  Tratamiento.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      Tratamiento tratamiento = Tratamiento.fromJson(item);
      toList.add(tratamiento);
    }
  }
  Map<String, dynamic> toJson() => {
        "_id": idTratamiento,
        "nombre_tratamiento": nombreTratamiento,
        "nombre_medicamento": nombreMedicamento,
        "descripcion": descripcion,
        "frecuencia": frecuencia,
        "hora_programada": horaProgramada?.subtract(const Duration(hours: 5)).toUtc().toIso8601String(),
        "id_paciente": idPaciente,
        "id_usuario":idUsuario,
        "tiempo_de_la_medicacion": tiempoDeLaMedicacion,
        "etapa": etapa,
        "lente": lente,
        "parche": parche,
      };
}
