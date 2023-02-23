import 'package:CAAPMI/services/menu_service.dart';
import 'package:flutter/material.dart';

class FormGeneral extends StatelessWidget {
  
  final String titulo;
  final IconData iconoSeccion;
  final String optTap;
  final bool isSelected;
  final Widget form;

  const FormGeneral({required this.titulo, required this.iconoSeccion, required this.optTap, this.isSelected = false, required this.form});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => {
              if(menuService.getMenu() == optTap){
                menuService.setMenuOpt(""),
              }else{
                menuService.setMenuOpt(optTap)
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Container(
                padding: EdgeInsets.only(left: 15),
                color: isSelected ? Colors.blue : Colors.grey[300],
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(titulo),
                    const SizedBox(width: 20),
                    Icon(iconoSeccion),
                    const Spacer(),
                    const Icon(Icons.touch_app_outlined)
                  ],
                ),
              ),
            ),
          ),
          isSelected
          ? form
          : const SizedBox(width: 20),
        ],
      )
    );
  }
}