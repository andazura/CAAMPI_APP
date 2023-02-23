import 'package:flutter/material.dart';


class ContainerForms extends StatelessWidget {

  final Widget child;
  const ContainerForms({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: false,
      child: Container(
        padding: const EdgeInsets.only(top: 20,right: 10,left: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10,
              offset: Offset(1,5)
            )
          ]
        ),
        child: child,
      )
    );
  }
}