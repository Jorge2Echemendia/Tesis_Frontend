import 'dart:convert';

HistorialNotas responseApiFromJson(String str) => HistorialNotas.fromJson(json.decode(str));

String responseApiToJson(HistorialNotas data) => json.encode(data.toJson());

class HistorialNotas {
    String ?idHistorialNotas;
    DateTime? fechas;
    DateTime ?ultimaFecha;
    String ?idNotas;
    String ?idPaciente;
    List<HistorialNotas>toList=[];

    HistorialNotas({
        this.idHistorialNotas,
        required this.fechas,
        required this.ultimaFecha,
        this.idNotas,
        this.idPaciente,
    });

    factory HistorialNotas.fromJson(Map<String, dynamic> json) => HistorialNotas(
        idHistorialNotas: json["_id"],
        fechas: json["fechas"] != null 
        ? DateTime.parse(json["fechas"])
            .toLocal()
        : null,
        ultimaFecha:json["ultima_fecha"] != null 
        ? DateTime.parse(json["ultima_fecha"])
            .toLocal()
        : null,
        idNotas: json["id_notas"],
        idPaciente: json["id_paciente"],
    );

        HistorialNotas.fromJsonList(List<dynamic> jsonList ){
    for (var item in jsonList) {
      HistorialNotas historialNotas =HistorialNotas.fromJson(item);
      toList.add(historialNotas);
    }
  }


    Map<String, dynamic> toJson() => {
        "_id": idHistorialNotas,
        "fechas": fechas?.toUtc().toIso8601String(),
        "ultima_fecha":  ultimaFecha?.toUtc().toIso8601String(),
        "id_notas": idNotas,
        "id_paciente": idPaciente,
    };
}
