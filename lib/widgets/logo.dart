import 'package:flutter/material.dart';

class Logo extends StatelessWidget {

  final String titulo;

  const Logo({super.key, required this.titulo});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170,
        margin: const EdgeInsets.only( top: 50 ),
        child: Column(
          children: [
            const Image(image: AssetImage('assets/icon/caapmi_icon.png')),
            const SizedBox( height: 20 ),
            Text(titulo, style: const TextStyle(fontSize: 30),),
          ],
        ),
      ),
    );
  }
}