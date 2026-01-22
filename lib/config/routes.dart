import 'package:flutter/material.dart';

import '../features/splash/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/main/main_screen.dart';
import '../features/work/register/work_register_screen.dart';

class Routes {
  static const splash = '/';
  static const login = '/login';
  static const main = '/main';
  static const workRegister = '/work-register';

  static final pages = <String, WidgetBuilder>{
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    main: (_) => const MainScreen(),
    workRegister: (_) => const WorkRegisterScreen(),
  };
}
