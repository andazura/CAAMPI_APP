import 'package:CAAPMI/controllers/form_controller.dart';
import 'package:CAAPMI/helpers/alertas.dart';
import 'package:CAAPMI/services/db_service.dart';
import 'package:CAAPMI/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputsGeneralForm extends StatelessWidget {

  
  final TextEditingController consecutivoCtrl = TextEditingController();
  final focusCons = FocusNode();
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
            CustomInput(
                icon: Icons.numbers,
                placeholder: "Consecutivo",
                initialValue: formCtrl.consecutivo.value,
                focusNode: focusCons,
                textController: consecutivoCtrl,
                  onchange: (p0) {
                    formCtrl.consecutivo.value = p0;
                   formCtrl.idfamilia.value = formCtrl.localidad.value + formCtrl.estrateegia.value + formCtrl.equipo.value + formCtrl.consecutivo.value;
                  },
            ),
          ],
        ),
    );
  }

  void validaConsecutivo(){
    final formCtrl = Get.find<FormController>();
    formCtrl.idfamilia.value = 
    formCtrl.localidad.value + formCtrl.estrateegia.value + formCtrl.equipo.value + formCtrl.consecutivo.value;
    if(formCtrl.idfamilia.value.length != 17){
      focusCons.unfocus();
      mosrtarAlerta("Error el consecutivo", "Verifique el consecutivo");

    }
  }
}


