import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:CAAPMI/helpers/alertas.dart';
import 'package:CAAPMI/services/auth_service.dart';
import 'package:CAAPMI/widgets/widgets.dart';

class RegisterPage extends StatelessWidget {
   
  const RegisterPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          primary: false,
          physics: const BouncingScrollPhysics(),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Logo(titulo: "Registro",),
                _Form(),
                const Labels(
                    route: 'login',
                    label: "Ya tienes cuenta?",
                    label2: "Ingresa ahora!",
                 ),
                const Text("Terminso y condiciones de uso", style: TextStyle(fontWeight: FontWeight.w200),)
              ],
            ),
          ),
        ),
      )
    );
  }
}

class _Form extends StatefulWidget {

  @override
  State<_Form> createState() => _FormStateState();
}

class _FormStateState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context,listen: true);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: "Nombre",
            textInputType: TextInputType.text,
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: "Correo",
            textInputType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: "Contraseña",
            textInputType: TextInputType.text,
            textController: passwCtrl,
            isPassword: true,
          ),
          
          //todo crear boton
          BotonAzul(
            onPress: authService.autenticando
            ? null
            : boton,
            textButton: "Crear cuenta"
          )
        ],
      ),
    );
  }

  void boton() async {
    final authService = Provider.of<AuthService>(context,listen: false);
    FocusScope.of(context).unfocus();
    if( nameCtrl.text.trim() == "" || emailCtrl.text.trim() == "" || passwCtrl.text.trim() == "" ) return mosrtarAlerta(  "Registro incorrecto" , "Ingrese todos los campos");
    final registerOk = await authService.register(nameCtrl.text.trim(),emailCtrl.text.trim(),passwCtrl.text.trim());
    if( registerOk == true ){
      Navigator.popAndPushNamed(context, 'form_registro');
    }else{
      mosrtarAlerta(  "Registro incorrecto" , registerOk,);
    }
  }
}
