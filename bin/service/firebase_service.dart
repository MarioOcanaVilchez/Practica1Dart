import 'dart:convert';
import '../models/consulta_model.dart';
import '../models/medico_model.dart';
import '../models/paciente_model.dart';
import '../models/cola_model.dart';
import 'package:http/http.dart' as http;

final String url_medicos = 'https://centrosaludmartos-83b5e-default-rtdb.europe-west1.firebasedatabase.app/medicos';
final String url_pacientes = 'https://centrosaludmartos-83b5e-default-rtdb.europe-west1.firebasedatabase.app/pacientes';
final String url_consultas = 'https://centrosaludmartos-83b5e-default-rtdb.europe-west1.firebasedatabase.app/consultas';
final String url_cola = 'https://centrosaludmartos-83b5e-default-rtdb.europe-west1.firebasedatabase.app/cola';



Future<List<Medico>> getMedicos() async{
  List<Medico> medicos = [];
  try{
    var response = await http.get(Uri.parse('$url_medicos.json'));
    if (response.statusCode != 200){
      print('Error http ${response.statusCode}');
      throw Error();
    }
    Map<String,dynamic> data = jsonDecode(response.body);
    data.forEach((clave,valor){
      Medico temp = Medico.fromJson(valor);
      temp.id = clave;
      medicos.add(temp);
    });
    return medicos;
  }catch(error){
    return medicos;
  }
}
Future<Medico> getMedico(String id) async{
  try{
    var response = await http.get(Uri.parse('$url_medicos/$id.json'));
    if (response.statusCode != 200){
      print('Error http ${response.statusCode}');
      throw Error();
    }
    Medico medico = Medico.fromJson(jsonDecode(response.body));
    medico.id = id;
    return medico;
  }catch(error){
    throw Error();
  }
}
Future<List<Paciente>> getPacientes() async{
List<Paciente> pacientes = [];
try{
    var response = await http.get(Uri.parse('$url_pacientes.json'));
    if (response.statusCode != 200){
      print('Error http ${response.statusCode}');
      throw Error();
    }
    Map<String,dynamic> data = jsonDecode(response.body);
    data.forEach((clave,valor){
      Paciente temp = Paciente.fromJson(valor);
      temp.id = clave;
      pacientes.add(temp);
    });
    return pacientes;
  }catch(error){
    throw Error();
  }
}
Future<Paciente?> getPaciente(String id) async{
  try{
    var response = await http.get(Uri.parse('$url_pacientes/$id.json'));
    if (response.statusCode != 200){
      print('Error http ${response.statusCode}');
      throw Error();
    }
    Paciente paciente = Paciente.fromJson(jsonDecode(response.body));
    paciente.id = id;
    return paciente;
  }catch(error){
    return null;
  }
}
Future<String> postPaciente(Paciente paciente)async {
  try{
    var response = await http.post(
      Uri.parse('$url_pacientes.json'),
      body: jsonEncode(paciente.toJson())
    );
    if (response.statusCode != 200) throw Error();
    return jsonDecode(response.body)['name'];
  }catch(error){
    throw Error();
  }
}
Future<List<Consulta>> getConsultas() async{
  List<Consulta> consultas = [];
  try{
    var response = await http.get(Uri.parse('$url_consultas.json'));
    if (response.statusCode != 200){
      print('Error http ${response.statusCode}');
      throw Error();
    }
    Map<String,dynamic> data = jsonDecode(response.body);
    data.forEach((clave,valor){
      Consulta temp = Consulta.fromJson(valor);
      temp.id = clave;
      consultas.add(temp);
    });
    return consultas;
  }catch(error){
    throw error;
  }
}
Future<bool> putConsulta(Consulta consulta) async {
  var response = await http.put(Uri.parse('$url_consultas/${consulta.id}.json'),
  body: jsonEncode(consulta.toJson()));
  if (response.statusCode != 200) print('!!!Error http ${response.statusCode}\n');
  return response.statusCode == 200;
}

Future<List<Cola>> getCola() async{
  List<Cola> cola = [];
  try{
    var response = await http.get(Uri.parse('$url_cola.json'));
    if (response.statusCode != 200){
      print('Error http ${response.statusCode}');
      throw Error();
    }
    if (jsonDecode(response.body) == null) return cola;
    Map<String,dynamic> data = jsonDecode(response.body);
    data.forEach((clave,valor){
      Cola temp = Cola.fromJson(valor);
      temp.id = clave;
      cola.add(temp);
    });
    cola.sort((Cola cola1, Cola cola2) => cola1.posicion < cola2.posicion ? -1 : 1);
    return cola;
  }catch(error){
    throw error;
  }
}
Future<bool> postCola(Cola cola) async{
  var response = await http.post(
    Uri.parse('$url_cola.json'),
    body: jsonEncode(cola.toJson()));
  return response.statusCode == 200;
}
Future<bool> putCola(Cola cola) async{
  var response = await http.put(Uri.parse('$url_cola/${cola.id}.json'),
  body: jsonEncode(cola.toJson()));
  return response.statusCode == 200;
}
Future<bool> deleteCola(String id) async{
  var response = await http.delete(Uri.parse('$url_cola/${id}.json'));
  return response.statusCode == 200;
}