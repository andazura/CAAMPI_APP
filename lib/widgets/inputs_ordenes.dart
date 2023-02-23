import 'package:CAAPMI/controllers/form_controller.dart';
import 'package:CAAPMI/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputsOrdenes extends StatelessWidget {
  const InputsOrdenes({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerForms(
      child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _CheckLaboratorios(),
                const Divider(),
                const _CheckMedicamentos(),
                const Divider(),
                const _PruebasTratamientos(),
 
                const Divider(),
                const especialidades_dif(),
                const Divider(),
                const especialidades(),

                Divider(),
                CustomDropdownOrdenCitoProMa(),

                OrdenPsicologia(),


                SizedBox(height: 100,)
              ]
      )
    );
  }
}




class _CheckLaboratorios extends StatefulWidget {
  const _CheckLaboratorios({
    Key? key,
  }) : super(key: key);

  @override
  State<_CheckLaboratorios> createState() => _CheckLaboratoriosState();
}

class _CheckLaboratoriosState extends State<_CheckLaboratorios> {

  @override
  Widget build(BuildContext context) {

    final formCtrl = Get.find<FormController>();
    return 
      Column(
        children:
        [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Orden de laboratorios (incluye tamizajes)"),
              Checkbox(
                value: formCtrl.laboratorios.value == "Se ordenaron",
                onChanged: (bool? value) { 
                  setState(() {
                    formCtrl.laboratorios.value =  value == true ? "Se ordenaron" : "No se ordenaron";
                  });
                },
              )
            ],
          ),

          formCtrl.laboratorios.value ==  "Se ordenaron" ?

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Toma de laboratorios en casa"),
              Checkbox(
                value: formCtrl.laboratoriosenCasa.value == "Se solicito orden de laboratorios en casa",
                onChanged: (bool? value) { 
                  setState(() {
                    formCtrl.laboratoriosenCasa.value =  value == true ? "Se solicito orden de laboratorios en casa" : "No cumple criterios para laboratorios en casa";
                  });
                },
              )
            ],
          )
          : const SizedBox()
      ]
      );
  }
}


class _CheckMedicamentos extends StatefulWidget {
  const _CheckMedicamentos({
    Key? key,
  }) : super(key: key);

  @override
  State<_CheckMedicamentos> createState() => _CheckMedicamentosState();
}

class _CheckMedicamentosState extends State<_CheckMedicamentos> {

  @override
  Widget build(BuildContext context) {

    final formCtrl = Get.find<FormController>();
    return 
      Column(
        children:
        [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("MEDICAMENTOS"),
              Checkbox(
                value: formCtrl.medicamentos.value == "Se ordenaron",
                onChanged: (bool? value) { 
                  setState(() {
                    formCtrl.medicamentos.value =  value == true ? "Se ordenaron" : "No se ordenaron";
                  });
                },
              )
            ],
          ),

          formCtrl.medicamentos.value == "Se ordenaron" ?

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Dispensación en casa de medicamentos"),
              Checkbox(
                value: formCtrl.medicamentosenCasa.value == "Se solicito dispensación en casa",
                onChanged: (bool? value) { 
                  setState(() {
                    formCtrl.medicamentosenCasa.value =  value == true ? "Se solicito dispensación en casa" : "No cumple criterios para dispensación en casa";
                  });
                },
              )
            ],
          )
          : const SizedBox()
      ]
      );
  }
}


class _PruebasTratamientos extends StatefulWidget {
  const _PruebasTratamientos({super.key});

  @override
  State<_PruebasTratamientos> createState() => _PruebasTratamientosState();
}

class _PruebasTratamientosState extends State<_PruebasTratamientos> {

  @override
  Widget build(BuildContext context) {
     final formCtrl = Get.find<FormController>();
    return 
      Column(
        children:
        [ 
          
          const Text("ADMINISTRACIÓN DE PRUEBA O TRATAMIENTOS FARMACOLOGICOS "),
          _radioCustome(opciones: const ["SI","No","NA"], groupValue: formCtrl.aplicaTratamientos.value,
          onchange: (p0) {
            setState(() {
              formCtrl.aplicaTratamientos.value =  p0.toString();
            });
          },),

          Obx( () =>
              formCtrl.aplicaTratamientos.value == "SI"
              ? CustomDropdownPruebaTratamiento()
              : const SizedBox()
          ) 
      
      ]
      );
  }
}


class _RadioTratamientos extends StatefulWidget {
  const _RadioTratamientos({super.key});

  @override
  State<_RadioTratamientos> createState() => _RadioTratamientosState();
}

class _RadioTratamientosState extends State<_RadioTratamientos> {

  @override
  Widget build(BuildContext context) {
    final formCtrl = Get.find<FormController>();
    return Row(
      children: [
        Expanded(
          child: RadioListTile(
                    title: const Text("SI"),
                    value: "SI", 
                    groupValue: formCtrl.aplicaTratamientos.value, 
                    onChanged: (value){
                      setState(() {
                          formCtrl.aplicaTratamientos.value =  value.toString();
                      });
                    },
                ),
        ),
        
              Expanded(
                child: RadioListTile(
                    title: const Text("No"),
                    value: "No", 
                    groupValue: formCtrl.aplicaTratamientos.value, 
                    onChanged: (value){
                      setState(() {
                          formCtrl.aplicaTratamientos.value =  value.toString();
                      });
                    }
                ),
              ),

               Expanded(
                child: RadioListTile(
                    title: const Text("NA"),
                    value: "NA", 
                    groupValue: formCtrl.aplicaTratamientos.value, 
                    onChanged: (value){
                      setState(() {
                          formCtrl.aplicaTratamientos.value =  value.toString();
                      });
                    }
                ),
              ),
      ],
    );
  }
}


class _radioCustome extends StatefulWidget {

  final List<String> opciones;
  final Function(String?)? onchange;
  final String? groupValue;
  _radioCustome({super.key, required this.opciones, this.onchange, this.groupValue});

  @override
  State<_radioCustome> createState() => _radioCustomeState();
}

class _radioCustomeState extends State<_radioCustome> {

  @override
  Widget build(BuildContext context) {
    final formCtrl = Get.find<FormController>();
    
    
    return Row(
      children: [


        ...widget.opciones.map((opc) =>
          Expanded(
            child: RadioListTile(
                title: Text(opc),
                value: opc, 
                groupValue: widget.groupValue,
                onChanged: widget.onchange
            ),
          )).toList()
      ],
    );
  }
}

class especialidades_dif extends StatefulWidget {
  const especialidades_dif({
    Key? key,
  }) : super(key: key);

  @override
  State<especialidades_dif> createState() => _especialidades_difState();
}

class _especialidades_difState extends State<especialidades_dif> {
  @override
  Widget build(BuildContext context) {
    final formCtrl = Get.find<FormController>();
    return Column(
      children: [ 
        const Text("Orden especialidades diferentes a internista/psiquiatría /medicina familiar"),
        _radioCustome(opciones: const ["SI","No","NA"], groupValue: formCtrl.especialidadesDiff.value,
          onchange: (p0) {
            setState(() {
                formCtrl.especialidadesDiff.value =  p0.toString();
            });
          },),
        
        Obx( () => 

          formCtrl.especialidadesDiff.value == "SI" ? 
            CustomInput(icon: Icons.contact_page_outlined, placeholder: "Cual orden de especialista",
            onchange: (p0) {
              formCtrl.especialidad.value = p0; 
            }
            )
          : const SizedBox()

          

        )
      ]
    );
  }
}

class especialidades extends StatefulWidget {
  const especialidades({
    Key? key,
  }) : super(key: key);

  @override
  State<especialidades> createState() => _especialidadesState();
}

class _especialidadesState extends State<especialidades> {
  @override
  Widget build(BuildContext context) {
    final formCtrl = Get.find<FormController>();
    return Column(
      children: [

        const Divider(),
        const Text("Orden Internista"),
        _radioCustome(opciones: const ["SI","No","NA"], groupValue: formCtrl.ordenInternitsa.value,
          onchange: (p0) {
            setState(() {
                formCtrl.ordenInternitsa.value =  p0.toString();
            });
          },),

        const Divider(),
        const Text("Orden Psiquiatría"),
        _radioCustome(opciones: const ["SI","No","NA"], groupValue: formCtrl.ordenPsiqui.value,
          onchange: (p0) {
            setState(() {
                formCtrl.ordenPsiqui.value =  p0.toString();
            });
          },),

        const Divider(),
        const Text("Orden Medicina Familiar"),
        _radioCustome(opciones: const ["SI","No","NA"], groupValue: formCtrl.ordenMedFamiliar.value,
          onchange: (p0) {
            setState(() {
                formCtrl.ordenMedFamiliar.value =  p0.toString();
            });
          },),

          const Divider(),
          const Text("Vacunación en casa"),
        _radioCustome(opciones: const ["SI","No","NA"], groupValue: formCtrl.vacunacionCasa.value,
          onchange: (p0) {
            setState(() {
                formCtrl.vacunacionCasa.value =  p0.toString();
            });
          },),

          Obx( ()=>
            formCtrl.vacunacionCasa.value == "SI" ? CustomDropdownVacunaQuien() : const Divider()
          ),

      ]
    );
  }
}

class OrdenPsicologia extends StatefulWidget {
  const OrdenPsicologia({super.key});

  @override
  State<OrdenPsicologia> createState() => _OrdenPsicologiaState();
}

class _OrdenPsicologiaState extends State<OrdenPsicologia> {
  @override
  Widget build(BuildContext context) {
    final formCtrl = Get.find<FormController>();
    return Column(
      children: [
        const Text("Orden Psicología"),
        _radioCustome(opciones: const ["SI","No","NA"], groupValue: formCtrl.ordenPsico.value,
          onchange: (p0) {
            setState(() {
                formCtrl.ordenPsico.value =  p0.toString();
            });
          },),
      ],
    );
  }
}