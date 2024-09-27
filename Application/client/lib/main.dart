

import 'package:client/presentation/screen/check_auth.dart';
import 'package:client/presentation/screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'logic/cubit/authcubit_cubit.dart';
import 'presentation/screen/login_screen.dart';

void main() {
  runApp(MySunPowerApp());
}

class MySunPowerApp extends StatefulWidget {
  MySunPowerApp({Key? key}) : super(key: key);

  @override
  State<MySunPowerApp> createState() => _MySunPowerAppState();
}

class _MySunPowerAppState extends State<MySunPowerApp> {
final AuthcubitCubit _authcubitCubit = AuthcubitCubit();
bool user = false;

@override
void initState() {
  super.initState();
  _initCheck();


}

void _initCheck() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('user') != null) {
    setState(() {
      user = prefs.getBool('user')!;
    });
  }
}

@override
Widget build(BuildContext context) {
  return BlocProvider.value(
    value: _authcubitCubit,
    child: GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  SplashScreen(user),
    ),
  );
}
}

