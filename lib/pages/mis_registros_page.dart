import 'dart:math';

import 'package:CAAPMI/controllers/registros_controller.dart';
import 'package:CAAPMI/services/auth_service.dart';
import 'package:CAAPMI/services/db_service.dart';
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
                  title: Text("Usuario", textAlign: TextAlign.center,),
                  trailing: Text("Editar"),
                  leading: Text("Descargar"),
                ),
                ...reportesController.reportes.value!.map(
                  (reg) => 

                    ListTile(
                      title: Column(
                        children: [
                          Text("${reg['primer_nombre']} ${reg['primer_apellido']}"),
                          Text(reg['id_familia'].toString())
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: (){
                          print("object");
                        },
                        icon: Icon( Icons.edit, color: Colors.blue,),
                      ),
                      leading: IconButton(
                        onPressed: () async {
                          String query = " AND id_auto_reportes = ${reg['id_auto_reportes']}";
                          await reportesController.getReportes( modoExporte: 1,  query: query );
                          reportesController.exportReportes(  modo:  1 );
                        },
                        icon: Icon( FontAwesomeIcons.download, color: Colors.green[600],),
                      ),
                    )
                  )
                .toList()
              ],
            )
    );


  }
}