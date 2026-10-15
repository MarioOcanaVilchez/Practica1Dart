// To parse this JSON data, do
//
//     final consulta = consultaFromJson(jsonString);

import 'dart:convert';

List<Consulta> consultaFromJson(String str) => List<Consulta>.from(json.decode(str).map((x) => Consulta.fromJson(x)));

String consultaToJson(List<Consulta> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Consulta {
    String? id;
    bool libre;
    final String medico;
    final int numConsulta;
    String paciente;

    Consulta({
        required this.libre,
        required this.medico,
        required this.numConsulta,
        required this.paciente,
    });

    factory Consulta.fromJson(Map<String, dynamic> json) => Consulta(
        libre: json["libre"],
        medico: json["medico"],
        numConsulta: json["numConsulta"],
        paciente: json["paciente"],
    );

    Map<String, dynamic> toJson() => {
        "libre": libre,
        "medico": medico,
        "numConsulta": numConsulta,
        "paciente": paciente,
    };
}
