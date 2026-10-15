import 'dart:math';

import '../models/medico_model.dart';
import '../service/firebase_service.dart';
import '../models/paciente_model.dart';
import '../models/consulta_model.dart';
import '../models/cola_model.dart';


Future<bool> aniadePaciente(String dni,String apellidos,String nombre,String sintomas) async{
  Paciente paciente = Paciente(apellidos: apellidos, dni: dni, nombre: nombre, numHistoria: generaNumHistora(await getPacientes()), sintomas: sintomas);
  String respuesta = await postPaciente(paciente);
  paciente.id = respuesta;
  return true;
}
Future<String> existePaciente(String dni) async{
  List<Paciente> pacientes = await getPacientes();
  for (var paciente in pacientes) {
    if (paciente.dni == dni) return paciente.id!;
  }
  return '';
}

Future<bool> estaPacienteEnHospital(String idPaciente) async {
  List<Consulta> consultas = await getConsultas();
  for (var consulta in consultas) {
    if (consulta.paciente == idPaciente) return true;
  }
  List<Paciente> cola = await obtenCola();
  for (var paciente in cola) {
    if (paciente.id == idPaciente) return true;
  }
  return false;
}

Future<String> aniadePacienteListas(String idPaciente) async {
  Paciente paciente = (await getPaciente(idPaciente))!;
  Consulta? consulta = await consultaLibre();
  if (consulta != null){
    return await aniadePacienteConsulta(consulta, paciente);
  }
  return aniadePacienteCola(paciente);
}

Future<String> aniadePacienteConsulta(Consulta consulta, Paciente paciente) async{
  consulta.libre = false;
  consulta.paciente = paciente.id!;
  if (await addPacienteConsulta(consulta, paciente)) return 'El paciente ${paciente.nombre} ${paciente.apellidos} ya puede pasar\nSe le ha asignado la consulta ${consulta.numConsulta} ya puede pasar\nLe atendera ${(await getMedico(consulta.medico)).nombre}';
  else return 'Error al añadir el paciente a la consulta';
}

Future<List<Paciente>> obtenCola() async{
  List<Paciente> pacientes = [];
  List<Cola> cola = await getCola();
  for (var paciente in cola) {
    Paciente temp = (await getPaciente(paciente.idPaciente))!;
    temp.posCola = paciente.posicion;
    pacientes.add(temp);
  }
  return pacientes;
}

Future<String> aniadePacienteCola(Paciente paciente) async{
  paciente.posCola = (await obtenCola()).length + 1;
  if (await postCola(Cola(idPaciente: paciente.id!, posicion: paciente.posCola!))) return 'Paciente en la posición ${paciente.posCola} de la cola';
  else return 'Error al insertar en la cola';
}

Future<Consulta?> consultaLibre() async{
  List<Consulta> consultas = await getConsultas();
  for (var consulta in consultas) {
    if (consulta.libre) return consulta;
  }
  return null;
}
Future<bool> addPacienteConsulta(Consulta consulta, Paciente paciente) async{
  return putConsulta(consulta);
}
int generaNumHistora(List<Paciente> pacientes){
  int num = 0;
  do{
    num = Random().nextInt(9999) + 1;
  }while(estaNumHistoria(pacientes, num));
  return num;
}
Future<bool> liberarConsulta(int numConsulta) async {
  List<Consulta> consultas = await getConsultas();
  for (var consulta in consultas) {
    if (consulta.numConsulta == numConsulta) {
      consulta.paciente = '';
      consulta.libre = true;
      return putConsulta(consulta);
    }
  }
  return false;
}

bool estaNumHistoria(List<Paciente> pacientes, int numHistoria){
  for (var paciente in pacientes) {
    if (paciente.numHistoria == numHistoria) return true;
  }
  return false;
}
Future<String> mueveCola() async{
  Consulta? consulta = await consultaLibre();
  if (consulta != null){
    List<Cola> cola = await getCola();
    String idColaPacienteEntra = '';
    String idPacienteEntra = '';
    try{
      for (var paciente in cola) {
        if (paciente.posicion == 1){ 
          idPacienteEntra = paciente.idPaciente;
          idColaPacienteEntra = paciente.id!;
        } else {
          paciente.posicion = paciente.posicion - 1;
          await putCola(paciente);
        }
      }
      deleteCola(idColaPacienteEntra);
      return await aniadePacienteConsulta(consulta, (await getPaciente(idPacienteEntra))!);
    } catch(error){
      return 'La consulta ha quedado libre ya que no hay cola';
    }
  }
  return '';
}
Future<String> pintaLaCola() async{
  String resultado = '';
  List<Paciente> pacientes = await obtenCola();
  resultado += 'Ahora mismo hay ${pacientes.length} pacientes esperando';
  if (pacientes.isEmpty) return resultado;
  pacientes.forEach((paciente) => resultado += '\n==== Paciente ${paciente.posCola} en la cola ====\n${paciente.pintaPaciente()}');
  return resultado;
}

Future<String> pintaConsultas() async{
  String respuesta = '';
  List<Consulta> consultas = await getConsultas();
  if (consultas.isEmpty) return 'No hay consultas en estos momentos';
  for (var consulta in consultas) {
    Medico medico = await getMedico(consulta.medico);
    Paciente? paciente = await getPaciente(consulta.paciente);
    respuesta += '\n***** Consulta: ${consulta.numConsulta} ***********\nNombre del médico: ${medico.nombre}\nEspecialidad: ${medico.especialidad}\nPaciente: ${paciente != null ? '${paciente.nombre} ${paciente.apellidos}\nNum_historia: ${paciente.numHistoria}' : 'No hay paciente'} \n';
  }
  return respuesta;
}