import 'dart:convert';
import 'package:CAAPMI/models/diagnosticos_response.dart';
import 'package:CAAPMI/models/eps_response.dart';
import 'package:CAAPMI/models/localidad_response.dart';
import 'package:CAAPMI/models/regimen_response.dart';
import 'package:CAAPMI/services/auth_service.dart';
import 'package:CAAPMI/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:CAAPMI/global/environment.dart';

class UtilsService with ChangeNotifier{


  Future<List<LocalidadesModel>> getLocalidades() async{

    final token = await AuthService.getToken();

    if(token != null){
      final uri = Uri.https(Environment.apiUrl,'/api/utils/localidades');

      final resp = await http.get(
        uri,
        headers: {
          'x-token': token
        }
      );

      if( resp.statusCode == 200){
        final loginResponse = localidadesResponseFromJson(resp.body);
        loginResponse.localidades.forEach((loc) async {
          await DBProvider.db.insertLocalidad(loc);
        });
        return loginResponse.localidades;
      }else{
        return [];
      }


    }else{
      return [];
    }
  }

  Future<List<RegimenModel>> getRegimenes() async {

     final token = await AuthService.getToken();

    if(token != null){
      final uri = Uri.https(Environment.apiUrl,'/api/utils/regimen');

      final resp = await http.get(
        uri,
        headers: {
          'x-token': token
        }
      );

      if( resp.statusCode == 200){
        final regimenResponse = regimenesResponseFromJson(resp.body);
        regimenResponse.regimen.forEach((reg) async {
          await DBProvider.db.insertRegimenes(reg);
        });
        return regimenResponse.regimen;
      }else{
        return [];
      }
    }else{
      return [];
    } 
  }


  Future<List<DiagnosticoModel>> getDiagnosticos() async {

     final token = await AuthService.getToken();

    if(token != null){
      final uri = Uri.https(Environment.apiUrl,'/api/utils/cie10');

      final resp = await http.get(
        uri,
        headers: {
          'x-token': token
        }
      );

      if( resp.statusCode == 200){
        final diagnosticosResponse = diagnosticosResponseFromJson(resp.body);
        print("lenght diag ${diagnosticosResponse.diagnosticos.length}");
        diagnosticosResponse.diagnosticos.forEach((diag) async {
          await DBProvider.db.insertDiagnosticos(diag);
        });
        return diagnosticosResponse.diagnosticos;
      }else{
        return [];
      }
    }else{
      return [];
    } 
  }

  Future<List<EpsModel>> getEps() async {

     final token = await AuthService.getToken();

    if(token != null){
      final uri = Uri.https(Environment.apiUrl,'/api/utils/eps');

      final resp = await http.get(
        uri,
        headers: {
          'x-token': token
        }
      );

      if( resp.statusCode == 200){
        final epsresponse = epsResponseFromJson(resp.body);
        epsresponse.eps.forEach((eps) async {
          await DBProvider.db.insertEps(eps);
        });
        return epsresponse.eps;
      }else{
        return [];
      }
    }else{
      return [];
    } 
  }
}