import 'dart:io';
import 'package:CAAPMI/controllers/form_controller.dart';
import 'package:CAAPMI/models/diagnosticos_response.dart';
import 'package:CAAPMI/models/eps_response.dart';
import 'package:CAAPMI/models/localidad_response.dart';
import 'package:CAAPMI/models/regimen_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DBProvider{

  static Database? _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  static late List<LocalidadesModel> localidades = [];
  static late List<RegimenModel> regimenes = [];
  static late List<EpsModel> eps = [];

  Future<Database> get database async {
    if ( _database != null ) return _database!;

    _database = await initDB();

    return _database!;
  }

  Future<Database> initDB() async{

      //path donde almacenar la base de dtos
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join( documentsDirectory.path, 'caampi.db' );

      return await openDatabase(
        path,
        version: 3,
        onCreate: ( Database db, int version) async {
          await createTableReportes(db);
          await createTableLocalidades(db);
          await createTableRegimenes(db);
          await createTableDiagnosticos(db);
          await createTableEps(db);
        },
        onUpgrade: (db, oldVersion, newVersion) {

            if(oldVersion == 2 || oldVersion == 1){
              createcuidadoFamiliar(db);
            }
        },
        );
  }

  Future createcuidadoFamiliar( Database db ) async {
      
      print("entra a crear");
    await db.execute('''
      create table if not exists reportes_cuidad(
        id_auto_reportes_cuidado INTEGER PRIMARY KEY, 
        consecutivo TEXT KEY,
        tipo_familia TEXT,
        etapa_familia TEXT,
        integrantes_familia TEXT,
        integrantes_valorados TEXT,
        direccion TEXT,
        telefono TEXT
      )
    ''');
  } 

  Future createTableReportes( Database db ) async {

    await db.execute('''
      create table if not exists reportes(
                id_auto_reportes INTEGER PRIMARY KEY, 
                consecutivo TEXT KEY,
                estrateegia TEXT,
                equipo TEXT KEY,
                localidad TEXT KEY,
                id_familia TEXT KEY,
                fecha_consulta TEXT,
                persona_atienede TEXT,
                tipo_cc TEXT,
                cc TEXT,
                primer_nombre TEXT,
                segundo_nombre TEXT,
                primer_apellido TEXT,
                segundo_apellido TEXT,
                fecha_nacimiento TEXT,
                sexo TEXT,
                regimen TEXT,
                eapb TEXT,
                nacionalidad TEXT,
                grupo_poblacion TEXT,
                codigo_consulta TEXT,
                finlidad_consulta TEXT,
                codDiag TEXT,
                codDiag1 TEXT,
                codDiag2 TEXT,
                codDiag3 TEXT,
                tipo_diag TEXT,
                vacunas TEXT,
                peso TEXT,
                talla TEXT,
                frecuencia_cardiaca TEXT,
                glucometria TEXT,
                res_glucometria TEXT,
                tamhg TEXT,
                perimetro_abfominal TEXT,
                perimetro_brazo TEXT,
                ordena_lab TEXT,
                lab_en_casa TEXT,
                ordena_med TEXT,
                med_en_casa TEXT,
                prueba_tratamientos TEXT,
                cual_prueba_tratamientos TEXT,
                otra_especialidad TEXT,
                cual_otra_especialidad TEXT,
                orden_internista TEXT,
                orden_psiquiatria TEXT,
                orden_med_familiar TEXT,
                vacunacion_casa TEXT,
                quien_vacunacion TEXT,
                orden_citomapro TEXT,
                orden_psico TEXT,
                numero_controles_ruta TEXT,
                clasificacinon_nutricional TEXT,
                escala_framingham TEXT,
                riesgo_escala_framingham TEXT,
                puntaje_findrisk TEXT,
                riesgo_findrisk TEXT,
                canalizacion_rias TEXT,
                canalizacion_subsistema TEXT,
                tipo_atencion TEXT,
                enfermedad_cronica TEXT,
                hipertension TEXT,
                diabetes TEXT,
                epoc TEXT,
                cancer TEXT,
                tipo_cancer TEXT,
                otra_cronica TEXT,
                usuario_gestante TEXT,
                edad_gestacional TEXT,
                fecha_ultimo_parto TEXT,
                fur TEXT,
                fpp TEXT,
                semana10 TEXT,
                semana12 TEXT,
                clasificacion_trimestral TEXT,
                clasficacion_riesgo TEXT,
                riesgo_psicosocial TEXT,
                riesgo_biosicosocial TEXT,
                riesgo_obstetrico TEXT,
                riesgo_tromboembolico TEXT,
                riesgo_depresion_pos_parto TEXT,
                sifilis_gestacional TEXT,
                sifilis_congenita TEXT,
                mme TEXT,
                hepatitisb TEXT,
                vih TEXT,
                consulta_control TEXT,
                observaciones TEXT,
                subred_localidad TEXT,
                estrategia TEXT,
                nombre_profesional TEXT,
                observaciones_paciente TEXT
            );
    ''');
  }

  Future createTableLocalidades( Database db ) async{

    await db.execute('''
              CREATE TABLE  IF NOT EXISTS Localidades(
                id INTEGER PRIMARY KEY,
                codigo TEXT,
                value TEXT
              );
          ''');
  }

  Future createTableRegimenes( Database db ) async{

    await db.execute('''
              CREATE TABLE IF NOT EXISTS Regimenes(
                id INTEGER PRIMARY KEY,
                regimen TEXT KEY
              );
          ''');
  }

  Future createTableDiagnosticos( Database db ) async{
    
    await db.execute('''
              CREATE TABLE IF NOT EXISTS Diagnosticos(
                id INTEGER PRIMARY KEY,
                Codigo TEXT KEY,
                Nombre TEXT
              );
          ''');
  }


  Future createTableEps( Database db ) async{
    
    await db.execute('''
              CREATE TABLE IF NOT EXISTS Eps(
                id INTEGER PRIMARY KEY,
                eapb TEXT KEY
              );
          ''');
  }


  Future<List<LocalidadesModel>> getLocalidades() async{

    final db = await database;
    final res = await db.query("Localidades");

    if(res.isNotEmpty){
      localidades =  res.map( (s) => LocalidadesModel.fromJson( s )).toList();
      return localidades;
    }else{
      return [];
    }
  }

  Future<int> insertLocalidad( LocalidadesModel  localidad ) async {
    final db = await database;
    final res = await db.insert('Localidades', localidad.toJson());
    localidades.add(localidad);
    return res;
  }

  Future<int> deleteAllScan(  ) async{
    final db = await database;
    final res = await db.rawDelete( '''
      DELETE FROM Scans
    ''' );
    return res;
  }


  // Future truncateTables() async{
  //   final db = await database;
  //   await db.execute("DELETE FROM reportes");
  //   await db.execute("DELETE FROM reportes_cuidad");
  // }

  Future<List<Map<String, Object?>>> getReportes( { String? query = ""} ) async{

    final db = await database;
    final res = await db.rawQuery("SELECT * FROM reportes WHERE 1 $query");

    return res;
  }

  Future<List<Map<String, Object?>>> getCuidado( { String? query = ""} ) async{

    final db = await database;

    final res = await db.rawQuery('''
                SELECT
                  r.id_familia,
                  r.tipo_cc,
                  r.cc,
                  r.localidad,
                  r.estrateegia,
                  r.equipo,
                  r.consecutivo,
                  r.fecha_consulta,
                  rc.direccion,
                  rc.telefono,
                  r.primer_nombre,
                  r.segundo_nombre,
                  r.primer_apellido,
                  r.segundo_apellido
                FROM reportes r
                INNER JOIN reportes_cuidad rc on r.consecutivo = rc.consecutivo
                WHERE r.persona_atienede = 'true'
                $query ''');

    return res;
  }

  Future<int> insertRegistro( ) async{

      final f = Get.find<FormController>();
      final db = await database;
      


      final String pnombre = f.nombres.split(' ')[0];
      final String snombre = f.nombres.split(' ').length > 1 ? f.nombres.split(' ')[1] : '0';

      final String papellido = f.apellidos.split(' ')[0];
      final String sapellido = f.apellidos.split(' ').length > 1 ? f.apellidos.split(' ')[1] : '0';

      final res = await db.rawInsert("INSERT INTO reportes"
      "(consecutivo,estrateegia,equipo,localidad,id_familia,"
      "fecha_consulta,persona_atienede,tipo_cc,cc,primer_nombre,"
      "segundo_nombre,primer_apellido,segundo_apellido,fecha_nacimiento,sexo,"
      "regimen,eapb,nacionalidad,grupo_poblacion,codigo_consulta,"
      "finlidad_consulta,codDiag,codDiag1,codDiag2,codDiag3,tipo_diag,"
      "vacunas,peso,talla,frecuencia_cardiaca,glucometria,"
      "res_glucometria,tamhg,perimetro_abfominal,perimetro_brazo,ordena_lab,"
      "lab_en_casa,ordena_med,med_en_casa,prueba_tratamientos,cual_prueba_tratamientos,"
      "otra_especialidad,cual_otra_especialidad,orden_internista,orden_psiquiatria,orden_med_familiar,"
      "vacunacion_casa,quien_vacunacion,orden_citomapro,orden_psico,numero_controles_ruta,"
      "clasificacinon_nutricional,escala_framingham,riesgo_escala_framingham,puntaje_findrisk,riesgo_findrisk,"
      "canalizacion_rias,canalizacion_subsistema,tipo_atencion,enfermedad_cronica,hipertension,"
      "diabetes,epoc,cancer,tipo_cancer,otra_cronica,"
      "observaciones_paciente)"
      "VALUES ("
      // "usuario_gestante,edad_gestacional,fecha_ultimo_parto,fur,fpp,semana10,semana12,clasificacion_trimestral,clasficacion_riesgo,riesgo_psicosocial,riesgo_biosicosocial,riesgo_obstetrico,riesgo_tromboembolico,riesgo_depresion_pos_parto,sifilis_gestacional,sifilis_congenita,mme,hepatitisb,vih,consulta_control,
      "'${f.consecutivo}','${f.estrateegia}', '${f.equipo}', '${f.localidad}', '${f.idfamilia}',"
      "'${f.fechaConsulta}','${f.personaAtiende}','${f.tipoDocumento}', '${f.documento}', '$pnombre',"
      "'$snombre', '$papellido', '$sapellido', '${f.fechaNacimineto}', '${f.sexo}',"
      "'${f.regimen}', '${f.eps}', '${f.nacionalidad}', '${f.grupoPoblacion}', '890101','',"

      "'${f.codDiag}', '${f.codDiag1}', '${f.codDiag2}', '${f.codDiag3}', '${f.tipoDiagnostico}',"
      "'${f.vacunasAlDia}', '${f.peso}', '${f.talla}', '${f.frecuenciaC}', '${f.tieneGluco}',"
      "'${f.resGluco}', '${f.tamhg}', '${f.perimetroAbdominal}', '${f.perimetroBrazo}', '${f.laboratorios}',"
      "'${f.laboratoriosenCasa}', '${f.medicamentos}', '${f.medicamentosenCasa}', '${f.aplicaTratamientos}', '${f.tratamiento}',"
      "'${f.especialidadesDiff}', '${f.especialidad}', '${f.ordenInternitsa}', '${f.ordenPsiqui}', '${f.ordenMedFamiliar}',"
      "'${f.vacunacionCasa}','${f.vacunaQuien}', '${f.citomapro}', '${f.ordenPsico}', '0',"
      "'','','','${f.puntajeFINDRISC}', '${f.riesgoFINDRISC}',"
      "'${f.canalizacion_rias}','No aplica', '${f.tipo_atencion}', '${f.enfermedad_cronica}','${f.hipertension}',"
      "'${f.diabetes}', '${f.epoc}', '${f.cancer}' ,'${f.tipo_cancer}', '${f.otra_cronica}',"
      "'')");

      if(f.personaAtiende.value){

        await db.rawInsert("INSERT INTO reportes_cuidad"
        "(consecutivo,direccion,telefono) VALUES ('${f.consecutivo}','${f.direccion}','${f.telefono}')");
      }

      return res;
    // final res = await db.rawInsert("INSERT IGNORE INTO registros(documento) values ('123213')");
    // return res;
  }


  Future<int> insertRegimenes( RegimenModel  regimen ) async {
    final db = await database;
    final res = await db.insert('Regimenes', regimen.toJson());
    regimenes.add(regimen);
    return res;
  }

  Future<List<RegimenModel>> getRegimenes() async{

    final db = await database;
    final res = await db.query("Regimenes");

    if(res.isNotEmpty){
      regimenes =  res.map( (s) => RegimenModel.fromJson( s )).toList();
      return regimenes;
    }else{
      return [];
    }
  }

  Future<int> insertDiagnosticos( DiagnosticoModel diagnostico ) async {
    final db = await database;
    await createTableDiagnosticos( db );
    final res = await db.insert('Diagnosticos', diagnostico.toJson());
    return res;
  }

  Future<bool> getDiaganosticos() async{
    final db = await database;
    await createTableDiagnosticos( db );
    final res = await db.rawQuery("SELECT * FROM Diagnosticos");

    return res.isNotEmpty;
  }

  Future<List<DiagnosticoModel>> getDiagnosticosQuery( String query ) async {
    final db = await database;
    
    final sql = "SELECT * FROM Diagnosticos WHERE Nombre lIKE ('%$query%') OR Codigo LIKE ('%$query%') LIMIT 20";
    
    final res = await db.rawQuery(sql);
    if( res.isNotEmpty ){
        final res2 = res.map(( dg ) =>  DiagnosticoModel.fromJson( dg )).toList();
        return res2;
    }else{
      return [];
    }
  }

  Future<int> insertEps( EpsModel eps_ ) async {
    final db = await database;
    await createTableEps( db );
    final res = await db.insert('Eps', eps_.toJson());
    eps.add(eps_);
    return res;
  }
}