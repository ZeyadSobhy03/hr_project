import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/routes/route_manger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hr_project/core/theme/theme_manger.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteManger.router,
      initialRoute: RouteManger.loginScreen,
      theme: ThemeManger.theme,
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [Locale('ar', 'EG')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
