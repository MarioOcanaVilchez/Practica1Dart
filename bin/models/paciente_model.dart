// To parse this JSON data, do
//
//     final paciente = pacienteFromJson(jsonString);

import 'dart:convert';

Map<String, Paciente> pacienteFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, Paciente>(k, Paciente.fromJson(v)));

String pacienteToJson(Map<String, Paciente> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Paciente {
    String? id;
    final String apellidos;
    final String dni;
    final String nombre;
    final int numHistoria;
    final String sintomas;
    int? posCola;

    Paciente({
        required this.apellidos,
        required this.dni,
        required this.nombre,
        required this.numHistoria,
        required this.sintomas,
    });

    factory Paciente.fromJson(Map<String, dynamic> json) => Paciente(
        apellidos: json["apellidos"],
        dni: json["dni"],
        nombre: json["nombre"],
        numHistoria: json["numHistoria"],
        sintomas: json["sintomas"],
    );

    Map<String, dynamic> toJson() => {
        "apellidos": apellidos,
        "dni": dni,
        "nombre": nombre,
        "numHistoria": numHistoria,
        "sintomas": sintomas,
    };

    String pintaPaciente(){
      return '****** Datos de paciente ******\nNombre del paciente: $nombre $apellidos \nHistoria del paciente: $numHistoria\nSíntomas del paciente: $sintomas\n';
    }
}