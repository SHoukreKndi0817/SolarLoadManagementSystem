import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:volta/presentation/screen/home_screen.dart';
import 'package:volta/presentation/screen/profile_screen.dart';

import 'logic/cubit/authcubit_cubit.dart';
import 'presentation/screen/login_screen.dart';

void main() {
  runApp(MySunPowerApp());
}

class MySunPowerApp extends StatelessWidget {
  MySunPowerApp({Key? key}) : super(key: key);
final AuthcubitCubit _authcubitCubit = AuthcubitCubit();
// This widget is the root of your application.
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
      home:  SignInScreen(),
    ),
  );
}
}

