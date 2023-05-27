import 'package:CAAPMI/controllers/auth_controllers.dart';
import 'package:CAAPMI/helpers/alertas.dart';
import 'package:CAAPMI/services/auth_service.dart';
import 'package:CAAPMI/services/utils_service.dart';
import 'package:CAAPMI/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:CAAPMI/services/db_service.dart';

class LoginPage extends StatelessWidget {
   
  const LoginPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Logo(titulo: "CAAPMI"),
              _Form(),
              const Labels( route: 'register', label: "¿No tienes cuenta?", label2: "Crea una ahora!" ),
              const Text("Terminso y condiciones de uso", style: TextStyle(fontWeight: FontWeight.w200),)
            ],
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

  final emailCtrl = TextEditingController();
  final passwCtrl = TextEditingController();

  final auController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: true);
    
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
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
            textButton: "Ingresar"
          ),

          Obx(() => 
            auController.canAuth.value!
            ? _auth_bio(auController: auController, onPressed: loginBiometrics,)
            : const SizedBox()
          )
        ],
      ),
    );
  }

  void boton() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    FocusScope.of(context).unfocus();

    if ( emailCtrl.text.trim() == "" || passwCtrl.text.trim() == "" ) return  mosrtarAlerta( "Credenciales invalidas", "Intenta de nuevo");
    showLoadingMessage(mensaje: "Iniciando sesión");
    final loginOk = await authService.login(emailCtrl.text.trim(), passwCtrl.text.trim());
    Navigator.pop(context);
    if( loginOk ){
      showLoadingMessage(mensaje: "Descargando información necesaria");
      await getDataToRegistro();
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, "menu");
    }else{
      mosrtarAlerta( "Credenciales invalidas", "Intenta de nuevo");
    }
  }

  void loginBiometrics() async {

    final authService = Provider.of<AuthService>(context, listen: false);
    final credenciales = await authService.getCredenciales();
        if(credenciales!.isEmpty){
          mosrtarAlerta( "Error", "Aun no te has logueado, ingresa para posteriormente usar Face Id");
          return;
        }
        final auth = await auController.autenticar();
        if(auth){
          emailCtrl.text = credenciales[0];
          passwCtrl.text = credenciales[1];
          boton();
        }
  }

  Future getDataToRegistro() async {

    final utilsService = Provider.of<UtilsService>(context,listen:false);
    
    if( DBProvider.localidades.length == 0 ) await utilsService.getLocalidades();
    if( DBProvider.regimenes.length == 0 ) await utilsService.getRegimenes();
    if( DBProvider.eps.length == 0 ) await utilsService.getEps();
    if(! await DBProvider.db.getDiaganosticos()  ) await utilsService.getDiagnosticos();

    return true;
  }
}

class _auth_bio extends StatelessWidget {

  final void Function()? onPressed;
  const _auth_bio({
    super.key,
    required this.auController, this.onPressed,
  });

  
  final AuthController auController;

  @override
  Widget build(BuildContext context) {
    
    return IconButton(
      onPressed: onPressed,
    icon: const Icon(FontAwesomeIcons.fingerprint));
  }
}
