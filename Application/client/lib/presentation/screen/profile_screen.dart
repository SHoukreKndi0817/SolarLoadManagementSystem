import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'edit_Prpfile_Screen.dart';
import '../../logic/cubit/authcubit_cubit.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String username = '';
  String email = '';
  String phone = '';
  String address = '';
  String statee = '';
  String connectionCode = '';

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthcubitCubit>(context).GetProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthcubitCubit, AuthcubitState>(
      listener: (context, state) {
        if (state is AuthcubitProfile) {
          setState(() {
            name = state.client.clientData?.name ?? '';
            username = state.client.clientData?.userName ?? '';
            email = state.client.clientData?.userName ?? '';
            phone = state.client.clientData?.phoneNumber ?? '';
            address = state.client.clientData?.homeAddress ?? '';
            statee = state.client.clientData?.isActive.toString() ?? '';
            connectionCode = state.client.clientData?.connectionCode.toString() ?? '';
          });
        }
      },
      builder: (context, state) {
        // Show CircularProgressIndicator if any field is empty
        if (name.isEmpty || email.isEmpty || phone.isEmpty || address.isEmpty || statee.isEmpty) {
          return Center(
            child: SimpleCircularProgressBar(
              backStrokeWidth: 0,
              progressStrokeWidth: 8,
              size: 80,
              progressColors: [Colors.blue, Colors.blueAccent],
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Gradient Container with AppBar inside it
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.teal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Custom AppBar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
                                Get.to(EditProfileScreen(
                                  name: name,
                                  address: address,
                                  number: phone,
                                  username: username,
                                ));
                              },
                            ),
                          ],
                        ),
                      ),

                      // Profile Picture and Name
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(
                                  'assets/images/2.jfif'), // replace with your image URL
                            ),
                            SizedBox(height: 10),
                            Text(
                              name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              email,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Address Info
              ListTile(
                leading: Icon(Icons.location_pin, color: Colors.blueAccent),
                title: Text(address),
                subtitle: Text("Address"),
              ),

              // Nickname Info
              ListTile(
                leading: Icon(Icons.person, color: Colors.yellowAccent),
                title: Text(email),
                subtitle: Text("Nick Name"),
              ),

              // Emergency Contact Info
              ListTile(
                leading: Icon(Icons.contact_phone, color: Colors.pinkAccent),
                title: Text(connectionCode),
                subtitle: Text("Connection Code"),
              ),

              // Emergency Number Info
              ListTile(
                leading: Icon(Icons.phone, color: Colors.greenAccent),
                title: Text(phone),
                subtitle: Text("Emergency Number"),
              ),

              // Active State Info
              if (statee == '1')
                ListTile(
                  leading: Icon(Icons.circle, color: Colors.green),
                  title: Text("Active"),
                  subtitle: Text("State"),
                ),
            ],
          ),
        );
      },
    );
  }
}
