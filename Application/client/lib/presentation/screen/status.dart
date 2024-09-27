import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../logic/cubit/authcubit_cubit.dart';
import '../responsive.dart';

class HomeDevicesGrid extends StatefulWidget {
  @override
  _HomeDevicesGridState createState() => _HomeDevicesGridState();
}

class _HomeDevicesGridState extends State<HomeDevicesGrid> {
  // Sample JSON data
  final List<Map<String, dynamic>> homeDevices = [
    {
      "home_device_id": 1,
      "device_name": "براد",
      "device_type": "appliance",
      "socket_id": 17,
      "socket_name": "Socket 1",
      "socket_status": 0
    },
    {
      "home_device_id": 1,
      "device_name": "براد",
      "device_type": "appliance",
      "socket_id": 17,
      "socket_name": "Socket 1",
      "socket_status": 0
    },
    {
      "home_device_id": 1,
      "device_name": "براد",
      "device_type": "appliance",
      "socket_id": 17,
      "socket_name": "Socket 1",
      "socket_status": 0
    },
    {
      "home_device_id": 2,
      "device_name": "دفاش الماء",
      "device_type": "appliance",
      "socket_id": 18,
      "socket_name": "Socket 2",
      "socket_status": 1
    }
  ];

  // Method to toggle socket status
  void toggleStatus(int index) {
    setState(() {
      homeDevices[index]['socket_status'] =
      homeDevices[index]['socket_status'] == 1 ? 0 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthcubitCubit, AuthcubitState>(
      builder: (context, state) {
        print('State: $state');
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
        else if (state is AuthGetMyHomeDevice) {
          final device = state.device;
          return GridView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
                crossAxisSpacing: Responsive.isMobile(context) ? 2 : 15,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.0
            ),
            itemCount: homeDevices.length,
            itemBuilder: (context, index) {
              final device = homeDevices[index];
              return Card(
                color: Color(0xFF88B2AC),
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      device['device_name'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      device['socket_name'],
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Switch(
                      value: device['socket_status'] == 1,
                      onChanged: (bool value) {
                        toggleStatus(index);
                      },
                    ),
                    Text(
                      device['socket_status'] == 1 ? 'ON' : 'OFF',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: device['socket_status'] == 1
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        else if (state is AuthNoGetMyHomeDevice) {
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
    );
  }
}

