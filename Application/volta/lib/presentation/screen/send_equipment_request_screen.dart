import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../logic/cubit/authcubit_cubit.dart';
import '../../logic/model/expert.dart';

class SendEquipmentRequestScreen extends StatefulWidget {
  @override
  _SendEquipmentRequestScreenState createState() => _SendEquipmentRequestScreenState();
}

class _SendEquipmentRequestScreenState extends State<SendEquipmentRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController numberOfBroadcastDeviceController = TextEditingController();
  TextEditingController numberOfPortController = TextEditingController();
  TextEditingController numberOfSocketController = TextEditingController();
  TextEditingController numberOfPanelController = TextEditingController();
  TextEditingController numberOfBatteryController = TextEditingController();
  TextEditingController numberOfInverterController = TextEditingController();
  TextEditingController additionalEquipmentController = TextEditingController();

  // Selected IDs
  int? selectedPanelId;
  int? selectedBatteryId;
  int? selectedInverterId;

  // Sample Data (Replace with actual API data)
  List<AllPanel> panels = [];
  List<AllBattery> batteries = [];
  List<AllInverter> inverters = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthcubitCubit>(context).fetchEquipment();
    loadData();
  }

  void loadData() {
    // Load your data here (replace with actual API calls)
  }

  void sendRequest() {
    if (_formKey.currentState!.validate()) {
      // Gather the data
      BlocProvider.of<AuthcubitCubit>(context).SendEquipmentRequest(
        name: nameController.text,
        number_of_broadcast_device: numberOfBroadcastDeviceController.text,
        number_of_port: numberOfPortController.text,
        number_of_socket: numberOfSocketController.text,
        panel_id: selectedPanelId.toString(),
        number_of_panel: numberOfPanelController.text,
        battery_id: selectedBatteryId.toString(),
        number_of_battery: numberOfBatteryController.text,
        inverters_id: selectedInverterId.toString(),
        number_of_inverter: numberOfInverterController.text,
        additional_equipment: additionalEquipmentController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthcubitCubit, AuthcubitState>(
      listener: (context, state) {
        if (state is AuthcubitSendEquipment) {
          String? msg= state.authResponse.msg;
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
                      BlocProvider.of<AuthcubitCubit>(context).fetchEquipment();
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is AuthcubitNoSendEquipment) {
          String? msg= state.authResponse.msg;

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
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            ),
          );
        }
      },
      child: BlocBuilder<AuthcubitCubit, AuthcubitState>(
        builder: (context, state) {
          if (state is AuthcubitEquipments) {
            panels = state.trips.allPanel!;
            batteries = state.trips.allBattery!;
            inverters = state.trips.allInverter!;

            return Scaffold(
              appBar: AppBar(
                title: Text('Send Equipment Request'),
                centerTitle: true,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      buildSectionTitle('Requestor Details'),
                      buildTextField('Name', nameController),
                      Divider(),

                      buildSectionTitle('Broadcast Devices'),
                      buildTextField('Number of Broadcast Devices', numberOfBroadcastDeviceController, keyboardType: TextInputType.number),
                      buildTextField('Number of Ports', numberOfPortController, keyboardType: TextInputType.number),
                      buildTextField('Number of Sockets', numberOfSocketController, keyboardType: TextInputType.number),
                      Divider(),

                      buildSectionTitle('Solar System Details'),
                      buildDropdownFieldWithItems(
                          'Select Panel',
                          panels.map((panel) => DropdownMenuItem<int>(
                            value: panel.panelId,
                            child: Text('${panel.manufacturer} ${panel.model}'),
                          )).toList(),
                          selectedPanelId,
                              (value) {
                            setState(() {
                              selectedPanelId = value;
                            });
                          }
                      ),
                      buildTextField('Number of Panels', numberOfPanelController, keyboardType: TextInputType.number),
                      buildDropdownFieldWithItems(
                          'Select Battery',
                          batteries.map((battery) => DropdownMenuItem<int>(
                            value: battery.batteryId,
                            child: Text('${battery.batteryType}'),
                          )).toList(),
                          selectedBatteryId,
                              (value) {
                            setState(() {
                              selectedBatteryId = value;
                            });
                          }
                      ),
                      buildTextField('Number of Batteries', numberOfBatteryController, keyboardType: TextInputType.number),
                      buildDropdownFieldWithItems(
                          'Select Inverter',
                          inverters.map((inverter) => DropdownMenuItem<int>(
                            value: inverter.invertersId,
                            child: Text('${inverter.modelName}'),
                          )).toList(),
                          selectedInverterId,
                              (value) {
                            setState(() {
                              selectedInverterId = value;
                            });
                          }
                      ),
                      buildTextField('Number of Inverters', numberOfInverterController, keyboardType: TextInputType.number),
                      buildTextField('Additional Equipment', additionalEquipmentController),

                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: sendRequest,
                        child: Text('Send Request'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is AuthcubitWaiting) {
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
            );   }else {
            return Center();
          }

        },
      ),
    );
  }

  // Helper to create section title
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

  // Helper to create text field
  Widget buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
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

  // Helper to create a dropdown field with items
  Widget buildDropdownFieldWithItems(String label, List<DropdownMenuItem<int>> items, int? value, ValueChanged<int?> onChanged) {
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
