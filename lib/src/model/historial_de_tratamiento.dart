import 'dart:convert';

Historial responseApiFromJson(String str) => Historial.fromJson(json.decode(str));

String responseApiToJson(Historial data) => json.encode(data.toJson());

class Historial {
    String? idHistorial;
    DateTime? fechaAdministracion;
    DateTime ?ultimaFecha;
    String ?idTratamiento;
    List<Historial>toList=[];

    Historial({
        this.idHistorial,
        required this.fechaAdministracion,
        required this.ultimaFecha,
        this.idTratamiento,
    });

factory Historial.fromJson(Map<String, dynamic> json) => Historial(
    idHistorial: json["_id"],
    fechaAdministracion: json["fecha_administracion"] != null 
        ? DateTime.parse(json["fecha_administracion"])
        : null,
    ultimaFecha: json["ultima_fecha"] != null 
        ? DateTime.parse(json["ultima_fecha"])
        : null,
    idTratamiento: json["id_tratamiento"],
);
    Historial.fromJsonList(List<dynamic> jsonList ){
    for (var item in jsonList) {
      Historial historial =Historial.fromJson(item);
      toList.add(historial);
    }
  }

    Map<String, dynamic> toJson() => {
        "_id": idHistorial,
        "fecha_administracion":  fechaAdministracion!.toUtc().toIso8601String(),
        "ultima_fecha":  ultimaFecha!.toUtc().toIso8601String(),
        "id_tratamiento": idTratamiento,
    };
}
