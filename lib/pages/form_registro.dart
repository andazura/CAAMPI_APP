import 'dart:io';

import 'package:CAAPMI/controllers/form_controller.dart';
import 'package:CAAPMI/pages/pages.dart';
import 'package:CAAPMI/services/auth_service.dart';
import 'package:CAAPMI/services/menu_service.dart';
import 'package:CAAPMI/services/utils_service.dart';
import 'package:CAAPMI/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';



class FormRegistroPage extends StatelessWidget {
   
  const FormRegistroPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final formCtrl = Get.find<FormController>();
    formCtrl.getDataToRegistro(context);
    final utilsService = Provider.of<UtilsService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(authService.usuario.nombre, style: TextStyle( color: Colors.black54) ),
        elevation: 20,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon( Icons.exit_to_app, color: Colors.black54 ),
          onPressed: () {
            // todo desconectarnos del sokcet
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon( Icons.check_circle, color: Colors.blue,),
            // child: Icon( Icons.offline_bolt, color: Colors.red,),
          )
        ],
      ),
      body: SingleChildScrollView(
        primary: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: StreamBuilder(
            stream: menuService.menuController,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Column(
                children: [

                  FormGeneral(
                    titulo: "Datos Generales",
                    iconoSeccion: FontAwesomeIcons.houseMedicalCircleCheck,
                    optTap: 'dtsgen',
                    isSelected: snapshot.data == 'dtsgen',
                    form: InputsGeneralForm()
                  ),

                  FormGeneral(
                    titulo: "Datos Paciente",
                    iconoSeccion: FontAwesomeIcons.heartPulse,
                    optTap: 'dtspac',
                    isSelected: snapshot.data == 'dtspac',
                    form: InputsPacienteForm()
                  ),

                  Obx(()=>

                    formCtrl.eps.value == "CAPITAL SALUD" && formCtrl.regimen.value ==  "Subsidiado"
                    ? FormGeneral(
                        titulo: "Ordenes y Medicamentos",
                        iconoSeccion: FontAwesomeIcons.syringe,
                        optTap: 'dtcpsalud',
                        isSelected: snapshot.data == 'dtcpsalud',
                        form: const InputsOrdenes()
                      )
                    :  const SizedBox()                   
                  )
                ],
              );
            }, 
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            child: const Icon( Icons.save ) ,
            onPressed: () async { 
              formCtrl.saveData();        
              menuService.setMenuOpt("");        
            },
          ),
          const SizedBox(height: 5),
          FloatingActionButton(
            heroTag: null,
            child: const Icon( Icons.arrow_downward ) ,
            onPressed: () async { 
              menuService.setMenuOpt("");   
            },
          ),
        ]
      ),
    );
  }  
}




