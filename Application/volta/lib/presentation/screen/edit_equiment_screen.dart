import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../logic/cubit/authcubit_cubit.dart';
import '../../logic/model/expert.dart';

class EditEquipmentRequestScreen extends StatefulWidget {
  final String name;
  final String numberOfBroadcastDevice;
  final String numberOfPort;
  final String numberOfSocket;
  final String numberOfPanel;
  final String numberOfBattery;
  final String numberOfInverter;
  final String additionalEquipment;
  final String requestEquipmentId;

  const EditEquipmentRequestScreen({
    super.key,
    required this.name,
    required this.numberOfBroadcastDevice,
    required this.numberOfPort,
    required this.numberOfSocket,
    required this.numberOfPanel,
    required this.numberOfBattery,
    required this.numberOfInverter,
    required this.additionalEquipment,
    required this.requestEquipmentId,
  });

  @override
  _EditEquipmentRequestScreenState createState() =>
      _EditEquipmentRequestScreenState();
}

class _EditEquipmentRequestScreenState
    extends State<EditEquipmentRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  late TextEditingController nameController;
  late TextEditingController requestEquipmentIdController;
  late TextEditingController numberOfBroadcastDeviceController;
  late TextEditingController numberOfPortController;
  late TextEditingController numberOfSocketController;
  late TextEditingController numberOfPanelController;
  late TextEditingController numberOfBatteryController;
  late TextEditingController numberOfInverterController;
  late TextEditingController additionalEquipmentController;

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

    // Initialize the TextEditingControllers with the default values from the widget
    requestEquipmentIdController =
        TextEditingController(text: widget.requestEquipmentId);
    nameController = TextEditingController(text: widget.name);
    numberOfBroadcastDeviceController =
        TextEditingController(text: widget.numberOfBroadcastDevice);
    numberOfPortController = TextEditingController(text: widget.numberOfPort);
    numberOfSocketController = TextEditingController(text: widget.numberOfSocket);
    numberOfPanelController = TextEditingController(text: widget.numberOfPanel);
    numberOfBatteryController =
        TextEditingController(text: widget.numberOfBattery);
    numberOfInverterController =
        TextEditingController(text: widget.numberOfInverter);
    additionalEquipmentController =
        TextEditingController(text: widget.additionalEquipment);

    // Load data (e.g., fetch from API)
    BlocProvider.of<AuthcubitCubit>(context).fetchEquipment();

    loadData();
  }

  void loadData() {
    // Load your data here (replace with actual API calls)
  }

  void sendRequest() {
    if (_formKey.currentState!.validate()) {
      // Gather the data
      BlocProvider.of<AuthcubitCubit>(context).EditEquipmentRequest(
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
          requestEquipmentId: widget.requestEquipmentId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthcubitCubit, AuthcubitState>(
      listener: (context, state) {
        if (state is AuthcubitEditEquipmentRequest) {
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
        } else if (state is AuthcubitNoEditEquipmentRequest) {
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
                      BlocProvider.of<AuthcubitCubit>(context).fetchEquipment();
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
          title: const Text('Edit Equipment Request'),
        ),
        body: BlocBuilder<AuthcubitCubit, AuthcubitState>(
          builder: (context, state) {
            if (state is AuthcubitEquipments) {
              panels = state.trips.allPanel!;
              batteries = state.trips.allBattery!;
              inverters = state.trips.allInverter!;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: numberOfBroadcastDeviceController,
                        decoration: const InputDecoration(
                            labelText: 'Number of Broadcast Devices'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the number of broadcast devices';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: numberOfPortController,
                        decoration: const InputDecoration(labelText: 'Number of Port'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the number of Port';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: numberOfSocketController,
                        decoration: const InputDecoration(labelText: 'Number of Socket'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the number of Socket';
                          }
                          return null;
                        },
                      ),
                      // Dropdown for Panels
                      DropdownButtonFormField<int>(
                        value: selectedPanelId,
                        decoration: const InputDecoration(labelText: 'Select Panel'),
                        items: panels.map((panel) {
                          return DropdownMenuItem<int>(
                            value: panel.panelId,
                            child: Text('${panel.manufacturer} ${panel.model}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPanelId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a panel';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: numberOfPanelController,
                        decoration: const InputDecoration(labelText: 'Number of Panels'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the number of Panels';
                          }
                          return null;
                        },
                      ),
                      // Dropdown for Batteries
                      DropdownButtonFormField<int>(
                        value: selectedBatteryId,
                        decoration: const InputDecoration(labelText: 'Select Battery'),
                        items: batteries.map((battery) {
                          return DropdownMenuItem<int>(
                            value: battery.batteryId,
                            child: Text('${battery.batteryType}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedBatteryId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a battery';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: numberOfBatteryController,
                        decoration: const InputDecoration(labelText: 'Number of Batteries'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the number of Batteries';
                          }
                          return null;
                        },
                      ),
                      // Dropdown for Inverters
                      DropdownButtonFormField<int>(
                        value: selectedInverterId,
                        decoration: const InputDecoration(labelText: 'Select Inverter'),
                        items: inverters.map((inverter) {
                          return DropdownMenuItem<int>(
                            value: inverter.invertersId,
                            child: Text('${inverter.modelName}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedInverterId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an inverter';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: numberOfInverterController,
                        decoration: const InputDecoration(labelText: 'Number of Inverters'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the number of Inverters';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: additionalEquipmentController,
                        decoration: const InputDecoration(labelText: 'Additional Equipment'),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Additional Equipment';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: sendRequest,
                        child: const Text('Edit Request'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: SimpleCircularProgressBar(
                  backStrokeWidth: 0,
                  progressStrokeWidth: 8,
                  size: 80,
                  progressColors: [Colors.blue, Colors.blueAccent],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
