import 'package:CAAPMI/controllers/form_controller.dart';
import 'package:CAAPMI/helpers/alertas.dart';
import 'package:CAAPMI/services/db_service.dart';
import 'package:CAAPMI/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputsGeneralForm extends StatelessWidget {

  
  final TextEditingController consecutivoCtrl = TextEditingController();

  InputsGeneralForm({super.key});
  @override
  Widget build(BuildContext context) {
    final formCtrl = Get.find<FormController>();

    return  ContainerForms(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("COD. SUBRED Y LOCALIDAD", style: TextStyle(fontWeight: FontWeight.bold, ),),
            CustomDropdownLocalidad(hintText: "COD. SUBRED Y LOCALIDAD",itemsDrop: DBProvider.localidades),
            const Text("ESTRATEGIA", style: TextStyle(fontWeight: FontWeight.bold, ),),
            CustomDropdownEstrategia(),
            const Text("EQUIPO", style: TextStyle(fontWeight: FontWeight.bold, ),),
            CustomDropdownEquipo(),
            Focus(
              onFocusChange: (value) {
                if( !value ){
                  FocusScope.of(context).previousFocus();
                  validaConsecutivo();
                }
              },
              child:
                CustomInput(icon: Icons.numbers,
                placeholder: "Consecutivo",
                initialValue: formCtrl.consecutivo.value,
                textController: consecutivoCtrl,
                  onchange: (p0) {
                    formCtrl.consecutivo.value = p0;
                  }, 
                  onediting: validaConsecutivo
                ),
            )
          ],
        ),
    );
  }

  void validaConsecutivo(){
    final formCtrl = Get.find<FormController>();
    formCtrl.idfamilia.value = 
    formCtrl.localidad.value + formCtrl.estrateegia.value + formCtrl.equipo.value + formCtrl.consecutivo.value;
    if(formCtrl.idfamilia.value.length != 17){
      mosrtarAlerta(Get.context!, "Error el consecutivo", "Verifique el consecutivo");
    }else{
      FocusScope.of(Get.context!).requestFocus(new FocusNode()); 
      print(formCtrl.idfamilia.value);
    }
  }
}


