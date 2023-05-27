import 'package:flutter/material.dart';

import 'package:CAAPMI/pages/pages.dart';

final Map<String, WidgetBuilder> appRoutes = {
  'loading': (_) => const LoadingPage(),
  'login': (_) => const LoginPage(),
  'register': (_) => const RegisterPage(),
  'form_registro': (_) => const FormRegistroPage(),
  'menu': (_) => const MenuScreen(),
};