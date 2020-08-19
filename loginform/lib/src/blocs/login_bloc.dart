import 'dart:async';

import 'package:loginform/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //Recuperar datos del Stream
  Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);

  Stream<bool> get formValiteStream =>
   Observable.combineLatest2(emailStream, passwordStream, (e,p)=> true);

  //Insertar valores al Strea,
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //obtener el ultimo valor ingresago a los streams
  String get email  => _emailController.value;
  String get password => _passwordController.value;
  

  dispose(){
    _emailController.close();
    _passwordController.close();
  }

}