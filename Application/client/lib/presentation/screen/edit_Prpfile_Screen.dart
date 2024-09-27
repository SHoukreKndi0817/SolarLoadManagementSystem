import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/authcubit_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String address;
  final String number;
  final String username;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.address,
    required this.number,
    required this.username,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController usernameController;

  bool isLoading = false;

  @override
  void initState() {
    // Initialize text controllers with the passed values
    addressController = TextEditingController(text: widget.address);
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.number);
    usernameController= TextEditingController(text: widget.username);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthcubitCubit, AuthcubitState>(
      listener: (context, state) async {
        if (state is AuthcubitEditProfile) {
          setState(() {
            isLoading = false;
          });
          // Show success dialog when profile is updated
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Profile updated successfully'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.of(context).pop();
                      BlocProvider.of<AuthcubitCubit>(context).GetProfile();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (state is AuthcubitFailed) {
          setState(() {
            isLoading = false;
          });
          // Handle failed update
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No Profile updated')),
          );
        } else if (state is AuthcubitWaiting) {
          // Show loading indicator
          setState(() {
            isLoading = true;
          });
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Edit Profile'),
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.blue,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Picture with Edit Icon
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(
                              'assets/images/2.jfif'), // Replace with your image URL
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Name Text Field
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        suffixIcon: Icon(Icons.person, color: Colors.redAccent),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'User Name',
                        suffixIcon: Icon(Icons.supervised_user_circle, color: Colors.redAccent),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your UserName';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Address Text Field
                    TextFormField(
                      controller: addressController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Address',
                        hintText: 'Edit Address',
                        suffixIcon: Icon(Icons.location_pin, color: Colors.blueAccent),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Phone Text Field
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        hintText: 'Edit phone',
                        suffixIcon: Icon(Icons.phone, color: Colors.greenAccent),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),

                    // Update Profile Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {

                          BlocProvider.of<AuthcubitCubit>(context).EditProfile(
                            name: nameController.text,
                            address: addressController.text,
                            phone: phoneController.text,
                            username: usernameController.text,
                          );

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'UPDATE PROFILE',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
