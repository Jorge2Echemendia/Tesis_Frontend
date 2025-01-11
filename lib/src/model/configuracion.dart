import 'dart:convert';

Configuracion responseApiFromJson(String str) => Configuracion.fromJson(json.decode(str));

String responseApiToJson(Configuracion data) => json.encode(data.toJson());

class Configuracion {
    String? idConfiguracion;
    String ?tiempoMaximoDia;
    String ?afeccion;
    String ?etapa;
    bool? lente;
    bool? parche;
    
    String ?idPaciente;
    List<Configuracion>toList=[];

    Configuracion({
        this.idConfiguracion,
        required this.tiempoMaximoDia,
        required this.afeccion,
        required this.etapa,
        required this.lente,
        required this.parche,
        this.idPaciente,
    });

    factory Configuracion.fromJson(Map<String, dynamic> json) => Configuracion(
        idConfiguracion: json["_id"],
        tiempoMaximoDia: json["tiempo_maximo_dia"],
        afeccion: json["afeccion"],
        etapa: json["etapa"],
        lente: json["lente"],
        parche: json["parche"],
        idPaciente: json["id_paciente"],
    );

    Configuracion.fromJsonList(List<dynamic> jsonList ){
    for (var item in jsonList) {
      Configuracion configuracion =Configuracion.fromJson(item);
      toList.add(configuracion);
    }
  }

    Map<String, dynamic> toJson() => {
        "_id": idConfiguracion,
        "tiempo_maximo_dia": tiempoMaximoDia,
        "afeccion": afeccion,
        "etapa": etapa,
        "lente": lente,
        "parche": parche,
        "id_paciente": idPaciente,
    };
}