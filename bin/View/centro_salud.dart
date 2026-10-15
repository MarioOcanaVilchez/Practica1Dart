import '../controller/controller.dart';
import 'dart:io';
import '../Utils/utils.dart';
void main() async{
  runApp();
}

void runApp() async{
  String op = '';
  do{
    op = pintaMenu();
    switch (op){
      case '1':
      await admitirPaciente();
      break;
      case '2':
      await liberaConsulta();
      break;
      case '3':
      await pintaCola();
      break;
      case '4':
      await pintaAllConsultas();
      break;
      case '5':
      break;
      default:
      print('Opción no existente');
      break;
    }
    if (op != '5'){
      pulsaParaContinuar();
      limpiaPantalla();
    }
  }while(op != '5');
}

String pintaMenu(){
  print('''
1. Admisión de un paciente
2. Liberar una consulta
3. Ver la cola de espera
4. Ver el estado actual de las consultas
5. Salir
''');
return preguntaPers('Introduce una opción');
}
String preguntaPers(String mensaje){
  stdout.write('$mensaje: ');
  return stdin.readLineSync() ?? '';
}
Future<void> admitirPaciente() async{
  String dni = preguntaPers('Introduce el dni');
  String idPaciente = await existePaciente(dni);
  if (idPaciente != ''){
    if (await estaPacienteEnHospital(idPaciente)) print('El paciente con dni $dni ya esta en el centro');
    else print(await aniadePacienteListas(idPaciente));
  }else {
    String nombre = preguntaPers('Introduce el nombre');
    String apellidos = preguntaPers('Introduce los apellidos');
    String sintomas = preguntaPers('Introduce los sintomas');
    if (await aniadePaciente(dni, apellidos, nombre, sintomas)){
      print('Paciente con dni $dni añadido a la base de datos');
      print(await aniadePacienteListas(await existePaciente(dni)));
    }
  }
}
Future<void> liberaConsulta() async{
  int numConsulta = int.parse(preguntaPers('Introduce el número de consulta'));
  if (await liberarConsulta(numConsulta)){
    print(await mueveCola());
  } else print('Error al liberar la consulta');
}

Future<void> pintaCola() async {
  print(await pintaLaCola());
}
Future<void> pintaAllConsultas() async{
  print(await pintaConsultas());
}
