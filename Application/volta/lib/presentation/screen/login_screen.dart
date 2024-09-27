import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:volta/presentation/screen/profile_screen.dart';

import '../../logic/cubit/authcubit_cubit.dart';
import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;


  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthcubitCubit, AuthcubitState>(
      listener: (context, state) async {
        if(state is AuthcubitWaiting){
          print('12345678909876543');
          SimpleCircularProgressBar(
            size: 80,
            progressStrokeWidth: 25,
            backStrokeWidth: 25,
          );
        }
        else if (state is AuthcubitLoged) {
          String? msg = state.authResponse.msg.toString();

          showDialog(
            context: context,
            barrierDismissible: false, // Prevent closing by tapping outside
            builder: (BuildContext context) {
              // Automatically close the dialog after 3 seconds
              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pop(true); // Close the dialog
                // Navigate to the HomeScreen after the dialog is closed
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => HomeScreen(selectedIndex: 0)),
                // );
                Get.off(HomeScreen(selectedIndex: 0));
              });

              return AlertDialog(
                contentPadding: EdgeInsets.zero, // Remove default padding
                backgroundColor: Colors.transparent, // Set background to transparent
                elevation: 0, // Remove the default elevation
                content: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the dialog
                    borderRadius: BorderRadius.circular(10), // Border radius for rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26, // Shadow color
                        blurRadius: 10, // Spread of the shadow
                        offset: Offset(0, 5), // Offset of the shadow
                      ),
                    ],
                    border: Border.all(
                      color: Colors.blue, // Border color
                      width: 2, // Border width
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
        }
        else if (state is AuthcubitNoLoged) {
          String? msg = state.authResponse.msg.toString();

          showDialog(
            context: context,
            barrierDismissible: false, // Prevent closing by tapping outside
            builder: (BuildContext context) {
              // Automatically close the dialog after 3 seconds
              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pop(true); // Close the dialog
                // Navigate to the HomeScreen after the dialog is closed
              });

              return AlertDialog(
                contentPadding: EdgeInsets.zero, // Remove default padding
                backgroundColor: Colors.transparent, // Set background to transparent
                elevation: 0, // Remove the default elevation
                content: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the dialog
                    borderRadius: BorderRadius.circular(10), // Border radius for rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26, // Shadow color
                        blurRadius: 10, // Spread of the shadow
                        offset: Offset(0, 5), // Offset of the shadow
                      ),
                    ],
                    border: Border.all(
                      color: Colors.blue, // Border color
                      width: 2, // Border width
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

        }
        else {
          print("mccmmc");
          Center(
            child: CircularProgressIndicator(
              color: Colors.yellow,
            ),
          );
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 100,),

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Positioned(
                    top: 60,
                    left: 20,
                    child: Text(
                      'My',
                      style: TextStyle(
                        fontFamily: 'Handwriting', // Use a handwriting font if available
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: 60,
                    child: Text(
                      'VoltA',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],),
              SizedBox(height: 20,),


// Top Image
              Stack(
                children: [
                  Image.asset(
                    'assets/images/1.png', // replace with your image path
                    fit: BoxFit.cover,
                  ),

                ],
              ),
              SizedBox(height: 20),
// Sign In Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
// Email Field
                    TextFormField(
                        autofocus: false,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please Enter Your Email");
                          }
                          // reg expression for email validation
                          else if (!RegExp(
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
                          prefixIcon: const Icon(Icons.mail),
                          contentPadding:
                          const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "User Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )),
                    SizedBox(height: 20),
// Password Field
                    TextFormField(
                      autofocus: false,
                      controller: passwordController,
                      obscureText: _obscureText,
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
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.vpn_key),
                        contentPadding:
                        const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Password",
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
// Sign In Button
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthcubitCubit>(context).loginMethod(username: emailController.text, password: passwordController.text );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'SIGN IN',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
