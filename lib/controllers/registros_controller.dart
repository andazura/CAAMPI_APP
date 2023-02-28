import 'dart:io';
import 'package:CAAPMI/helpers/alertas.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as ExcelPkg;
import 'package:CAAPMI/services/db_service.dart';




class RegistrosController extends GetxController{

  @override
  void onInit() {
    final date = DateTime.now();
    String fecha = "${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}";
    getReportes(query: " AND fecha_consulta = '$fecha'");
    
    super.onInit();
  }
  
  final reportes = Rxn<List<Map<String, Object?>>>();
  final reportesTmp = Rxn<List<Map<String, Object?>>>();

  getReportes( {int modoExporte = 0, String query = ''}) async{
    final resp = await DBProvider.db.getReportes( query: query );
    if( modoExporte == 1 ) return reportesTmp.value = resp;
    reportes.value = resp;
  }

  Future<int> delReport({required int idReporte }) async {
     return await DBProvider.db.delReporte( idReporte );
  }


  exportReportes( {int modo = 0 } ) async{

    final reportesDow = Rxn<List<Map<String, Object?>>>();

    reportesDow.value = modo == 0 ? reportes.value : reportesTmp.value;

    if( reportesDow.value == null || reportesDow.value!.isEmpty  ){
      
      mosrtarAlerta(Get.context!, "Error", "No hay reportes para descargar, prueba una nueva consulta");
      return;
    }
    print("El reg leng ${reportesDow.value!.length} ");
    
    Directory documentsDirectory = await getTemporaryDirectory();            
    //Create a new Excel document.
    final ExcelPkg.Workbook workbook = ExcelPkg.Workbook(2);

    final ExcelPkg.Worksheet sheet = workbook.worksheets[0];
    final ExcelPkg.Worksheet sheet2 = workbook.worksheets[1];
    ExcelPkg.Style globalStyle = workbook.styles.add('style');
    globalStyle.borders.all.lineStyle = ExcelPkg.LineStyle.thin;
    globalStyle.borders.all.color = '#0000000';

    sheet.enableSheetCalculations();


    sheet.showGridlines = true;
    sheet2.showGridlines = true;
    sheet.name = "REPORTE ATENCIONES";
    sheet2.name = "PLAN CUIDADO FAMILIAR";

    List<String> cabeceras2 = ['ID FAMILIA','SUBRED Y LOCALIDAD','ESTRATEGIA','EQUIPO','CONSECUTIVO','Fecha de la atención en salud (DD/MM/AAAA)','Dirección','Teléfono','Primer nombre','Segundo nombre','Primer apellido','Segundo apellido','Tipo de documento','Numero de Documento de identidad','Nombre del profesional que realiza la atención en salud'];
    
    List<String> cabeceras = ['ID FAMILIA','Fecha de la consulta (DD/MM/AAAA)','¿Es la persona que atiende la visita?',
    'Tipo de identificación usuario','Número de identificación del usuario','Primer Nombre','Segundo Nombre','Primer Apellido',
    'Segundo Apellido','Fecha de nacimiento usuario','EDAD AÑOS','EDAD MESES','EDAD DIAS','TOTAL DIAS','MOMENTO DE CURSO DE VIDA',
    'Sexo','Régimen de afiliación','EAPB','Nacionalidad','Grupo de población','Código de la consulta','Finalidad de la consulta',
    'Código del diagnóstico principal','Código del diagnóstico relacionado No. 1','Código del diagnóstico relacionado 2',
    'Código del diagnóstico relacionado 3','Tipo de diagnóstico principal','Personal que atiende',
    'Esquema de vacunación completo (SI/NO)','Peso (Kg)','Talla (metros) - separador por ()','Talla en CM',
    'Frecuencia Cardiaca (pulso/min)','Se toma Glucometria','Resultado de Glucometría (mg/dL)','T/A (mmHg)',
    'Calcule y relacione el IMC para la Edad Gestacional   (El IMC se calcula a partir de la semana 6 de gestación: peso (kg) / estatura (m)x 2) - En caso de no ser gestante escribir NO APLICA',
    'De acuerdo con las tablas nutricionales ¿cúal es la clasificación antropométrica de la Gestante?','Desviación estándar',
    '¿Cuál es la clasificación antoprométrica del niño? seleccione:','IMC: peso (kg) / estatura (m)x 2)',
     'Clasificación del Estado Nutricional seleccione:',
     
     
     'Perímetro abdominal','Perímetro brazo (Menores de 5 años)',
     'Orden de laboratorios (incluye tamizajes)','Toma de laboratorios en casa','MEDICAMENTOS',
     'Dispensación en casa de medicamentos','ADMINISTRACIÓN DE PRUEBA O TRATAMIENTOS FARMACOLOGICOS ',
     'Prueba / tratamiento','Orden especialidades diferentes a internista/psiquiatría /medicina familiar',
     'Cual orden de especialista','Orden Internista','Orden Psiquiatría','Orden Medicina Familiar',
     'Vacunación en casa','¿Quién?','Orden citología / mamografía / próstata','Orden Psicología',
     'Número de controles en Ruta','Clasificación nutricional','Puntaje Escala FRAMINGHAM (Tamizaje)',
     'Clasificación Riesgo Escala FRAMINGHAM (Tamizaje)','Puntaje Escala FINDRISC (Tamizaje)',
     'Clasificación Riesgo Escala FINDRISC (Tamizaje)','Canalización a RIAS',
     'Canalización a Subsistemas de Vigilancia en Salud publica','Tipo de atención','¿Usuario diagnosticado con enfermedad crónica?','HIPERTENSION','DIABETES','EPOC','CANCER','TIPO DE CÁNCER','Otra enfermedad crónica: ¿Cuál?','Usuaria gestante','Edad gestacional','FECHA ULTIMO PARTO','FUR','FPP','SEMANA 10','SEMANA 12 ','CLASIFICACION TRIMESTRE','CLASIFICACION DEL RIESGO','RIESGO_PSICOSOCIAL','RIESGO_BIOSICOSOCIAL','RIESGO_OBSTETRICO','RIESGO_TROMBOEMBOLICO','RIESGO_DEPRESION_POS_PARTO','SIFILIS GESTACIONAL ','SIFILIS CONGENITA ','MME','HEPATITIS B','VIH','CONSULTA DE CONTROL','OBSERVACIONES','SUBRED Y LOCALIDAD','ESTRATEGIA','Nombre del profesional que realiza la atención en salud'];

    sheet.getRangeByName('A1:CT1').cellStyle = globalStyle;
    sheet2.getRangeByName('A1:P1').cellStyle = globalStyle;
  
  
    for(var i = 1; i < cabeceras.length; i++ ){
        sheet.getRangeByIndex(1, i).setText(cabeceras[i-1]);
    }

    for(var i = 1; i < cabeceras2.length; i++ ){
        sheet2.getRangeByIndex(1, i).setText(cabeceras2[i-1]);
    }

  
    
     

    int row = 2;
    int row2 = 2;
    for(var i = 0; i < reportesDow.value!.length; i++){

      
      if(reportesDow.value![i]['persona_atienede'].toString() == 'true'){

        final resp = await DBProvider.db.getCuidado( query: " AND id_familia = '${reportesDow.value![i]['id_familia']}'" );
        if( resp.isNotEmpty ){
          sheet2.getRangeByName('A$row2:P$row2').cellStyle = globalStyle;
          sheet2.getRangeByIndex(row2, 1).setText( resp[i]['id_familia'].toString() );  
          sheet2.getRangeByIndex(row2, 2).setText( resp[i]['localidad'].toString() );  
          sheet2.getRangeByIndex(row2, 3).setText( resp[i]['estrateegia'].toString() );  
          sheet2.getRangeByIndex(row2, 4).setText( resp[i]['equipo'].toString() );  
          sheet2.getRangeByIndex(row2, 5).setText( resp[i]['consecutivo'].toString() );  
          sheet2.getRangeByIndex(row2, 6).setText( resp[i]['fecha_consulta'].toString() );  
          sheet2.getRangeByIndex(row2, 7).setText( resp[i]['direccion'].toString() );  
          sheet2.getRangeByIndex(row2, 8).setText( resp[i]['telefono'].toString() );  
          sheet2.getRangeByIndex(row2, 9).setText( resp[i]['primer_nombre'].toString() );  
          sheet2.getRangeByIndex(row2, 10).setText( resp[i]['segundo_nombre'].toString() );  
          sheet2.getRangeByIndex(row2, 11).setText( resp[i]['primer_apellido'].toString() );  
          sheet2.getRangeByIndex(row2, 12).setText( resp[i]['segundo_apellido'].toString() );  
          sheet2.getRangeByIndex(row2, 13).setText( resp[i]['tipo_cc'].toString() );  
          sheet2.getRangeByIndex(row2, 14).setText( resp[i]['cc'].toString() );
          row2++;
        }
      }

      sheet.getRangeByName('A$row:CT$row').cellStyle = globalStyle;
      sheet.getRangeByIndex(row, 1).setText( reportesDow.value![i]['id_familia'].toString() );  
      sheet.getRangeByIndex(row, 2).setText( reportesDow.value![i]['fecha_consulta'].toString() );  
      sheet.getRangeByIndex(row, 3).setText( _boolToStringOption(reportesDow.value![i]['persona_atienede'].toString())  );  
      sheet.getRangeByIndex(row, 4).setText( reportesDow.value![i]['tipo_cc'].toString() );  
      sheet.getRangeByIndex(row, 5).setText( reportesDow.value![i]['cc'].toString() );  
      sheet.getRangeByIndex(row, 6).setText( reportesDow.value![i]['primer_nombre'].toString() );  
      sheet.getRangeByIndex(row, 7).setText( reportesDow.value![i]['segundo_nombre'].toString() );  
      sheet.getRangeByIndex(row, 8).setText( reportesDow.value![i]['primer_apellido'].toString() );  
      sheet.getRangeByIndex(row, 9).setText( reportesDow.value![i]['segundo_apellido'].toString() );  
      sheet.getRangeByIndex(row, 10).setText( reportesDow.value![i]['fecha_nacimiento'].toString() ); 
      
      //sheet.getRangeByIndex(row, 11).setFormula('=+SIFECHA("${reportesDow.value![i]['fecha_nacimiento']}";"${reportesDow.value![i]['fecha_consulta']}";"Y")');
      sheet.getRangeByIndex(row, 11).setText( "" ); 
      sheet.getRangeByIndex(row, 12).setText( "" ); 
      sheet.getRangeByIndex(row, 13).setText( "" ); 
      sheet.getRangeByIndex(row, 14).setText( "" ); 
      sheet.getRangeByIndex(row, 15).setText( "" ); 
      //
      sheet.getRangeByIndex(row, 16).setText( reportesDow.value![i]['sexo'].toString() );  
      sheet.getRangeByIndex(row, 17).setText( reportesDow.value![i]['regimen'].toString() );  
      sheet.getRangeByIndex(row, 18).setText( reportesDow.value![i]['eapb'].toString() );  
      sheet.getRangeByIndex(row, 19).setText( reportesDow.value![i]['nacionalidad'].toString() );  
      sheet.getRangeByIndex(row, 20).setText( reportesDow.value![i]['grupo_poblacion'].toString() );  
      sheet.getRangeByIndex(row, 21).setText( reportesDow.value![i]['codigo_consulta'].toString() );  
      sheet.getRangeByIndex(row, 22).setText( reportesDow.value![i]['finlidad_consulta'].toString() );  
      sheet.getRangeByIndex(row, 23).setText( reportesDow.value![i]['codDiag'].toString() == '' ? '0': reportesDow.value![i]['codDiag'].toString() );  
      sheet.getRangeByIndex(row, 24).setText( reportesDow.value![i]['codDiag1'].toString() == '' ? '0': reportesDow.value![i]['codDiag1'].toString() );  
      sheet.getRangeByIndex(row, 25).setText( reportesDow.value![i]['codDiag2'].toString() == '' ? '0': reportesDow.value![i]['codDiag2'].toString() );  
      sheet.getRangeByIndex(row, 26).setText( reportesDow.value![i]['codDiag3'].toString() == '' ? '0': reportesDow.value![i]['codDiag3'].toString() );  
      sheet.getRangeByIndex(row, 27).setText( reportesDow.value![i]['tipo_diag'].toString() );  
      sheet.getRangeByIndex(row, 28).setText( "Médico (a) general" );  
      sheet.getRangeByIndex(row, 29).setText( _boolToStringOption(reportesDow.value![i]['vacunas'].toString()) );  
      sheet.getRangeByIndex(row, 30).setText( reportesDow.value![i]['peso'].toString() );  
      sheet.getRangeByIndex(row, 31).setText( reportesDow.value![i]['talla'].toString() );  
      sheet.getRangeByIndex(row, 32).setFormula( "=+AE$row*100" ); //talla cm ; 
      sheet.getRangeByIndex(row, 33).setText( reportesDow.value![i]['frecuencia_cardiaca'].toString() );  
      sheet.getRangeByIndex(row, 34).setText( _boolToStringOption(reportesDow.value![i]['glucometria'].toString()) );  
      sheet.getRangeByIndex(row, 35).setText( reportesDow.value![i]['res_glucometria'].toString() );  
      sheet.getRangeByIndex(row, 36).setText( reportesDow.value![i]['tamhg'].toString() );  

      //auto
      sheet.getRangeByIndex(row, 37).setText("");
      sheet.getRangeByIndex(row, 38).setText("");
      sheet.getRangeByIndex(row, 39).setText("");
      sheet.getRangeByIndex(row, 40).setText("");
      sheet.getRangeByIndex(row, 41).setText("");
      sheet.getRangeByIndex(row, 42).setText("");

      sheet.getRangeByIndex(row, 43).setText( reportesDow.value![i]['perimetro_abfominal'].toString() );  
      sheet.getRangeByIndex(row, 44).setText( reportesDow.value![i]['perimetro_brazo'].toString() );  
      sheet.getRangeByIndex(row, 45).setText( reportesDow.value![i]['ordena_lab'].toString() );  
      sheet.getRangeByIndex(row, 46).setText( reportesDow.value![i]['lab_en_casa'].toString() );  
      sheet.getRangeByIndex(row, 47).setText( reportesDow.value![i]['ordena_med'].toString() );  
      sheet.getRangeByIndex(row, 48).setText( reportesDow.value![i]['med_en_casa'].toString() );  
      sheet.getRangeByIndex(row, 49).setText( reportesDow.value![i]['prueba_tratamientos'].toString() );  
      sheet.getRangeByIndex(row, 50).setText( reportesDow.value![i]['cual_prueba_tratamientos'].toString() );  
      sheet.getRangeByIndex(row, 51).setText( reportesDow.value![i]['otra_especialidad'].toString() );  
      sheet.getRangeByIndex(row, 52).setText( reportesDow.value![i]['cual_otra_especialidad'].toString() );  
      sheet.getRangeByIndex(row, 53).setText( reportesDow.value![i]['orden_internista'].toString() );  
      sheet.getRangeByIndex(row, 54).setText( reportesDow.value![i]['orden_psiquiatria'].toString() );  
      sheet.getRangeByIndex(row, 55).setText( reportesDow.value![i]['orden_med_familiar'].toString() );  
      sheet.getRangeByIndex(row, 56).setText( reportesDow.value![i]['vacunacion_casa'].toString() );  
      sheet.getRangeByIndex(row, 57).setText( reportesDow.value![i]['quien_vacunacion'].toString() );  
      sheet.getRangeByIndex(row, 58).setText( reportesDow.value![i]['orden_citomapro'].toString() );  
      sheet.getRangeByIndex(row, 59).setText( reportesDow.value![i]['orden_psico'].toString() );  
      sheet.getRangeByIndex(row, 60).setText( reportesDow.value![i]['numero_controles_ruta'].toString() );  
      sheet.getRangeByIndex(row, 61).setText( reportesDow.value![i]['clasificacinon_nutricional'].toString() );  
      sheet.getRangeByIndex(row, 62).setText( reportesDow.value![i]['escala_framingham'].toString() );  
      sheet.getRangeByIndex(row, 63).setText( reportesDow.value![i]['riesgo_escala_framingham'].toString() );  
      sheet.getRangeByIndex(row, 64).setText( reportesDow.value![i]['puntaje_findrisk'].toString() );  
      sheet.getRangeByIndex(row, 65).setText( reportesDow.value![i]['riesgo_findrisk'].toString() );  
      sheet.getRangeByIndex(row, 66).setText( reportesDow.value![i]['canalizacion_rias'].toString() );  
      sheet.getRangeByIndex(row, 67).setText( reportesDow.value![i]['canalizacion_subsistema'].toString() );  
      sheet.getRangeByIndex(row, 68).setText( reportesDow.value![i]['tipo_atencion'].toString() );  
      sheet.getRangeByIndex(row, 69).setText( _boolToStringOption(reportesDow.value![i]['enfermedad_cronica'].toString()) );  
      sheet.getRangeByIndex(row, 70).setText( _boolToStringOption(reportesDow.value![i]['hipertension'].toString()) );  
      sheet.getRangeByIndex(row, 71).setText( _boolToStringOption(reportesDow.value![i]['diabetes'].toString()) );  
      sheet.getRangeByIndex(row, 72).setText( _boolToStringOption(reportesDow.value![i]['epoc'].toString()) );  
      sheet.getRangeByIndex(row, 73).setText( _boolToStringOption(reportesDow.value![i]['cancer'].toString()) );  
      sheet.getRangeByIndex(row, 74).setText( reportesDow.value![i]['tipo_cancer'].toString() );  
      sheet.getRangeByIndex(row, 75).setText( reportesDow.value![i]['otra_cronica'].toString() ); 

      //gestante
      sheet.getRangeByIndex(row, 76).setText( _boolToStringOption(reportesDow.value![i]['usuario_gestante'].toString()) ); 
      sheet.getRangeByIndex(row, 77).setText( "" ); 
      sheet.getRangeByIndex(row, 78).setText( "" ); 
      sheet.getRangeByIndex(row, 79).setText( "" ); 
      sheet.getRangeByIndex(row, 80).setText( "" );  
      sheet.getRangeByIndex(row, 81).setText( "" ); 
      sheet.getRangeByIndex(row, 82).setText( "" ); 
      sheet.getRangeByIndex(row, 83).setText( "" ); 
      sheet.getRangeByIndex(row, 84).setText( "" ); 
      sheet.getRangeByIndex(row, 85).setText( "" ); 
      sheet.getRangeByIndex(row, 86).setText( "" ); 
      sheet.getRangeByIndex(row, 87).setText( "" ); 
      sheet.getRangeByIndex(row, 88).setText( "" ); 
      sheet.getRangeByIndex(row, 89).setText( "" ); 
      sheet.getRangeByIndex(row, 90).setText( "" ); 
      sheet.getRangeByIndex(row, 91).setText( "" ); 
      sheet.getRangeByIndex(row, 92).setText( "" ); 
      sheet.getRangeByIndex(row, 93).setText( "" ); 
      sheet.getRangeByIndex(row, 94).setText( "" ); 
      sheet.getRangeByIndex(row, 95).setText( "" ); 
      

      sheet.getRangeByIndex(row, 96).setText("" );  
      sheet.getRangeByIndex(row, 97).setText( "" );  
      sheet.getRangeByIndex(row, 99).setText( "" );  

      row++;
    }
    
    final List<int> bytes = workbook.saveAsStream();
    File('${documentsDirectory.path}/Reportes_.xlsx').writeAsBytes(bytes);

    print('${documentsDirectory.path}/Reportes.xlsx');
    workbook.dispose();

    await OpenFile.open('${documentsDirectory.path}/Reportes_.xlsx');
  }


  exportReporteCuidado( List<Map<String,Object?>>  data){
    
  }


  _boolToStringOption( String option ){

    if(option == null || option == "") return "";

    return option.toLowerCase() == "true" ? "SI" : "No";

  }
}