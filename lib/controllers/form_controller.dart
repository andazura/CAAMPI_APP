

import 'package:CAAPMI/helpers/alertas.dart';
import 'package:CAAPMI/services/db_service.dart';
import 'package:CAAPMI/services/utils_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FormController extends GetxController{

  final fechaConsultaControler =  Rxn<TextEditingController>( TextEditingController());
  final fechaNacimientoControler =  Rxn<TextEditingController>( TextEditingController());
  final riesgoFINDRISCController =  Rxn<TextEditingController>( TextEditingController());
  final puntajeFINDRISCController =  Rxn<TextEditingController>( TextEditingController());

  var consecutivo = "".obs;
  var estrateegia = "PEC".obs;
  var equipo = "EQ094".obs;
  var idfamilia = "".obs;
  var localidad = "NT11".obs;

  //persoa que atiende
  var direccion = "".obs;
  var telefono = "".obs;
  
  var tipoDocumento = "Cédula ciudadanía".obs;
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
  var finalidadConsulta = "".obs;
  var codDiag1 = "".obs;
  var codDiag2 = "".obs;
  var codDiag3 = "".obs;
  var fechaConsulta = "".obs;



  // capital salud

  var laboratorios = "No se ordenaron".obs;
  var laboratoriosenCasa = "".obs;
  var desclaboratorios = "".obs;

  var medicamentos = "No se ordenaron".obs;
  var medicamentosenCasa = "".obs;
  var descmedicamentos = "".obs;

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

  var usuarioGestante = false.obs;

  final idAutoReportes = Rxn<int>();


  
  void saveData() async {

    final insertados = await DBProvider.db.insertRegistro(idAutoReportes.value);
    String mensaje = idAutoReportes.value != null ? "Registros actualizados" : "Registro guardado";
    if(insertados > 0){
      Get.delete<FormController>();
      Get.put(FormController());
      mosrtarAlerta( "Registro", mensaje);
    }
    //print(insertados);
  }

  void resetFormCtrl(){
    Get.delete<FormController>();
    Get.put(FormController());
  }

  Future getDataToRegistro( BuildContext context) async {

    final utilsService = Provider.of<UtilsService>(context,listen:false);

    if( DBProvider.localidades.length == 0 ) await utilsService.getLocalidades();
    if( DBProvider.regimenes.length == 0 ) await utilsService.getRegimenes();
    if( DBProvider.eps.length == 0 ) await utilsService.getEps();
    if(! await DBProvider.db.getDiaganosticos()  ) await utilsService.getDiagnosticos();

    return true;
  }

  Future<bool> loadRegistro(int id) async{
  
    final resp = await DBProvider.db.getReportes( 
      query: " AND repo.id_auto_reportes = '$id'",
      join: "LEFT JOIN reportes_cuidad r on r.consecutivo = repo.consecutivo"
      );
    if(resp.isEmpty) return false;

    for (final reg in resp) { 

      idAutoReportes.value =  int.tryParse( reg['id_auto_reportes'].toString() )  ;

      fechaNacimientoControler.value!.text =  reg['fecha_nacimiento'].toString();
      riesgoFINDRISCController.value!.text = reg['puntaje_findrisk'].toString();
      puntajeFINDRISCController.value!.text = reg['riesgo_findrisk'].toString();

      consecutivo.value = reg['consecutivo'].toString();
      estrateegia.value = reg['estrateegia'].toString();
      equipo.value = reg['equipo'].toString();
      idfamilia.value = reg['id_familia'].toString();
      localidad.value = reg['localidad'].toString();

      //persoa que atiende
      direccion.value = reg['direccion'].toString();
      telefono.value = reg['telefono'].toString();
      
      tipoDocumento.value = reg['tipo_cc'].toString();
      documento.value   = reg['cc'].toString();
      nombres.value     = "${reg['primer_nombre']} ${reg['segundo_nombre']}" ;
      apellidos.value   = "${reg['primer_apellido']} ${reg['segundo_apellido']}" ;
      fechaNacimineto.value = reg['fecha_nacimiento'].toString();
      sexo.value = reg['sexo'].toString();
      //edad.value = reg['eapb'].toString();
      regimen.value = reg['regimen'].toString();
      eps.value = reg['eapb'].toString();
      nacionalidad.value = reg['nacionalidad'].toString();
      grupoPoblacion.value = reg['grupo_poblacion'].toString();
      tipoDiagnostico.value = reg['tipo_diag'].toString();
      peso.value = reg['peso'].toString();
      talla.value = reg['talla'].toString();
      frecuenciaC.value = reg['frecuencia_cardiaca'].toString();
      tamhg.value = reg['tamhg'].toString();
      perimetroAbdominal.value = reg['perimetro_abfominal'].toString();
      perimetroBrazo.value = reg['perimetro_brazo'].toString();
      //anos.value = reg[''].toString();

      personaAtiende.value = reg['persona_atienede'].toString() == "true";
      vacunasAlDia.value = reg['vacunas'].toString() == "true";
      tieneGluco.value = reg['glucometria'].toString() == "true";
      resGluco.value = reg['res_glucometria'].toString();
      codDiag.value = reg['codDiag'].toString() == '' ? '0' : reg['codDiag'].toString() ;
      finalidadConsulta.value = reg['finlidad_consulta'].toString();
      codDiag1.value = reg['codDiag1'].toString() == '' ? '0' : reg['codDiag1'].toString() ;
      codDiag2.value = reg['codDiag2'].toString() == '' ? '0' : reg['codDiag2'].toString() ;
      codDiag3.value = reg['codDiag3'].toString() == '' ? '0' : reg['codDiag3'].toString() ;
      fechaConsulta.value = reg['fecha_consulta'].toString();
      fechaConsultaControler.value!.text = reg['fecha_consulta'].toString();

      // capital salud
      laboratorios.value = reg['ordena_lab'].toString();
      desclaboratorios.value = reg['desc_lab'].toString();
      laboratoriosenCasa.value = reg['lab_en_casa'].toString();

      medicamentos.value = reg['ordena_med'].toString();
      descmedicamentos.value = reg['desc_med'].toString();
      medicamentosenCasa.value = reg['med_en_casa'].toString();

      aplicaTratamientos.value = reg['prueba_tratamientos'].toString();
      tratamiento.value = reg['cual_prueba_tratamientos'].toString();

      especialidadesDiff.value = reg['otra_especialidad'].toString();
      especialidad.value = reg['cual_otra_especialidad'].toString();

      ordenInternitsa.value = reg['orden_internista'].toString();
      ordenPsiqui.value = reg['orden_psiquiatria'].toString();
      ordenMedFamiliar.value = reg['orden_med_familiar'].toString();
      vacunacionCasa.value = reg['vacunacion_casa'].toString();
      vacunaQuien.value = reg['quien_vacunacion'].toString();

      citomapro.value = reg['orden_citomapro'].toString();
      ordenPsico.value = reg['orden_psico'].toString();

      puntajeFINDRISC.value = reg['puntaje_findrisk'].toString();
      riesgoFINDRISC.value = reg['riesgo_findrisk'].toString();
      canalizacion_rias.value  = reg['canalizacion_rias'].toString();
      tipo_atencion.value = reg['tipo_atencion'].toString();
      enfermedad_cronica.value = reg['enfermedad_cronica'].toString() == "true";
      hipertension.value = reg['hipertension'].toString() == "true";
      diabetes.value = reg['diabetes'].toString() == "true";
      epoc.value = reg['epoc'].toString() == "true";
      cancer.value = reg['cancer'].toString() == "true";
      tipo_cancer.value = reg['tipo_cancer'].toString();
      otra_cronica.value = reg['otra_cronica'].toString();
      usuarioGestante.value = reg['usuario_gestante'].toString() == 'true';

    }
    return true;
  }
}