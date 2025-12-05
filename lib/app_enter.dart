import 'package:flutter/material.dart';
import 'package:flutter_cnode_app/pages/main/index.dart';
import 'package:flutter_cnode_app/pages/login.dart';

class AppEnter extends StatefulWidget {
  const AppEnter({super.key});

  @override
  State<AppEnter> createState() => _AppEnterState();
}

class _AppEnterState extends State<AppEnter> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
