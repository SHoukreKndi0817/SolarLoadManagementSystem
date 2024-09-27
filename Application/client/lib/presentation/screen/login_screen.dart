import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../logic/cubit/authcubit_cubit.dart';
import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  // Method to save login status
  Future<void> _saveLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('user', true); // Save the login status as true
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthcubitCubit, AuthcubitState>(
      listener: (context, state) async {
        if (state is AuthcubitWaiting) {
          print('Waiting for login...');
          SimpleCircularProgressBar(
            size: 80,
            progressStrokeWidth: 25,
            backStrokeWidth: 25,
          );
        } else if (state is AuthcubitLogedClient) {
          String? msg = state.authResponse.msg.toString();

          // Save the login status
          await _saveLoginStatus();

          // Show success dialog and navigate to HomeScreen
          showDialog(
            context: context,
            barrierDismissible: false, // Prevent closing by tapping outside
            builder: (BuildContext context) {
              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pop(true); // Close the dialog
                Get.off(HomeScreen(selectedIndex: 0)); // Navigate to HomeScreen
              });

              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          msg,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is AuthcubitNoLogedClient) {
          String? msg = state.authResponse.msg.toString();

          showDialog(
            context: context,
            barrierDismissible: false, // Prevent closing by tapping outside
            builder: (BuildContext context) {
              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pop(true); // Close the dialog
              });

              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          msg,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          Center(
            child: CircularProgressIndicator(
              color: Colors.yellow,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeInUp(
                          duration: Duration(seconds: 1),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/light-1.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeInUp(
                          duration: Duration(milliseconds: 1200),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/light-2.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeInUp(
                          duration: Duration(milliseconds: 1300),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/clock.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: FadeInUp(
                          duration: Duration(milliseconds: 1600),
                          child: Container(
                            margin: EdgeInsets.only(top: 50),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeInUp(
                        duration: Duration(milliseconds: 1800),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Color.fromRGBO(71, 108, 241, 1.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(143, 148, 251, .2),
                                blurRadius: 20.0,
                                offset: Offset(0, 10),
                              )
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color.fromRGBO(71, 108, 241, 1.0),
                                    ),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: emailController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return ("Please Enter Your Email");
                                    } else if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                        .hasMatch(value)) {
                                      return ("Please Enter a valid email");
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    emailController.text = value!;
                                    print(value);
                                  },
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email or Phone number",
                                    hintStyle:
                                    TextStyle(color: Colors.grey[700]),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: passwordController,
                                  validator: (value) {
                                    RegExp regex = RegExp(r'^.{6,}$');
                                    if (value!.isEmpty) {
                                      return ("Password is required for login");
                                    } else if (!regex.hasMatch(value)) {
                                      return ("Enter Valid Password(Min. 6 Character)");
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    passwordController.text = value!;
                                    print(value);
                                  },
                                  textInputAction: TextInputAction.done,
                                  obscureText: _obscureText,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle:
                                    TextStyle(color: Colors.grey[700]),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      child: Icon(
                                        _obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      FadeInUp(
                        duration: Duration(milliseconds: 1900),
                        child: GestureDetector(
                          onTap: () {
                            // Call the login method
                            BlocProvider.of<AuthcubitCubit>(context).loginClientMethod(
                                username: emailController.text,
                                password: passwordController.text);
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(12, 57, 225, 1.0),
                                Color.fromRGBO(143, 148, 251, .6),
                              ]),
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 70),
                      FadeInUp(
                        duration: Duration(milliseconds: 2000),
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Color.fromRGBO(71, 108, 241, 1.0)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
