import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/theme.dart';
import 'config/routes.dart';
import 'core/routes/route_observer.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      /// ===============================
      /// THEME
      /// ===============================
      theme: ThemeData.from(
        colorScheme: AppTheme.light.colorScheme,
        useMaterial3: false, // ổn định DatePicker
      ),

      /// ===============================
      /// LOCALIZATION
      /// ===============================
      locale: const Locale('vi', 'VN'),
      supportedLocales: const [
        Locale('vi', 'VN'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      /// ===============================
      /// ROUTING
      /// ===============================
      initialRoute: Routes.splash,
      routes: Routes.pages,

      /// 🔥 BẮT BUỘC: để screen biết khi quay lại
      navigatorObservers: [
        routeObserver,
      ],
    );
  }
}
