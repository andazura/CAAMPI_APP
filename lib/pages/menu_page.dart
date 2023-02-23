import 'package:CAAPMI/controllers/registros_controller.dart';
import 'package:CAAPMI/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MenuScreen extends StatelessWidget {
   
  const MenuScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final reportesController =  Get.put(RegistrosController());
    return  Scaffold(
       
        body: _Pages(),
        bottomNavigationBar: Tabs(),
    );
  }
}

class _Pages extends StatelessWidget {
  const _Pages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final navegacionController = Get.put(NavegacionController());
    return PageView(
      controller: navegacionController.pageController,
      children: [
        FormRegistroPage(),
        MisRegistrosScreen()
      ],
    );
  }
}

class Tabs extends StatelessWidget {
  const Tabs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final navegacionController = Get.put(NavegacionController());
    final PageController _pageController = PageController();

    return Obx(
      ()=> 
      BottomNavigationBar(
        onTap: (page) => navegacionController.paginaActual = page,
        currentIndex: navegacionController.getpage.value!,
        items: const [
          BottomNavigationBarItem(
            label: 'Registros',
            icon:  Icon(FontAwesomeIcons.hospitalUser),
          ),
          BottomNavigationBarItem(
            label: 'Mis Registros',
            icon:  Icon(FontAwesomeIcons.notesMedical)
          )
        ],
      ),
    );
  }
}


class NavegacionController extends GetxController {
  final PageController _pageController = PageController();

  Rxn<int> get getpage => page;
  var page = Rxn<int>(0);

  set paginaActual(int valor) {


    this.page.value = valor;
    _pageController.animateToPage(valor,
        duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

  PageController get pageController => this._pageController;
  
}