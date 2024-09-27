import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/cubit/authcubit_cubit.dart';

class AddClientScreen extends StatefulWidget {
  @override
  _AddClientScreenState createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  TextEditingController _nameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthcubitCubit, AuthcubitState>(
      listener: (context, state) async {
        if (state is AuthcubitWaiting) {
          Center(
            child: CircularProgressIndicator(color: Colors.blue),
          );
        } else if (state is AuthClientCreatedSuccessfully) {
          _showSuccessDialog(context, state.clients.msg);
        } else if (state is AuthClientNotCreatedSuccessfully) {
          _showErrorDialog(context, state.clients.msg);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add New Client'),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Client Details'),
                  _buildTextField(
                    'Name',
                    _nameController,
                    'Please enter your name',
                  ),
                  _buildTextField(
                    'User Name',
                    _userNameController,
                    'Please enter your User Name',
                  ),
                  _buildTextField(
                    'Phone',
                    _phoneController,
                    'Please enter your phone number',
                  ),
                  _buildTextField(
                    'Address',
                    _addressController,
                    'Please enter your address',
                  ),
                  _buildTextField(
                    'Password',
                    _passwordController,
                    'Please enter your password',
                    isPassword: true,
                  ),
                  SizedBox(height: 20),
                  _buildSubmitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper to build section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helper to build text fields
  Widget _buildTextField(
      String label,
      TextEditingController controller,
      String validationMessage, {
        bool isPassword = false,
        String? Function(String?)? additionalValidation,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validationMessage;
          }
          if (additionalValidation != null) {
            return additionalValidation(value);
          }
          return null;
        },
      ),
    );
  }

  // Helper to build the submit button
  Widget _buildSubmitButton(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            BlocProvider.of<AuthcubitCubit>(context).AddClient(
              name: _nameController.text,
              phone: _phoneController.text,
              username: _userNameController.text,
              address: _addressController.text,
              password: _passwordController.text,
            );
          }
        },
        child: Text(
          "Add Client",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Helper function to show a success dialog
  void _showSuccessDialog(BuildContext context, String? msg) {
    _showDialog(context, msg, true);
  }

  // Helper function to show an error dialog
  void _showErrorDialog(BuildContext context, String? msg) {
    _showDialog(context, msg, false);
  }

  // Reusable dialog for success/error messages
  void _showDialog(BuildContext context, String? msg, bool isSuccess) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
          if (isSuccess) Navigator.pop(context);
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
                    msg ?? (isSuccess ? 'Client added successfully!' : 'Failed to add client!'),
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
}
