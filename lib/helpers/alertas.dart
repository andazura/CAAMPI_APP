import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


mosrtarAlerta( BuildContext context2, String titulo, String subtitulo) {

  final context = Get.context!;
  if( Platform.isAndroid ){
    return showDialog(context: context,
      builder: (_)=> AlertDialog(
        title: Text( titulo ),
        content: Text( subtitulo ),
        actions: [
          MaterialButton(
            child: Text("Ok"),
            elevation: 5,
            textColor: Colors.blue,
            onPressed: () => Navigator.pop(context)
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
          child: Text("Ok"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    )
  );
}