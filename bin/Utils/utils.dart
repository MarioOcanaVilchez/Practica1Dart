import 'dart:io';

void pulsaParaContinuar(){
  print('Pulsa para continuar...');
  stdin.readLineSync();
}

void limpiaPantalla(){
  for(int i = 0; i < 100; i++){
    print('');
  }
}