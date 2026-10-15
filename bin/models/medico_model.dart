// To parse this JSON data, do
//
//     final medico = medicoFromJson(jsonString);

import 'dart:convert';

Map<String, Medico> medicoFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, Medico>(k, Medico.fromJson(v)));

String medicoToJson(Map<String, Medico> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Medico {
    String? id;
    final String especialidad;
    final String nombre;

    Medico({
        required this.especialidad,
        required this.nombre,
    });

    factory Medico.fromJson(Map<String, dynamic> json) => Medico(
        especialidad: json["especialidad"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "especialidad": especialidad,
        "nombre": nombre,
    };
}