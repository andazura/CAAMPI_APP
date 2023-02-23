

import 'package:CAAPMI/services/db_service.dart';
import 'package:CAAPMI/services/utils_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FormController extends GetxController{

  var consecutivo = "".obs;
  var estrateegia = "PEC".obs;
  var equipo = "EQ094".obs;
  var idfamilia = "".obs;
  var localidad = "NT11".obs;

  //persoa que atiende
  var direccion = "".obs;
  var telefono = "".obs;
  
  var tipoDocumento = "CC".obs;
  var documento   = "".obs;
  var nombres     = "".obs;
  var apellidos   = "".obs;
  var fechaNacimineto = "".obs;
  var sexo = "".obs;
  var edad = "".obs;
  var regimen = "Subsidiado".obs;
  var eps = "CAPITAL SALUD".obs;
  var nacionalidad = "Colombiano".obs;
  var grupoPoblacion = "Otra población".obs;
  var tipoDiagnostico = "Impresión diagnóstica".obs;
  var peso = "".obs;
  var talla = "".obs;
  var frecuenciaC = "".obs;
  var tamhg = "".obs;
  var perimetroAbdominal = "".obs;
  var perimetroBrazo = "".obs;
  var anos = 0.0.obs;

  var personaAtiende = false.obs;
  var vacunasAlDia = false.obs;
  var tieneGluco = false.obs;
  var resGluco = "".obs;
  var codDiag = "".obs;
  var codDiag1 = "".obs;
  var codDiag2 = "".obs;
  var codDiag3 = "".obs;
  var fechaConsulta = "".obs;



  // capital salud

  var laboratorios = "No se ordenaron".obs;
  var laboratoriosenCasa = "".obs;

  var medicamentos = "No se ordenaron".obs;
  var medicamentosenCasa = "".obs;

  var aplicaTratamientos = "NA".obs;
  var tratamiento = "".obs;

  var especialidadesDiff = "NA".obs;
  var especialidad = "".obs;

  var ordenInternitsa = "NA".obs;
  var ordenPsiqui = "NA".obs;
  var ordenMedFamiliar = "NA".obs;
  var vacunacionCasa = "".obs;
  var vacunaQuien = "".obs;

  var citomapro = "".obs;
  var ordenPsico = "".obs;

  var puntajeFINDRISC = "".obs;
  var riesgoFINDRISC = "".obs;
  var ejercicio = false.obs;
  var verduras = false.obs;
  var medicacionhta =  false.obs;
  var glucosa =  false.obs;
  var antecedentes =  false.obs;
  var abuetioprimos = false.obs;
  var padrehermhijos = false.obs;


  var canalizacion_rias  = "Ruta De Promoción Y Mantenimiento De La Salud".obs;
  var tipo_atencion = "P y D".obs;
  var enfermedad_cronica = false.obs;
  var hipertension = false.obs;
  var diabetes = false.obs;
  var epoc = false.obs;
  var cancer = false.obs;
  var tipo_cancer = "".obs;
  var otra_cronica = "".obs;


  
  void saveData() async {


    final insertados = await DBProvider.db.insertRegistro();
    if(insertados > 0){
      Get.delete<FormController>();
      Get.put(FormController());
    }
    //print(insertados);
  }

  Future getDataToRegistro( BuildContext context) async {

    final utilsService = Provider.of<UtilsService>(context,listen:false);

    if( DBProvider.localidades.length == 0 ) await utilsService.getLocalidades();
    if( DBProvider.regimenes.length == 0 ) await utilsService.getRegimenes();
    if( DBProvider.eps.length == 0 ) await utilsService.getEps();
    if(! await DBProvider.db.getDiaganosticos()  ) await utilsService.getDiagnosticos();

    return true;
  }
}