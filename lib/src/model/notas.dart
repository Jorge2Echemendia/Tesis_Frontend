import 'dart:convert';

Notas responseApiFromJson(String str) => Notas.fromJson(json.decode(str));

String responseApiToJson(Notas data) => json.encode(data.toJson());

class Notas {
  String? idNotas;
  String? nombreDeNotas;
  String? motivo;
  String? contenido;
  int? frecuencia;
  DateTime? horaProgramada;
  String? tiempoMaximoDia;
  bool? recordatorio;
  bool? recordatorioContinuo;
  String? idUsuario;
  String? idPaciente;
  List<Notas> toList = [];

  Notas({
    this.idNotas,
    required this.nombreDeNotas,
    required this.motivo,
    required this.contenido,
    required this.frecuencia,
    required this.horaProgramada,
    required this.tiempoMaximoDia,
    required this.recordatorio,
    required this.recordatorioContinuo,
    this.idUsuario,
    this.idPaciente,
  });

  factory Notas.fromJson(Map<String, dynamic> json) => Notas(
        idNotas: json["_id"],
        nombreDeNotas: json["nombre_notas"],
        motivo: json["motivo"],
        contenido: json["contenido"],
        frecuencia: json["frecuencia"] as int,
        horaProgramada: DateTime.parse(json["hora_programada"]).subtract(const Duration(hours: 5)),
        tiempoMaximoDia: json["tiempo_de_intervalo"],
        recordatorio:json["recordatorio"],
        recordatorioContinuo:json["recordatorio_continuo"],
        idUsuario: json["id_usuario"],
        idPaciente: json["id_paciente"],
      );

  Notas.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      Notas paciente = Notas.fromJson(item);
      toList.add(paciente);
    }
  }

  Map<String, dynamic> toJson() => {
        "_id": idNotas,
        "nombre_notas": nombreDeNotas,
        "motivo": motivo,
        "contenido": contenido,
        "frecuencia": frecuencia,
        "hora_programada": horaProgramada!
            .subtract(const Duration(hours: 5))
            .toUtc()
            .toIso8601String(),
        "tiempo_de_intervalo": tiempoMaximoDia,
        "recordatorio":recordatorio,
        "recordatorio_continuo":recordatorioContinuo,
        "id_usuario": idUsuario,
        "id_paciente": idPaciente,
      };
}
