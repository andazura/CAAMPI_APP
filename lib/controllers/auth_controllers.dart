
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class AuthController extends GetxController{

  @override
  void onInit() async{
    print("Can autenticate llamdo");
    await canAuthenticate();
    super.onInit();
  }

    final canAuth = Rxn<bool>(false);
    final LocalAuthentication auth = LocalAuthentication();

    final availableBiometrics = Rxn<List<BiometricType>>(); 


    Future canAuthenticate() async {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
      print("can ${canAuthenticate}");
      if(canAuthenticate){
        await getAvailableBiometrics();
      }
      canAuth.value = (canAuthenticate && availableBiometrics.value!.contains(BiometricType.face) );
    }

    Future getAvailableBiometrics() async {
      availableBiometrics.value  = await auth.getAvailableBiometrics();
    }

    Future<bool> Autenticar() async {
      try {
          final bool didAuthenticate = await auth.authenticate(
              localizedReason: 'Por favor autenticate para ingresar');
          return didAuthenticate;
          // ยทยทยท
        } on PlatformException {
          return false;
        }
    }

}