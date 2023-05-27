import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


mosrtarAlerta( String titulo, String subtitulo) {

  final context = Get.context!;
  if( Platform.isAndroid ){
    return showDialog(context: context,
      builder: (_)=> AlertDialog(
        title: Text( titulo ),
        content: Text( subtitulo ),
        actions: [
          MaterialButton(
            elevation: 5,
            textColor: Colors.blue,
            onPressed: () => Navigator.pop(context),
            child: const Text("Ok")
          )
        ],
      )
    );
  }


  showCupertinoDialog(context: context,
  builder: (_) => CupertinoAlertDialog(
      title: Text( titulo ),
      content: Text( subtitulo ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text("Ok"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    )
  );
}


showLoadingMessage({String? mensaje}){

  final context = Get.context!;
  if( Platform.isAndroid ){
      showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: mensaje == null ?  const Text("Espere por favor") : Text(mensaje),
        content: Container(
          margin: const EdgeInsets.only( top: 10 ),
          width: 100,
          height: 100,
          child: Column(
            children: const [
              Text(""),
              SizedBox( height:  15 ),
              CircularProgressIndicator( strokeWidth: 3, color: Colors.black, )
            ],
          ),
        ),
      ) 
    );
    return;
  }
  
  showCupertinoDialog(
    context: context,
    builder: (context) =>  CupertinoAlertDialog(
      title: mensaje == null ?  const Text("Espere por favor") : Text(mensaje),
      content: const Padding(
        padding: EdgeInsets.only(top: 15),
        child: CupertinoActivityIndicator()),
    )
    );

}
