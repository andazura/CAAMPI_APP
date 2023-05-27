import 'package:CAAPMI/controllers/form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class radioCustome extends StatefulWidget {

  final List<String> opciones;
  final Function(String?)? onchange;
  final String? groupValue;
  radioCustome({super.key, required this.opciones, this.onchange, this.groupValue});

  @override
  State<radioCustome> createState() => radioCustomeState();
}

class radioCustomeState extends State<radioCustome> {

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