import 'package:CAAPMI/controllers/form_controller.dart';
import 'package:CAAPMI/models/eps_response.dart';
import 'package:CAAPMI/models/localidad_response.dart';
import 'package:CAAPMI/models/regimen_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdownLocalidad extends StatefulWidget {

  final String hintText;
  final List<LocalidadesModel> itemsDrop;

  const CustomDropdownLocalidad({required this.hintText, required this.itemsDrop});

  @override
  State<CustomDropdownLocalidad> createState() => _CustomDropdownLocalidadState();
}

class _CustomDropdownLocalidadState extends State<CustomDropdownLocalidad> {

  @override
  Widget build(BuildContext context) {
    final formCtrl = Get.find<FormController>();
    return DropdownButton<String>(
      isExpanded: true,
      hint: Text(widget.hintText),
      value: formCtrl.localidad.value,
      style: const TextStyle(fontSize: 12,color: Colors.black54),
  items: widget.itemsDrop.map((value) {
    return DropdownMenuItem<String>(
          value: value.value,
          child: Text(value.codigo),
        );
      }).toList(),
      onChanged: (value) {
        
        if( value == null) return;

        formCtrl.localidad.value = value;
        setState(() { });
      },
    );
  }
}


class CustomDropdownEstrategia extends StatefulWidget {

  List<List<String>> estrategias =
   [
    ['PEC','PEC - (PIC, EQUIPOS DE ATENCIÓN EN CASA, CASA A CASA)'],
    ['PER','PER -(PIC, EQUIPOS DE ATENCIÓN EN CASA, RUTEO)'],
    ['PCC','PCC - (PIC, EQUIPOS DE ATENCIÓN EN CASA, CONGLOMERADO)'],
    ['ECP','ECP - (EQUIPOS DE ATENCIÓN EN CASA, RURAL EN CASA A CASA, PIC)'],
    ['ERP','ERP (EQUIPOS DE ATENCIÓN EN CASA, RURAL EN RUTEO, PIC)'],
   ];

  CustomDropdownEstrategia({super.key});

  @override
  State<CustomDropdownEstrategia> createState() => _CustomDropdownEstrategiaState();
}

class _CustomDropdownEstrategiaState extends State<CustomDropdownEstrategia> {

  @override
  Widget build(BuildContext context) {
    final formCtrl = Get.find<FormController>();
    return DropdownButton<String>(
      isExpanded: true,
      hint: const Text("Estrategia"),
      value: formCtrl.estrateegia.value,
      style: const TextStyle(fontSize: 12,color: Colors.black54),
  items: widget.estrategias.map((value) {
    return DropdownMenuItem<String>(
          value: value[0],
          child: Text(value[1]),
        );
      }).toList(),
      onChanged: (value) {
        
        if( value == null) return;
        formCtrl.estrateegia.value = value;
        setState(() { });
      },
    );
  }
}



class CustomDropdownEquipo extends StatefulWidget {

  List<List<String>> estrategias =
   [
    ['EQ094','EQ094'],
   ];

  CustomDropdownEquipo({super.key});

  @override
  State<CustomDropdownEquipo> createState() => _CustomDropdownEquipoState();
}

class _CustomDropdownEquipoState extends State<CustomDropdownEquipo> {

  @override
  Widget build(BuildContext context) {
    final formCtrl = Get.find<FormController>();
    return DropdownButton<String>(
      isExpanded: true,
      hint: const Text("Equipo"),
      value: formCtrl.equipo.value,
      style: const TextStyle(fontSize: 12,color: Colors.black54),
  items: widget.estrategias.map((value) {
    return DropdownMenuItem<String>(
          value: value[0],
          child: Text(value[1]),
        );
      }).toList(),
      onChanged: (value) {
        
        if( value == null) return;
        formCtrl.equipo.value = value;
        setState(() { });
      },
    );
  }
}


class CustomDropdownTipoCC extends StatefulWidget {

  List<List<String>> estrategias =
   [
    ['CC','CC = Cédula ciudadanía'],
    ['CE','CE = Cédula de extranjería'],
    ['CD','CD = Carné diplomático '],
    ['PA','PA = Pasaporte'],
    ['PE','PE = Permiso Especial de Permanencia'],
    ['PPT','PPT = Permiso por Protección Temporal'],
    ['RC','RC = Registro civil'],
    ['TI','TI = Tarjeta de identidad'],
    ['CN','CN = Certificado de nacido vivo'],
    ['AS','AS = Adulto sin identificar'],
    ['MS','MS = Menor sin identificar'],
   ];

  @override
  State<CustomDropdownTipoCC> createState() => _CustomDropdownTipoCCState();
}

class _CustomDropdownTipoCCState extends State<CustomDropdownTipoCC> {

    final formCtrl = Get.find<FormController>();


  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      hint: const Text("Tipo Doc."),
      value: formCtrl.tipoDocumento.value,
      style: const TextStyle(fontSize: 12,color: Colors.black54),
  items: widget.estrategias.map((value) {
    return DropdownMenuItem<String>(
          value: value[0],
          child: Text(value[1]),
        );
      }).toList(),
      onChanged: (value) {
        
        if( value == null) return;
        formCtrl.tipoDocumento.value = value;
        setState(() { });
      },
    );
  }
}


class CustomDropdownRegimen extends StatefulWidget {

  final String hintText;
  final List<RegimenModel> itemsDrop;

  const CustomDropdownRegimen({super.key, required this.hintText, required this.itemsDrop});

  @override
  State<CustomDropdownRegimen> createState() => _CustomDropdownRegimentate();
}

class _CustomDropdownRegimentate extends State<CustomDropdownRegimen> {

  @override
  Widget build(BuildContext context) {

    final formCtrl = Get.find<FormController>();
    return DropdownButton<String>(
      isExpanded: true,
      hint: Text(widget.hintText),
      value: formCtrl.regimen.value,
      style: const TextStyle(fontSize: 12,color: Colors.black54),
  items: widget.itemsDrop.map((value) {
    return DropdownMenuItem<String>(
          value: value.regimen,
          child: Text(value.regimen),
        );
      }).toList(),
      onChanged: (value) {
        
        if( value == null) return;
        formCtrl.regimen.value = value;
        setState(() { });
      },
    );
  }
}

class CustomDropdownNacionalidad extends StatefulWidget {

  List<List<String>> nacionalidad =
   [
    ['Colombiano','Colombiano'],
    ['Venezolano','Venezolano'],
    ['Otro','Otro'],
   ];

  CustomDropdownNacionalidad({super.key});

  @override
  State<CustomDropdownNacionalidad> createState() => _CustomDropdownNacionalidadState();
}

class _CustomDropdownNacionalidadState extends State<CustomDropdownNacionalidad> {

  @override
  Widget build(BuildContext context) {
    final formCtrl = Get.find<FormController>();
    return DropdownButton<String>(
      isExpanded: true,
      hint: const Text("Nacionalidad"),
      value: formCtrl.nacionalidad.value,
      style: const TextStyle(fontSize: 12,color: Colors.black54),
  items: widget.nacionalidad.map((value) {
    return DropdownMenuItem<String>(
          value: value[0],
          child: Text(value[1]),
        );
      }).toList(),
      onChanged: (value) {
        
        if( value == null) return;
        formCtrl.nacionalidad.value = value; 
        setState(() { });
      },
    );
  }
}




class CustomDropdownGrupoPoblacion extends StatefulWidget {

  List<List<String>> grupo_poblacion =
   [
    ['Habitantes de calle','Habitantes de calle'],
    ['Migrantes','Migrantes'],
    ['Persona en condición de discapacidad','Persona en condición de discapacidad'],
    ['Personas en prisión domiciliaria a cargo del INPEC','Personas en prisión domiciliaria a cargo del INPEC'],
    ['Población desmovilizada','Población desmovilizada'],
    ['Población infantil abandonada a cargo del Instituto Colombiano de Bienestar Familiar','Población infantil abandonada a cargo del Instituto Colombiano de Bienestar Familiar'],
    ['Población infantil vulnerable bajo protección de instituciones diferentes al ICBF','Población infantil vulnerable bajo protección de instituciones diferentes al ICBF'],
    ['Comunidades LGTBIQ+','Comunidades LGTBIQ+'],
    ['Comunidades indígenas','Comunidades indígenas'],
    ['Madre Comunitaria','Madre Comunitaria'],
    ['Personas que ejerce actividades sexuales pagas','Personas que ejerce actividades sexuales pagas'],
    ['Recién nacidos y menores de edad de padres no afiliados','Recién nacidos y menores de edad de padres no afiliados'],
    ['Rrom (Gitano)','Rrom (Gitano)'],
    ['Víctimas del conflicto armado interno','Víctimas del conflicto armado interno'],
    ['Otra población','Otra población'],
   ];

  CustomDropdownGrupoPoblacion({super.key});

  @override
  State<CustomDropdownGrupoPoblacion> createState() => _CustomDropdownGrupoPoblacionState();
}

class _CustomDropdownGrupoPoblacionState extends State<CustomDropdownGrupoPoblacion> {

  @override
  Widget build(BuildContext context) {

    final formCtrl = Get.find<FormController>();

    return DropdownButton<String>(
      isExpanded: true,
      hint: const Text("Grupo Población"),
      value: formCtrl.grupoPoblacion.value,
      style: const TextStyle(fontSize: 12,color: Colors.black54),
  items: widget.grupo_poblacion.map((value) {
    return DropdownMenuItem<String>(
          value: value[0],
          child: Text(value[1]),
        );
      }).toList(),
      onChanged: (value) {
        
        if( value == null) return;
        formCtrl.grupoPoblacion.value = value;
        setState(() { });
      },
    );
  }
}


class CustomDropdownEps extends StatefulWidget {

  final List<EpsModel> eps;

  CustomDropdownEps({super.key, required this.eps});

  @override
  State<CustomDropdownEps> createState() => _CustomDropdownEpsState();
}

class _CustomDropdownEpsState extends State<CustomDropdownEps> {

  @override
  Widget build(BuildContext context) {

    final formCtrl = Get.find<FormController>();
    return DropdownButton<String>(
      isExpanded: true,
      hint: const Text("Eps"),
      value: formCtrl.eps.value,
      style: const TextStyle(fontSize: 12,color: Colors.black54),
  items: widget.eps.map((value) {
    return DropdownMenuItem<String>(
          value: value.eapb,
          child: Text(value.eapb),
        );
      }).toList(),
      onChanged: (value) {
        
        if( value == null) return;
        formCtrl.eps.value = value;
        setState(() { });
      },
    );
  }
}



class CustomDropdownTipoDiagnostico extends StatefulWidget {

  List<List<String>> tipo_diag =
   [
    ['Impresión diagnóstica','Impresión diagnóstica'],
    ['Confirmado nuevo','Confirmado nuevo'],
    ['Confirmado repetido','Confirmado repetido'],
   ];

  CustomDropdownTipoDiagnostico({super.key});

  @override
  State<CustomDropdownTipoDiagnostico> createState() => _CustomDropdownTipoDiagnosticoState();
}

class _CustomDropdownTipoDiagnosticoState extends State<CustomDropdownTipoDiagnostico> {

  @override
  Widget build(BuildContext context) {

    final formCtrl = Get.find<FormController>();

    return DropdownButton<String>(
      isExpanded: true,
      hint: const Text("Tipo de diagnóstico principal"),
      value: formCtrl.tipoDiagnostico.value,
      style: const TextStyle(fontSize: 12,color: Colors.black54),
  items: widget.tipo_diag.map((value) {
    return DropdownMenuItem<String>(
          value: value[0],
          child: Text(value[1]),
        );
      }).toList(),
      onChanged: (value) {
        
        if( value == null) return;
        formCtrl.tipoDiagnostico.value = value;
        setState(() { });
      },
    );
  }
}


class CustomDropdownPruebaTratamiento extends StatefulWidget {

  List<List<String>> nacionalidad =
   [
    ['Tratamiento Sífilis Gestacional','Tratamiento Sífilis Gestacional'],
    ['',''],
    ['Prueba apetito Niños y niñas entre 6 y 59 meses DNT Aguda','Prueba apetito Niños y niñas entre 6 y 59 meses DNT Aguda']
   ];

  CustomDropdownPruebaTratamiento({super.key});

  @override
  State<CustomDropdownPruebaTratamiento> createState() => _CustomDropdownPruebaTratamientoState();
}

class _CustomDropdownPruebaTratamientoState extends State<CustomDropdownPruebaTratamiento> {

  @override
  Widget build(BuildContext context) {

    final formCtrl = Get.find<FormController>();

    return DropdownButton<String>(
      isExpanded: true,
      hint: const Text("Prueba / Tratamiento"),
      value: formCtrl.tratamiento.value,
      style: const TextStyle(fontSize: 12,color: Colors.black54),
  items: widget.nacionalidad.map((value) {
    return DropdownMenuItem<String>(
          value: value[0],
          child: Text(value[1]),
        );
      }).toList(),
      onChanged: (value) {
        
        if( value == null) return;
        formCtrl.tratamiento.value = value;
        setState(() { });
      },
    );
  }
}



class CustomDropdownVacunaQuien extends StatefulWidget {

  List<List<String>> quien =
   [
    ['Menor de 5 años','Menor de 5 años'],
    ['Gestante','Gestante'],
    ['Población con dificultades de movilidad','Población con dificultades de movilidad'],
    ['Otro','Otro'],
    ['',''],
   ];

  CustomDropdownVacunaQuien({super.key});

  @override
  State<CustomDropdownVacunaQuien> createState() => _CustomDropdownVacunaQuienState();
}

class _CustomDropdownVacunaQuienState extends State<CustomDropdownVacunaQuien> {

  @override
  Widget build(BuildContext context) {

    final formCtrl = Get.find<FormController>();

    return DropdownButton<String>(
      isExpanded: true,
      hint: const Text("¿Quién?"),
      value: formCtrl.vacunaQuien.value,
      style: const TextStyle(fontSize: 12,color: Colors.black54),
  items: widget.quien.map((value) {
    return DropdownMenuItem<String>(
          value: value[0],
          child: Text(value[1]),
        );
      }).toList(),
      onChanged: (value) {
        
        if( value == null) return;
        formCtrl.vacunaQuien.value = value;
        setState(() { });
      },
    );
  }
}


class CustomDropdownOrdenCitoProMa extends StatefulWidget {

  List<List<String>> orden =
   [
    ['Citología','Citología'],
    ['Mamografía','Mamografía'],
    ['Prostata','Prostata'],
    ['No aplica','No aplica'],
    ['',''],
    ['Citología- mamografia','Citología- mamografia'],
   ];

  CustomDropdownOrdenCitoProMa({super.key});

  @override
  State<CustomDropdownOrdenCitoProMa> createState() => _CustomDropdownOrdenCitoProMaState();
}

class _CustomDropdownOrdenCitoProMaState extends State<CustomDropdownOrdenCitoProMa> {


  @override
  Widget build(BuildContext context) {

    final formCtrl = Get.find<FormController>();

    return Column(
      children: 
      [
        const Text("Orden citología / mamografía / próstata"),
        DropdownButton<String>(
          isExpanded: true,
          hint: const Text("Orden citología / mamografía / próstata"),
          value: formCtrl.citomapro.value,
          style: const TextStyle(fontSize: 12,color: Colors.black54),
        items: widget.orden.map((value) {
        return DropdownMenuItem<String>(
              value: value[0],
              child: Text(value[1]),
            );
          }).toList(),
          onChanged: (value) {
            
            if( value == null) return;
            formCtrl.citomapro.value = value;
            setState(() { });
          },
        )
      ]
    );
  }
} 




class CustronDropDownCanalizacionRias extends StatefulWidget {
  const CustronDropDownCanalizacionRias({super.key});

  @override
  State<CustronDropDownCanalizacionRias> createState() => _CustronDropDownCanalizacionRiasState();
}

class _CustronDropDownCanalizacionRiasState extends State<CustronDropDownCanalizacionRias> {

  List<List<String>> canalizacionRias = [
    ['Ruta De Promoción Y Mantenimiento De La Salud','Ruta De Promoción Y Mantenimiento De La Salud'],
    ['Población con riesgo o presencia de alteraciones cardio — cerebro — vascular — metabólicas manifiestas','Población con riesgo o presencia de alteraciones cardio — cerebro — vascular — metabólicas manifiestas'],
    ['Población con riesgo o presencia de enfermedades respiratorias crónicas.','Población con riesgo o presencia de enfermedades respiratorias crónicas.'],
    ['Población con riesgo o presencia de alteraciones nutricionales.','Población con riesgo o presencia de alteraciones nutricionales.'],
    ['Población con riesgo o presencia de trastornos mentales y del comportamiento manifiestos debido a uso de sustancias psicoactivas y adicciones','Población con riesgo o presencia de trastornos mentales y del comportamiento manifiestos debido a uso de sustancias psicoactivas y adicciones'],
    ['Población con riesgo o presencia de trastornos psicosociales y del comportamiento.','Población con riesgo o presencia de trastornos psicosociales y del comportamiento.'],
    ['Población con riesgo o presencia de alteraciones en la salud bucal.','Población con riesgo o presencia de alteraciones en la salud bucal.'],
    ['Población con riesgo o presencia de cáncer.','Población con riesgo o presencia de cáncer.'],
    ['Población materno — perinatal','Población materno — perinatal'],
    ['Población con riesgo o presencia de enfermedades infecciosas.','Población con riesgo o presencia de enfermedades infecciosas.'],
    ['No aplica','No aplica']
  ];

  final formCtrl = Get.find<FormController>();


  @override
  Widget build(BuildContext context) {
    return Column(
      children: 
      [
        const Text("Canalización a RIAS"),
        DropdownButton<String>(
          isExpanded: true,
          hint: const Text("Canalización a RIAS"),
          value: formCtrl.canalizacion_rias.value,
          style: const TextStyle(fontSize: 12,color: Colors.black54),
        items: canalizacionRias.map((value) {
        return DropdownMenuItem<String>(
              value: value[0],
              child: Text(value[1]),
            );
          }).toList(),
          onChanged: (value) {
            
            if( value == null) return;
            formCtrl.canalizacion_rias.value = value;
            setState(() { });
          },
        )
      ]
    );
  }
}


class TipoAtencion extends StatefulWidget {
  const TipoAtencion({super.key});

  @override
  State<TipoAtencion> createState() => _TipoAtencionState();
}

class _TipoAtencionState extends State<TipoAtencion> {
  
  List<List<String>> tipos_atencions = [
    ['Resolutivo','Resolutivo'],
    ['P y D','P y D'],
    ['Educación en Salud','Educación en Salud']
  ];

  final formCtrl = Get.find<FormController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: 
      [
        const Text("Tipo de atención"),
        DropdownButton<String>(
          isExpanded: true,
          hint: const Text("Tipo de atención"),
          value: formCtrl.tipo_atencion.value,
          style: const TextStyle(fontSize: 12,color: Colors.black54),
        items: tipos_atencions.map((value) {
        return DropdownMenuItem<String>(
              value: value[0],
              child: Text(value[1]),
            );
          }).toList(),
          onChanged: (value) {
            
            if( value == null) return;
            formCtrl.tipo_atencion.value = value;
            setState(() { });
          },
        )
      ]
    );
  }
}