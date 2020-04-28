import 'package:flutter/material.dart';
import 'package:monitoring_apps/pages/login_page.dart';
import 'package:monitoring_apps/pages/main_page.dart';
import 'package:monitoring_apps/utils/user_repository.dart';

void main() => runApp(MyApp());



class MyApp extends StatefulWidget
{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
{
  bool hasToken = false;
  @override
  void initState() {
    super.initState();
    UserRepository().isLogin().then((val){
      hasToken =val;
      setState(() {});
    });
     print(hasToken);
  } 
  @override
  Widget build(BuildContext context){
    return MaterialApp
    (
      title: 'Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: hasToken?MainPage():LoginPage(),
    );
  }
  
}