import 'package:flutter/material.dart';
import 'package:integrative_midterm/widget_tree.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool loggedIn = prefs.getBool('loggedIn') ?? false;

  runApp(widgetTree(loggedIn: loggedIn));
}