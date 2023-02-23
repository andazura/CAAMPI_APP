import 'package:CAAPMI/pages/pages.dart';
import 'package:CAAPMI/services/auth_service.dart';
import 'package:CAAPMI/services/utils_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CAAPMI/services/db_service.dart';


class LoadingPage extends StatelessWidget {
   
  const LoadingPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot){
          return const Center(
            child: Text('Espere...'),
          );
        },
      ),
    );
  }

  Future checkLoginState( BuildContext context) async{

    final authService = Provider.of<AuthService>(context, listen: false);
    final autenticado = await authService.isLoggedIn();

    if( autenticado ){

      print("aut");
      // Navigator.pushReplacementNamed(context, 'menu');
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_,__,___) => MenuScreen(),
          transitionDuration: Duration(milliseconds: 0)
          )
      );
    }else{
      print("no auth");
      final utilsService = Provider.of<UtilsService>(context, listen: false);
      await getDataToRegistro(context);
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_,__,___) => LoginPage(),
          transitionDuration: Duration(milliseconds: 0)
          )
      );
      
    }
  }

  Future getDataToRegistro( BuildContext context ) async {

    final utilsService = Provider.of<UtilsService>(context,listen:false);

    if( DBProvider.localidades.length == 0 ) await utilsService.getLocalidades();
    if( DBProvider.regimenes.length == 0 ) await utilsService.getRegimenes();
    if( DBProvider.eps.length == 0 ) await utilsService.getEps();
    if(! await DBProvider.db.getDiaganosticos()  ) await utilsService.getDiagnosticos();

    return true;
  }

  
}