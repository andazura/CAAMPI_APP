import 'package:CAAPMI/controllers/form_controller.dart';
import 'package:CAAPMI/models/diagnosticos_response.dart';
import 'package:CAAPMI/models/localidad_response.dart';
import 'package:CAAPMI/services/db_service.dart';
import 'package:CAAPMI/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';




class InputsPacienteForm extends StatelessWidget {

  

  @override
  Widget build(BuildContext context) {

    final formCtrl = Get.find<FormController>();

    final firstDate = DateTime(DateTime.now().year - 120);
    final lastDate = DateTime.now();

    return ContainerForms(
        child: 
          Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                const _CheckAtiende(),
          
                TextField(
                  readOnly: true,
                  controller: formCtrl.fechaConsultaControler.value,
                  decoration: const InputDecoration(
                    icon: Icon( Icons.calendar_month_outlined),
                    hintText: "Fecha Consulta"
                  ),
                  onTap: () {
                     DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                maxTime: DateTime.now(),
                                onConfirm: (date) {
                                   formCtrl.fechaConsultaControler.value!.text = "${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}";
                                   formCtrl.fechaConsulta.value = formCtrl.fechaConsultaControler.value!.text;
                                }, currentTime: DateTime.now(), locale: LocaleType.es);
                  },
                ),
          
                const Divider(),
          
                const Text("Tipo de identificación usuario", style: TextStyle(fontWeight: FontWeight.bold, ),),
                CustomDropdownTipoCC(),
                const Divider(),
                const Text("Número de identificación", style: TextStyle(fontWeight: FontWeight.bold, ),),
                CustomInput(icon: Icons.numbers_outlined , placeholder: "Número de identificación", textInputType: TextInputType.number,
                initialValue: formCtrl.documento.value,
                  onchange: (value){
                    formCtrl.documento.value = value;
                  }),
                const Divider(),
                  
                const Text("Nombres", style: TextStyle(fontWeight: FontWeight.bold, ),),
                CustomInput(icon: Icons.person_outline , placeholder: "Ej: (Joaquin Andres ó Andres 0)", textCaptilizacion: TextCapitalization.characters,
                initialValue: formCtrl.nombres.value,
                onchange: (value){
                    formCtrl.nombres.value = value;
                  }),
                const Divider(),
                  
                const Text("Apellidos", style: TextStyle(fontWeight: FontWeight.bold, ),),
                CustomInput(icon: Icons.person_outline , placeholder: "Ej: (Zuñiga Hernandez ó Zuñiga 0)", textCaptilizacion: TextCapitalization.characters,
                initialValue: formCtrl.apellidos.value,
                onchange: (value){
                    formCtrl.apellidos.value = value;
                }),
          
                const Divider(),

                Obx(() => 

                formCtrl.personaAtiende.value ? 
                  Column(
                    children: [
                      const Text("Direccion", style: TextStyle(fontWeight: FontWeight.bold, ),),
                        CustomInput(icon: FontAwesomeIcons.streetView , placeholder: "Direccion:", textCaptilizacion: TextCapitalization.characters,
                        initialValue: formCtrl.direccion.value,
                        onchange: (value){
                            formCtrl.direccion.value = value;
                        }),

                        const Text("Telefono", style: TextStyle(fontWeight: FontWeight.bold, ),),
                        CustomInput(icon: FontAwesomeIcons.phone , placeholder: "Telefono:", textInputType: TextInputType.number,
                        initialValue: formCtrl.telefono.value,
                        onchange: (value){
                            formCtrl.telefono.value = value;
                        }),
                    ],
                  )
                : const SizedBox()
                ),

                const Divider(),
                  
                const Text("Fecha de nacimiento", style: TextStyle(fontWeight: FontWeight.bold, ),),
                TextField(
                  readOnly: true,
                  controller: formCtrl.fechaNacimientoControler.value,
                  decoration: const InputDecoration(
                    icon: Icon( Icons.calendar_month_outlined),
                    hintText: "Fecha nacimiento del usuario"
                  ),
                  onTap: () {
                     DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                maxTime: DateTime.now(),
                                minTime: DateTime(1900),
                                onConfirm: (date) {
                                  final ahora = DateTime.now();
                                  final diferencia = ahora.difference(date);
                                  formCtrl.anos.value = diferencia.inDays / 365;
                                  formCtrl.fechaNacimientoControler.value!.text = "${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}";
                                  formCtrl.fechaNacimineto.value = "${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}";
                                  calculaFindrisk( );
                                }, currentTime: DateTime.now(), locale: LocaleType.es);
                  },
                ),
                const Divider(),
          
                const RadioSexo(),
                
                CustomDropdownRegimen( hintText: "Régimen de afiliación", itemsDrop: DBProvider.regimenes ),
          
                CustomDropdownEps(eps: DBProvider.eps),
          
                CustomDropdownNacionalidad(),
          
                CustomDropdownGrupoPoblacion(),

                const FinalidadConsulta( ),
                 
                // AutocompleteDiagnostico(),
                const Text("Código del diagnóstico principal", style: TextStyle(fontWeight: FontWeight.bold, ),),
                AutoCompleteDiagnostico(
                  initialValue: TextEditingValue( text:  formCtrl.codDiag.value ),
                  onSelected: (p0) {
                  formCtrl.codDiag.value = p0.codigo;  
                },  ),

                const Text("Código del diagnóstico principal 1", style: TextStyle(fontWeight: FontWeight.bold, ),),
                AutoCompleteDiagnostico(
                  initialValue: TextEditingValue( text:  formCtrl.codDiag1.value ),
                  onSelected: (p0) {
                  formCtrl.codDiag1.value = p0.codigo;  
                },  ),

                const Text("Código del diagnóstico principal 2", style: TextStyle(fontWeight: FontWeight.bold, ),),
                AutoCompleteDiagnostico(
                  initialValue: TextEditingValue( text:  formCtrl.codDiag2.value ) ,
                  onSelected: (p0) {
                  formCtrl.codDiag2.value = p0.codigo;  
                },  ),
          
                const Text("Código del diagnóstico principal 3", style: TextStyle(fontWeight: FontWeight.bold, ),),
                AutoCompleteDiagnostico(
                  initialValue: TextEditingValue( text:  formCtrl.codDiag3.value ), 
                  onSelected: (p0) {
                  formCtrl.codDiag3.value = p0.codigo;  
                },  ),
          
                CustomDropdownTipoDiagnostico(),
          
                const _CheckVacunas(),
          
                const Text("Peso Kg", style: TextStyle(fontWeight: FontWeight.bold, ),),
                CustomInput(icon: Icons.scale_outlined , placeholder: "Ej: 89,0", textInputType: TextInputType.text,
                initialValue: formCtrl.peso.value,
                  onchange: (p0) {
                    formCtrl.peso.value = p0;
                    calculaFindrisk( );
                  },),
                const Divider(),
          
          
                const Text("Talla (metros) - separador por (,)", style: TextStyle(fontWeight: FontWeight.bold, ),),
                CustomInput(icon: Icons.height , placeholder: "Ej: 1,80", textInputType: TextInputType.text,
                initialValue: formCtrl.talla.value,
                 onchange: (p0) {
                   formCtrl.talla.value = p0;
                    calculaFindrisk( );
                 },
                ),
                const Divider(),
                
                const Text("Frecuencia Cardiaca (pulso/min)", style: TextStyle(fontWeight: FontWeight.bold, ),),
                CustomInput(icon: Icons.timer , placeholder: "Ej: 50",  textInputType: TextInputType.number,
                initialValue: formCtrl.frecuenciaC.value,
                onchange: (p0) {
                  formCtrl.frecuenciaC.value = p0;
                },),
                const Divider(),
                
                const _CheckGlucometria(),
          
                const Text("T/A (mmHg)", style: TextStyle(fontWeight: FontWeight.bold, ),),
                CustomInput(icon: Icons.thermostat, placeholder: "Ej: 120/60",  textInputType: TextInputType.text,
                initialValue: formCtrl.tamhg.value,
                onchange: (p0) {
                  formCtrl.tamhg.value = p0;
                },),
          
          
                const Text("Perímetro abdominal", style: TextStyle(fontWeight: FontWeight.bold, ),),
                CustomInput(icon: Icons.person , placeholder: "Ej: 90", textInputType: TextInputType.text,
                initialValue: formCtrl.perimetroAbdominal.value,
                onchange: (p0) {
                  formCtrl.perimetroAbdominal.value = p0;
                    calculaFindrisk( );
                },),
          
                const _MenorCinco(),
                const Preguntasfindrisk(),
                const Text("Puntaje Escala FINDRISC (Tamizaje)", style: TextStyle(fontWeight: FontWeight.bold, )),
                CustomInput(icon: Icons.person , placeholder: "", textInputType: TextInputType.text,
                textController: formCtrl.puntajeFINDRISCController.value,
                //initialValue: formCtrl.puntajeFINDRISC.value,
                onchange: (p0) {
                  formCtrl.puntajeFINDRISC.value = p0.toString() == "" ? "NA" : p0.toString();

                  if(formCtrl.puntajeFINDRISC.value == "" || formCtrl.puntajeFINDRISC.value.toLowerCase() == "na"){
                    formCtrl.riesgoFINDRISCController.value!.text = "";
                    return;
                  } 

                  calculaRiesgo(  );
                },),

                const Text("Clasificación Riesgo Escala FINDRISC (Tamizaje)", style: TextStyle(fontWeight: FontWeight.bold, )),

                CustomInput(icon: Icons.person , placeholder: "", textController: formCtrl.riesgoFINDRISCController.value, textInputType: TextInputType.text,enable: false,
                    
                    onchange: (p0) {


                    formCtrl.riesgoFINDRISC.value = p0.toString() == "" ? "NA" : p0.toString();
                },),
                

                const CustronDropDownCanalizacionRias(),

                const TipoAtencion(),

                const _enfermedadCronica(),

                const OrdenPsicologia(),

                const Text("Vacunación en casa"),
                const Vacuna(),
                  Obx( ()=>
                    formCtrl.vacunacionCasa.value == "SI" ? CustomDropdownVacunaQuien() : const Divider()
                  ),

                const UsuarioGestante(),                

                const SizedBox( height: 100 ),
              ],
            ),
          ),
    );
  }
}


class Vacuna extends StatefulWidget {
  const Vacuna({super.key});

  @override
  State<Vacuna> createState() => _VacunaState();
}

class _VacunaState extends State<Vacuna> {

  final formCtrl = Get.find<FormController>();

  @override
  Widget build(BuildContext context) {
    
    return radioCustome(opciones: const ["SI","No","NA"], groupValue: formCtrl.vacunacionCasa.value,
                  onchange: (p0) {
                    setState(() {
                              formCtrl.vacunacionCasa.value =  p0.toString();
                    });
                  },
            );
  }
}

class UsuarioGestante extends StatefulWidget {
  const UsuarioGestante({
    super.key,
  });

  @override
  State<UsuarioGestante> createState() => _UsuarioGestanteState();
}

class _UsuarioGestanteState extends State<UsuarioGestante> {
  @override
  Widget build(BuildContext context) {
    final formCtrl = Get.find<FormController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: double.infinity,
        ),
        const Text("Usuaria gestante"),
        Checkbox(
                  value: formCtrl.usuarioGestante.value,
                  onChanged: (bool? value) { 
                    setState(() {                  
                      formCtrl.usuarioGestante.value = value!;
                    });
                  },
                ),
      ],
    );
  }
}

class _enfermedadCronica extends StatefulWidget {
  const _enfermedadCronica({
    Key? key,
  }) : super(key: key);

  @override
  State<_enfermedadCronica> createState() => _enfermedadCronicaState();
}

class _enfermedadCronicaState extends State<_enfermedadCronica> {
  @override
  Widget build(BuildContext context) {
    final formCtrl = Get.find<FormController>();

   return Column(
      children:
        [ 
            const Text("¿Usuario diagnosticado con enfermedad crónica?", style: TextStyle(fontWeight: FontWeight.bold, )),
            Checkbox(
              value: formCtrl.enfermedad_cronica.value,
              onChanged: (bool? value) { 
                setState(() {                  
                  formCtrl.enfermedad_cronica.value = value!;
                  calculaFindrisk( );

                });
              },
            ),
             
          
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("HIPERTENSION", style: TextStyle(fontWeight: FontWeight.bold, )),
                Checkbox(
                value: formCtrl.hipertension.value,
                onChanged: (bool? value) { 
                  setState(() {
                    formCtrl.hipertension.value = value!;
                    calculaFindrisk( );

                  });
                },
              )
                
              ],
            ),
      
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("DIABETES", style: TextStyle(fontWeight: FontWeight.bold, )),
                Checkbox(
                value: formCtrl.diabetes.value,
                onChanged: (bool? value) { 
                  setState(() {
                    formCtrl.diabetes.value = value!;
                    calculaFindrisk( );

                  });
                },
              )
                
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("EPOC", style: TextStyle(fontWeight: FontWeight.bold, )),
                Checkbox(
                value: formCtrl.epoc.value,
                onChanged: (bool? value) { 
                  setState(() {
                    formCtrl.epoc.value = value!;
                    calculaFindrisk( );

                    });
                  },
                )
                
              ],
            ),
          ],
        ),


        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Cancer", style: TextStyle(fontWeight: FontWeight.bold, )),
                Checkbox(
                value: formCtrl.cancer.value,
                onChanged: (bool? value) { 
                  setState(() {
                    formCtrl.cancer.value = value!;
                    calculaFindrisk( );

                    });
                  },
                )
                
              ],
            ),
            const SizedBox(width: 5),
            Obx( ()=>
              formCtrl.cancer.value == true ?
                Expanded(child: CustomInput(icon: Icons.list, placeholder: "TIPO DE CÁNCER", onchange: (p0) => formCtrl.tipo_cancer.value = p0))
              : const SizedBox()
            )
          ]
        ),

        CustomInput(icon: Icons.list,
        initialValue: formCtrl.otra_cronica.value,
        placeholder: "Otra enfermedad crónica: ¿Cuál?", onchange: (p0) => formCtrl.otra_cronica.value = p0)



       

      ]
    );
  }
}

class Preguntasfindrisk extends StatefulWidget {
  const Preguntasfindrisk({
    Key? key,
  }) : super(key: key);

  @override
  State<Preguntasfindrisk> createState() => _PreguntasfindriskState();
}

class _PreguntasfindriskState extends State<Preguntasfindrisk> {


  @override
  Widget build(BuildContext context) {
    final formCtrl = Get.find<FormController>();
    return Column(
      children:
        [ Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Ejercicio 30min", style: TextStyle(fontWeight: FontWeight.bold, )),
                Checkbox(
                value: formCtrl.ejercicio.value,
                onChanged: (bool? value) { 
                  setState(() {
                    formCtrl.ejercicio.value = value!;
                    calculaFindrisk( );

                  });
                },
              )
                
              ],
            ),
      
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Frutas/verduras diario", style: TextStyle(fontWeight: FontWeight.bold, )),
                Checkbox(
                value: formCtrl.verduras.value,
                onChanged: (bool? value) { 
                  setState(() {
                    formCtrl.verduras.value = value!;
                    calculaFindrisk( );

                  });
                },
              )
                
              ],
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Medicacion HTA", style: TextStyle(fontWeight: FontWeight.bold, )),
                Checkbox(
                value: formCtrl.medicacionhta.value,
                onChanged: (bool? value) { 
                  setState(() {
                    formCtrl.medicacionhta.value = value!;
                    calculaFindrisk( );

                  });
                },
              )
                
              ],
            ),
      
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Nivel algo de glucosa", style: TextStyle(fontWeight: FontWeight.bold, )),
                Checkbox(
                value: formCtrl.glucosa.value,
                onChanged: (bool? value) { 
                  setState(() {
                    formCtrl.glucosa.value = value!;
                    calculaFindrisk( );
                  });
                },
              )
                
              ],
            )
          ]
        ),

        Row(
          children: [
            const Text("Antecedentes familiares? (diabetes 1 o 2)"),
            Checkbox(
                value: formCtrl.antecedentes.value,
                onChanged: (bool? value) { 
                  setState(() {
                    if(formCtrl.antecedentes.value ==  false){
                      formCtrl.abuetioprimos.value = false;
                      formCtrl.padrehermhijos.value = false;
                    }
                    formCtrl.antecedentes.value = value!;
                    calculaFindrisk( );
                  });
                },
              )
          ],
        ),

        Obx(() =>
          formCtrl.antecedentes.value == true ?
            Column(
              children: [
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("si (abuelos, tíos, primos)"),
                    Checkbox(
                        value: formCtrl.abuetioprimos.value,
                        onChanged: (bool? value) { 
                          setState(() {
                            formCtrl.abuetioprimos.value = value!;
                            formCtrl.padrehermhijos.value = !value;
                            calculaFindrisk( );
                          });
                        },
                      )
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("si (padres, hermanos, hijos)"),
                    Checkbox(
                        value: formCtrl.padrehermhijos.value,
                        onChanged: (bool? value) { 
                          setState(() {
                            formCtrl.padrehermhijos.value = value!;
                            formCtrl.abuetioprimos.value = !value;
                            calculaFindrisk( );
                          });
                        },
                      )
                  ],
                ),
              ],
            )
          : const Divider()
        )
      ]
    );
  }
}

class _MenorCinco extends StatelessWidget {
  const _MenorCinco({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formCtrl = Get.find<FormController>();
    final TextEditingController brazoController = TextEditingController();

    return Obx( ()=>

      formCtrl.anos.value <= 5

      ? Column(
        children: [
          const Text("Perímetro brazo (Menores de 5 años)", style: TextStyle(fontWeight: FontWeight.bold, ),),
          CustomInput(icon: Icons.height , placeholder: "Ej: 10",  textInputType: TextInputType.number,
          initialValue: formCtrl.perimetroBrazo.value,
          onchange: (p0) {
            formCtrl.perimetroBrazo.value = p0;
          },),
        ],
      )
      : const Divider()
    );
  }
}

class _CheckAtiende extends StatefulWidget {
  const _CheckAtiende({
    Key? key,
  }) : super(key: key);

  @override
  State<_CheckAtiende> createState() => _CheckAtiendeState();
}

class _CheckAtiendeState extends State<_CheckAtiende> {


  @override
  Widget build(BuildContext context) {

    final formCtrl = Get.find<FormController>();

    return 
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Es la persona que atiende?"),
          Checkbox(
            value: formCtrl.personaAtiende.value,
            onChanged: (bool? value) { 
              setState(() {
                formCtrl.personaAtiende.value =  value!;
              });
            },
          )
        ],
      );
  }
}




class _CheckVacunas extends StatefulWidget {
  const _CheckVacunas({
    Key? key,
  }) : super(key: key);

  @override
  State<_CheckVacunas> createState() => _CheckVacunasState();
}

class _CheckVacunasState extends State<_CheckVacunas> {

  
  @override
  Widget build(BuildContext context) {

    final formCtrl = Get.find<FormController>();
    return 
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Esquema de vacunación completo (SI/NO)", overflow: TextOverflow.fade, maxLines: 2,),
          Checkbox(
            value: formCtrl.vacunasAlDia.value,
            onChanged: (bool? value) { 
              setState(() {
                formCtrl.vacunasAlDia.value =  value!;
              });
            },
          )
        ],
      );
  }
}


class _CheckGlucometria extends StatefulWidget {
  const _CheckGlucometria({
    Key? key,
  }) : super(key: key);

  @override
  State<_CheckGlucometria> createState() => __CheckGlucometriaState();
}

class __CheckGlucometriaState extends State<_CheckGlucometria> {

  final TextEditingController glucometriaController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    final formCtrl = Get.find<FormController>();

    return 
      Column(
        children:[
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Se toma Glucometria"),
              Checkbox(
                value: formCtrl.tieneGluco.value,
                onChanged: (bool? value) { 
                  setState(() {
                    formCtrl.tieneGluco.value = value!;
                  });
                },
              )
            ],
          ),

          if ( formCtrl.tieneGluco.value )
            const Text("Resultado de Glucometría (mg/dL)"),
          if ( formCtrl.tieneGluco.value )
            CustomInput(icon: Icons.thermostat , placeholder: "Ej (102)",
            onchange: (p0) => formCtrl.resGluco.value = p0,
            initialValue: formCtrl.resGluco.value, )
          
        ]
      );
  }
}




class RadioSexo extends StatefulWidget {
  const RadioSexo({super.key});

  @override
  State<RadioSexo> createState() => _RadioSexoState();
}

class _RadioSexoState extends State<RadioSexo> {

  @override
  Widget build(BuildContext context) {
    final formCtrl = Get.find<FormController>();
    return Row(
      children: [
        Expanded(
          child: RadioListTile(
                    title: const Text("Masculino"),
                    value: "Masculino", 
                    groupValue: formCtrl.sexo.value, 
                    onChanged: (value){
                      setState(() {
                          formCtrl.sexo.value = value.toString();
                      });
                    },
                ),
        ),
        
        Expanded(
          child: RadioListTile(
              title: const Text("Femenino"),
              value: "Femenino", 
              groupValue: formCtrl.sexo.value, 
              onChanged: (value){
                setState(() {
                    formCtrl.sexo.value = value.toString();
                });
              },
          ),
        ),
      ],
    );
  }
}


class AutoCompleteDiagnostico extends StatefulWidget {

  final Function(DiagnosticoModel)? onSelected;
  final TextEditingValue initialValue;
  const AutoCompleteDiagnostico({super.key, this.onSelected, required this.initialValue});

  @override
  State<StatefulWidget> createState() => _AutoCompleteDiagnosticoState();
}

class _AutoCompleteDiagnosticoState extends State<AutoCompleteDiagnostico> {



  _AutoCompleteDiagnosticoState();

  @override
  Widget build(BuildContext context) {
    return  Autocomplete<DiagnosticoModel>(
          optionsBuilder: (TextEditingValue textEditingValue) async {
            
            if (textEditingValue.text == '' || textEditingValue.text.length < 3) {
              
             return const Iterable<DiagnosticoModel>.empty();
            }
            final sugg =  await DBProvider.db.getDiagnosticosQuery( textEditingValue.text );
           

            final lsi1 = sugg
                .where(
                  (DiagnosticoModel county) => county.nombre.toLowerCase()
                .contains( textEditingValue.text )
            ).toList();


            final lsi2 = sugg
                .where(
                  (DiagnosticoModel county) => county.codigo.toLowerCase()
                .contains( textEditingValue.text )
            ).toList();

            return List.from(lsi2)..addAll(lsi1);

             


          },
          initialValue: widget.initialValue,
          displayStringForOption: (DiagnosticoModel option) => option.codigo,
          onSelected: widget.onSelected,
          optionsViewBuilder: (
              BuildContext context,
              AutocompleteOnSelected<DiagnosticoModel> onSelected,
              Iterable<DiagnosticoModel> options
              ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                child: Container(
                  width: 300,
                  color: Colors.cyan[300],
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final DiagnosticoModel option = options.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                        },
                        child: ListTile(
                          title: Text("${option.codigo} - ${option.nombre}", style: const TextStyle(color: Colors.white)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
  );
  }
}


void calculaFindrisk(  ) async {

  final formCtrl = Get.find<FormController>();
  int puntaje = 0;

  if(formCtrl.anos.value < 18){
    formCtrl.puntajeFINDRISCController.value!.text = "NA";
    formCtrl.riesgoFINDRISCController.value!.text = "NA";
    formCtrl.puntajeFINDRISC.value = "NA";
    formCtrl.riesgoFINDRISC.value = "NA";
    return;
  }

    puntaje +=  
        formCtrl.anos.value.ceil() < 45 ? 0
        : formCtrl.anos.value.ceil() >= 45 && formCtrl.anos.value.ceil() <= 54 ? 2 
        :  formCtrl.anos.value.ceil() >= 55 && formCtrl.anos.value.ceil() <= 64 ? 3
        : formCtrl.anos.value.ceil() > 64 ? 4 : 0;

  print("puntaje edad $puntaje");
  // calculo imc
  double? talla2 = double.tryParse(formCtrl.talla.value.replaceAll(',', '.'));
  talla2 = talla2 != null ? talla2 * talla2 : null;
  double? peso =  double.tryParse(formCtrl.peso.value.replaceAll(',', '.'));
  double imc;

  if(talla2 != null && peso != null){
    imc = peso/talla2;
    print("imc $imc");
    puntaje += imc < 25.0 ? 0
            : imc >= 25 && imc < 30 ? 1
            : imc > 30 ? 2 : 0;
  }

  print("puntaje imc $puntaje");

  // puntaje perimetro abdomincal
  double? perimetro = double.tryParse(formCtrl.perimetroAbdominal.value.replaceAll(',', '.'));

  if( perimetro != null && formCtrl.sexo.value != ""){

    if(formCtrl.sexo.value == "Masculino"){
      puntaje += perimetro <= 94 ? 0 : 4;
    } 

    if(formCtrl.sexo.value == "Femenino"){
      puntaje += perimetro <= 90 ? 0 : 4;
    } 
  }

  print("puntaje perimetro $puntaje");

  puntaje +=  formCtrl.ejercicio.value == true ? 0 : 2;
  
  
  puntaje +=  formCtrl.verduras.value == true ? 0 : 1;
  puntaje +=  formCtrl.medicacionhta.value == true ? 2 : 0;
  

  puntaje +=  formCtrl.glucosa.value == true ? 5 : 0;


  
  puntaje += formCtrl.abuetioprimos.value == true ? 3 : 0;
  puntaje += formCtrl.padrehermhijos.value == true ? 5 : 0;
  
  formCtrl.puntajeFINDRISCController.value!.text = puntaje.toString();
  formCtrl.puntajeFINDRISC.value = puntaje.toString();
  
   calculaRiesgo();
  
}

calculaRiesgo(){

  final formCtrl = Get.find<FormController>();

  formCtrl.riesgoFINDRISCController.value!.text = "";
  int? puntaje = int.tryParse(formCtrl.puntajeFINDRISC.value);

  if(puntaje != null){
    if( puntaje >= 0 && puntaje <=7 ){
    formCtrl.riesgoFINDRISCController.value!.text = "Nivel de riesgo bajo";
    formCtrl.riesgoFINDRISC.value = formCtrl.riesgoFINDRISCController.value!.text;
    return;
    }
    if( puntaje >= 8 && puntaje <=11 ){
      formCtrl.riesgoFINDRISCController.value!.text = "Nivel de riesgo ligeramente elevado";
      formCtrl.riesgoFINDRISC.value = formCtrl.riesgoFINDRISCController.value!.text;
      return;
    }
    if( puntaje >= 12 && puntaje <=14 ){
      formCtrl.riesgoFINDRISCController.value!.text = "Nivel de riesgo moderado";
      formCtrl.riesgoFINDRISC.value = formCtrl.riesgoFINDRISCController.value!.text;
      return;
    }
    if( puntaje >= 15 && puntaje <=20 ){
      formCtrl.riesgoFINDRISCController.value!.text = "Nivel de riesgo alto";
      formCtrl.riesgoFINDRISC.value = formCtrl.riesgoFINDRISCController.value!.text;
      return;
    }
    if( puntaje >= 21 ){
      formCtrl.riesgoFINDRISCController.value!.text = "Nivel de riesgo muy alto";
      formCtrl.riesgoFINDRISC.value = formCtrl.riesgoFINDRISCController.value!.text;
      return;
    }
    formCtrl.riesgoFINDRISC.value = formCtrl.riesgoFINDRISCController.value!.text;

  }else{
    formCtrl.puntajeFINDRISC.value = "NA";
    formCtrl.riesgoFINDRISCController.value!.text;
}
}

