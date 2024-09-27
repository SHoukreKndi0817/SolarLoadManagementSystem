import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import '../../logic/cubit/authcubit_cubit.dart';
import 'client_Detail_screen.dart';

class MyClientsScreen extends StatefulWidget {
  const MyClientsScreen({super.key});

  @override
  State<MyClientsScreen> createState() => _MyClientsScreenState();
}

class _MyClientsScreenState extends State<MyClientsScreen> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthcubitCubit>(context).fetchMyClients();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Search by name...',
              prefixIcon: Icon(Icons.search, color: Colors.blue),
              hintStyle: TextStyle(color: Colors.blue.shade300),
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.blue.shade100),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.blue.shade300),
              ),
            ),
            onChanged: (query) {
              context.read<AuthcubitCubit>().searchClients(query);
            },
          ),
        ),
      ),
      body: BlocBuilder<AuthcubitCubit, AuthcubitState>(
        builder: (context, state) {
          if (state is AuthcubitWaiting) {
            return Center(
              child: SimpleCircularProgressBar(
                backStrokeWidth: 0,
                progressStrokeWidth: 8,
                size: 80,
                progressColors: [Colors.blue, Colors.blueAccent],
              ),
            );
          }
          else if (state is AuthGetMyClients) {
            // إذا تم تحميل البيانات، أوقف المؤقت
            final clients = state.clients;
            return ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: clients.length,
              itemBuilder: (context, index) {
                final client = clients[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(Icons.person, color: Colors.blue.shade700),
                    ),
                    title: Text(
                      client.name.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    subtitle: Text(client.phoneNumber.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade600,
                        )),
                    onTap: () {
                      Get.to(ClientDetailScreen(client: client));
                    },
                  ),
                );
              },
            );
          }
          else if (state is AuthcubitSolarSystem) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, color: Colors.blue, size: 64),
                  SizedBox(height: 12),
                  Text(
                    'No clients found.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            );
          }
          else if (state is AuthNoGetMyClients) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 64),
                  SizedBox(height: 12),
                  Text(
                    'Failed to fetch clients.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            );
          }
          else {
            return Container();
          }
        },
      ),
    );
  }
}
