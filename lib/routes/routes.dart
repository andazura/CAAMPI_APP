import 'package:flutter/material.dart';

import 'package:CAAPMI/pages/pages.dart';

final Map<String, WidgetBuilder> appRoutes = {
  'loading': (_) => LoadingPage(),
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'form_registro': (_) => FormRegistroPage(),
  'menu': (_) => MenuScreen(),
};