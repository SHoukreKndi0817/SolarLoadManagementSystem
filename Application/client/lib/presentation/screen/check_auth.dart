import 'package:client/presentation/screen/home_screen.dart';
import 'package:client/presentation/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubit/authcubit_cubit.dart';

class SplashScreen extends StatefulWidget {
  final bool user;
  SplashScreen(this.user);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startSplashScreen();
    BlocProvider.of<AuthcubitCubit>(context).loadLoginData();

  }

  startSplashScreen() {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (c) => widget.user ? HomeScreen(selectedIndex: 0) : SignInScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff02a2a2),
        body: Center(
          child: Text(
            "VoltA",
            style: TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ));
  }
}