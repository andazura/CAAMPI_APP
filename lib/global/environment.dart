
import 'dart:io';

class Environment{

  static String apiUrl = Platform.isAndroid
  ? 'server-caampiapp.onrender.com'
  : 'server-caampiapp.onrender.com';

  static String socketUrl = Platform.isAndroid
  ? 'server-caampiapp.onrender.com'
  : 'server-caampiapp.onrender.com';


}

