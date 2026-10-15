// To parse this JSON data, do
//
//     final cola = colaFromJson(jsonString);

import 'dart:convert';

Map<String, Cola> colaFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, Cola>(k, Cola.fromJson(v)));

String colaToJson(Map<String, Cola> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Cola {
    String? id;
    final String idPaciente;
    int posicion;

    Cola({
        required this.idPaciente,
        required this.posicion,
    });

    factory Cola.fromJson(Map<String, dynamic> json) => Cola(
        idPaciente: json["idPaciente"],
        posicion: json["posicion"],
    );

    Map<String, dynamic> toJson() => {
        "idPaciente": idPaciente,
        "posicion": posicion,
    };
}
