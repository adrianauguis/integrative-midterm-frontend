import 'package:flutter/material.dart';
import 'package:integrative_midterm/pages/home_page.dart';
import 'package:integrative_midterm/pages/login_page.dart';

class widgetTree extends StatelessWidget {
  final bool loggedIn;
  const widgetTree({Key? key,required this.loggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Midterm Integrative Programming',
      home: loggedIn ? const HomePage() : const loginPage(),
    );
  }
}
