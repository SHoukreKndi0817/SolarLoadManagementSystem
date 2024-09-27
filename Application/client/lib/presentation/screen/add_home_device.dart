import 'package:client/logic/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart'; // Import for QR scanning
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../logic/cubit/authcubit_cubit.dart';
import '../../logic/model/expert.dart';

class AddHomeDeviceScreen extends StatefulWidget {
  final String id;

  AddHomeDeviceScreen({required this.id});

  @override
  _AddHomeDeviceScreenState createState() => _AddHomeDeviceScreenState();
}

class _AddHomeDeviceScreenState extends State<AddHomeDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  Future<bool> _onWillPop() async {
    // Call the Bloc method when back is pressed
    BlocProvider.of<AuthcubitCubit>(context).fetchMyHomedevice( solar_sys_info_id: widget.id);
    return true; // Allow the pop action to happen
  }

  // Form Fields Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController operation_max_wattController = TextEditingController();
  // Renamed for clarity

  // Dropdown Selections
  String? device_operation_type;
  String? device_type;
  String? priority;
  int? selectedSocket_id;

  // Sample Data
  List<Socket> sockets = [];
  List<String> deviceOperationType = ["inrush"];
  List<String> deviceType = ["appliance"];
  List<String> listPriority = ["high", "medium", "low"];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthcubitCubit>(context).fetchSocket(id: widget.id);
  }

  void sendRequest() {
    if (_formKey.currentState!.validate()) {
      // Implement your request submission logic
      BlocProvider.of<AuthcubitCubit>(context).AddHomeDevice(
          name: nameController.text,
          socket_id: selectedSocket_id.toString(),
          device_type: device_type.toString(),
          device_operation_type: device_operation_type.toString(),
          operation_max_watt: operation_max_wattController.text,
          priority: priority.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BlocListener<AuthcubitCubit, AuthcubitState>(
        listener: (context, state) {
          if (state is AuthcubitSocket) {
            sockets = state.socket.socket!;
          } else if (state is AuthcubitAddSolarSystemInfo) {
            String? msg = state.authResponse.msg;
            showDialog(
              context: context,
              builder: (context) => Container(
                color: Colors.white,
                child: AlertDialog(
                  title: Text('Success'),
                  content: Text(msg.toString()),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        BlocProvider.of<AuthcubitCubit>(context).fetchSocket(id: widget.id);

                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is AuthcubitNoAddSolarSystemInfo) {
            String? msg = state.authResponse.msg;
            showDialog(
              context: context,
              builder: (context) => Container(
                color: Colors.white,
                child: AlertDialog(
                  title: Text('Failed'),
                  content: Text(msg.toString()),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        BlocProvider.of<AuthcubitCubit>(context).fetchSocket(id: widget.id);

                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF7CA4B6),
            title: Text('Add Solar System'),
            centerTitle: true,
          ),
          body: BlocBuilder<AuthcubitCubit, AuthcubitState>(
            builder: (context, state) {
              if (state is AuthcubitSocket) {
                return buildForm();
              } else if (state is AuthcubitWaiting) {
                return buildLoadingIndicator();
              } else {
                return Center();
              }
            },
          ),
        ),
      ),

    );
  }

  Widget buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            buildSectionTitle('Socket Details'),
            Divider(),
            buildTextField('Device Name', nameController),
            buildTextField('Operation Max Watt', operation_max_wattController,
                keyboardType: TextInputType.number),
            buildDropdownField('Device Type', deviceType, device_type, (value) {
              setState(() {
                device_type = value;
              });
            }),
            buildDropdownField('Device Operation Type', deviceOperationType,
                device_operation_type, (value) {
              setState(() {
                device_operation_type = value;
              });
            }),
            buildDropdownField('Priority', listPriority, priority, (value) {
              setState(() {
                priority = value;
              });
            }),
            buildDropdownFieldWithItems(
                'Select Socket',
                sockets
                    .map((socket) => DropdownMenuItem<int>(
                          value: socket.socketId,
                          child: Text(
                              '${socket.socketName} ${socket.socketModel}'),
                        ))
                    .toList(),
                selectedSocket_id, (value) {
              setState(() {
                selectedSocket_id = value;
              });
            }),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendRequest,
              child: Text('Send Request'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7CA4B6),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoadingIndicator() {
    return Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: SimpleCircularProgressBar(
          backStrokeWidth: 0,
          progressStrokeWidth: 8,
          size: 80,
          progressColors: [Colors.blue, Colors.blueAccent],
        ),
      ),
    );
  }

  // QR Code field with the scan icon

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget buildDropdownField(String label, List<String> items, String? value,
      ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select $label' : null,
      ),
    );
  }

  Widget buildDropdownFieldWithItems(
      String label,
      List<DropdownMenuItem<int>> items,
      int? value,
      ValueChanged<int?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<int>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: items,
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select $label' : null,
      ),
    );
  }
}
