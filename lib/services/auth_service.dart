import 'dart:convert';
import 'package:CAAPMI/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import 'package:CAAPMI/models/login_response.dart';
import 'package:CAAPMI/global/environment.dart';

class AuthService with ChangeNotifier{

  late Usuario usuario;
  bool _autenticando = false;

  // Create storage
  final _storage = const FlutterSecureStorage();

  bool get autenticando => this._autenticando;

  set autenticando( bool valor){
    this._autenticando = valor;
    notifyListeners();
  }

  //getters del token
  static Future<String?> getToken() async{
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

   static Future<void> deleteToken() async{
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  } 

  Future<bool> login( String email, String password) async{

    autenticando = true;
    
    final data = {
      'email'   : email,
      'password': password
    };

    final uri = Uri.https(Environment.apiUrl,'/api/login');

    final resp = await http.post
      (
        uri,
        body: jsonEncode( data ),
        headers: {
          'Content-Type': 'application/json'
        }
    );

    autenticando = false;
    
    if( resp.statusCode == 200 ){
      try{
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse.usuario;
        await _guardarToken(loginResponse.token);
        await _guardarCredenciales(email,password);
        return true;
      }catch (e){
        return false;
      }
    }else{
      return false;
    }
  }

  
  Future register( String nombre, String email, String password) async{

      this.autenticando = true;
  
      final data = {
        'nombre'  : nombre,
        'email'   : email,
        'password': password,

      };
      final uri = Uri.https('${Environment.apiUrl}','/api/login/new');

      final resp = await http.post
      (
        uri,
        body: jsonEncode( data ),
        headers: {
          'Content-Type': 'application/json'
        }
      );

      autenticando = false;

      if( resp.statusCode == 200){
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse.usuario;
        await _guardarToken(loginResponse.token);
        return true;
      }else{
        final respBoyd = jsonDecode(resp.body);
        return respBoyd['msg'];
    }
  }

  Future isLoggedIn() async{

    final token = await this._storage.read(key: 'token');
    if(token == null ) return false;

    final uri = Uri.https(Environment.apiUrl,'/api/login/renew');

    final resp = await http.get
    (
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token
      }
    );

    if( resp.statusCode == 200){
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    }else{
      logout();
      return false;
    }

  }

  Future _guardarToken( String token ) async {
    return await _storage.write(key: 'token', value: token);
  }


  Future _guardarCredenciales(String usuario, String password) async {
    await _storage.write(key: 'user', value: usuario);
    return await _storage.write(key: 'pass', value: password);
  }

  Future<List<String>?> getCredenciales() async{
      final user = await _storage.read(key: 'user');
      final pass = await _storage.read(key: 'pass');
      if(user == null || pass == null) return [];
      return List<String>.from([user,pass]);
  }
  Future logout( ) async {
    await _storage.delete(key: 'token');
  }

}