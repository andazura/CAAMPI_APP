import 'package:CAAPMI/helpers/alertas.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {

  final IconData icon;
  final String placeholder;
  final TextEditingController? textController;
  final TextInputType textInputType; 
  final bool isPassword;
  final TextCapitalization textCaptilizacion;
  final String? initialValue;
  final void Function(String)? onchange;
  final String? Function(String?)? validator;
  final bool? enable;
  final FocusNode? focusNode;
  final Function(PointerDownEvent)? onTapOutside;
final void Function()? onediting; 

  const CustomInput({
    super.key,
    required this.icon,
    required this.placeholder,
    this.textController,
    this.textInputType = TextInputType.text,
    this.isPassword = false,
    this.textCaptilizacion = TextCapitalization.none,
    this.initialValue,
    this.onchange,
    this.validator,
    this.enable,
    this.onediting,
    this.focusNode, this.onTapOutside
  });


  @override
  Widget build(BuildContext context) {

    if(initialValue != null &&  textController != null){

      textController!.text = initialValue != null ? initialValue!  : "";
    } 

    return Container(
      margin: const EdgeInsets.only(bottom: 30),
            padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0,5),
                  blurRadius: 5
                )
              ]
            ),
            child: TextFormField(
              onTapOutside: onTapOutside,
              enabled: enable,
              initialValue: textController != null ? null : initialValue,
              validator: validator,
              textCapitalization: textCaptilizacion,
              autocorrect: false,
              controller: textController,
              keyboardType: textInputType,
              obscureText: isPassword,
              focusNode: focusNode,
              decoration: InputDecoration(
                prefixIcon: Icon( icon ),
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                hintText: placeholder
              ),
              onChanged: onchange,
              onEditingComplete: onediting,
            ),
          );
  }
}