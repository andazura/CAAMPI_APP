import 'dart:math';

import 'package:CAAPMI/controllers/registros_controller.dart';
import 'package:CAAPMI/helpers/alertas.dart';
import 'package:CAAPMI/services/auth_service.dart';
import 'package:CAAPMI/services/db_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MisRegistrosScreen extends StatelessWidget {
   
  MisRegistrosScreen({Key? key}) : super(key: key);

  final reportesController =  Get.find<RegistrosController>();
  TextEditingController fecha_consultaCtrl = TextEditingController();
  RefreshController _refreschCtrl = RefreshController();

  @override
  Widget build(BuildContext context) {

    @override
    void initState() {
      final date = DateTime.now();
      fecha_consultaCtrl.text = "${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}";
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis reportes"),
        leading: IconButton(
          icon: Icon( Icons.exit_to_app, color: Colors.white ),
          onPressed: () {
            // todo desconectarnos del sokcet
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
            
          },
        ),
        actions: [
          IconButton(onPressed: () async {
            await reportesController.exportReportes();
          },
          icon: const Icon( FontAwesomeIcons.download ))

        ],
      ),
      body: SmartRefresher(
        header: WaterDropHeader(),
        controller: _refreschCtrl,
        onRefresh: _loadReportes,
        child: Column(
          children: [
      
              const SizedBox( height:  10),
              ElevatedButton(onPressed: (){
                reportesController.getReportes(query: "");
              },
                child: const Text("Obtener todos los regsitros")
              ),
              const SizedBox( height:  10),
              const Text("Filtro Fecha:"),
              TextField(
                    readOnly: true,
                    controller: fecha_consultaCtrl,
                    decoration: const InputDecoration(
                      icon: Icon( Icons.calendar_month_outlined),
                      hintText: "Consulta fecha"
                    ),
                    onTap: () {
                       DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  maxTime: DateTime.now( ).add( const Duration( days: 3 )) ,
                                  minTime: DateTime(1900),
                                  onConfirm: (date) {
                                    fecha_consultaCtrl.text = "${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}";
                                    reportesController.getReportes(query: " AND fecha_consulta = '${fecha_consultaCtrl.text}'");
                                  }, currentTime: DateTime.now(), locale: LocaleType.es);
                    },
                  ),
              
              const Expanded(
                child: SingleChildScrollView(
                  primary: false,
                  child: Registros()
                ),
              ),
          ],
        ),
      ),
    );

    
  }


  _loadReportes() async {

    String? fecha = "";
    fecha =  fecha_consultaCtrl.text  != "" ?  fecha_consultaCtrl.text : null ;
    final date = DateTime.now();
    fecha = fecha ?? "${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}";
    await reportesController.getReportes(query: " AND fecha_consulta = '$fecha'");
    _refreschCtrl.refreshCompleted();
  }
}

class Registros extends StatelessWidget {
  const Registros({super.key});

  @override
  Widget build(BuildContext context) {
    final reportesController =  Get.find<RegistrosController>();

    return Obx(() => 

            reportesController.reportes.value == null ? const SizedBox()
            : Column(
              children: [
                const Divider(),
                const Text("Resultado Consulta", style: TextStyle( fontWeight: FontWeight.bold, fontSize: 18 ),),
                const ListTile(
                  title: Text("Usuario", textAlign: TextAlign.center),
                  leading: Text("Descargar"),
                ),
                ...reportesController.reportes.value!.map(
                  (reg) => 

                    GestureDetector(
                      onLongPress: (){
                        _showActionSheet( idReporte: int.tryParse(reg['id_auto_reportes'].toString())! );
                      },
                      child: ListTile(
                        title: Column(
                          children: [
                            Text("${reg['primer_nombre']} ${reg['primer_apellido']}"),
                            Text(reg['id_familia'].toString())
                          ],
                        ),
                        leading: IconButton(
                          onPressed: () async {
                            String query = " AND id_auto_reportes = ${reg['id_auto_reportes']}";
                            await reportesController.getReportes( modoExporte: 1,  query: query );
                            reportesController.exportReportes(  modo:  1 );
                          },
                          icon: Icon( FontAwesomeIcons.download, color: Colors.green[600],),
                        ),
                      ),
                    )
                  )
                .toList()
              ],
            )
    );
  }


  void _showActionSheet({ required int idReporte }) {

    final reportesController =  Get.find<RegistrosController>();

    final context =  Get.context;
    showCupertinoModalPopup<void>(
      context: context!,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Registro'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// defualt behavior, turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Editar'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              final res =  await reportesController.delReport( idReporte: idReporte );
              Navigator.pop(context);
              if(res >= 0){
                mosrtarAlerta(context, "Registro eliminado", "Se elimino exitosamente");
              }else{
                mosrtarAlerta(context, "Error", "No se pudo eliminar el registro");
              }
              
            },
            child: const Text('Eliminar'),
          ),
          CupertinoActionSheetAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as delete or exit and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}