import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../logic/cubit/authcubit_cubit.dart';
import '../../logic/model/expert.dart';
import 'addSolarSystemInfoScreen.dart';

class UpdateSolarSystemInfo extends StatefulWidget {
  final String clientId;
  final String solarId;
  final String name;

  UpdateSolarSystemInfo({super.key, required this.clientId, required this.solarId,required this.name});

  @override
  _UpdateSolarSystemInfoState createState() => _UpdateSolarSystemInfoState();
}

class _UpdateSolarSystemInfoState extends State<UpdateSolarSystemInfo> {
  final _formKey = GlobalKey<FormState>();

  // Form Fields Controllers
  TextEditingController numberOfPanelGroupController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberOfPanelController = TextEditingController();
  TextEditingController numberOfBatteryController = TextEditingController();
  TextEditingController qrCodeDataController = TextEditingController();

  // Dropdown Selections
  String? panelConnectionTypeOne;
  String? panelConnectionTypeTwo;
  String? phaseType;
  int? selectedPanelId;
  int? selectedBatteryId;
  int? selectedInverterId;
  String? selected_battery_conection_type;


  // Sample Data
  List<AllPanel> panels = [];
  List<AllBattery> batteries = [];
  List<AllInverter> inverters = [];
  List<String> connectionTypes = ["serial", "branch"];
  List<String> phaseTypes = ["one","three"];
  List<String> battery_conection_type = ["12","24","36","48"];


  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthcubitCubit>(context).fetchEquipment();
  }

  void sendRequest() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthcubitCubit>(context).updateSolarSystem(
        solar_sys_info_id: widget.solarId,
        name: nameController.text,
        inverters_id: selectedInverterId.toString(),
        number_of_battery: numberOfBatteryController.text,
        battery_id: selectedBatteryId.toString(),
        number_of_panel: numberOfPanelController.text,
        panel_id: selectedPanelId.toString(),
        number_of_panel_group: numberOfPanelGroupController.text,
        panel_conection_typeone: panelConnectionTypeOne.toString(),
        panel_conection_typetwo: panelConnectionTypeTwo.toString(),
        battery_conection_type: selected_battery_conection_type.toString(),
        phase_type: phaseType.toString(),
        qr_code_data: qrCodeDataController.text,
      );
    }
  }

  Future<void> scanQRCode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRScannerScreen()),
    );
    if (result != null) {
      setState(() {
        qrCodeDataController.text = result;
      });
    }
  }
  Future<bool> _onWillPop() async {
    // Call the Bloc method when back is pressed
    BlocProvider.of<AuthcubitCubit>(context).fetchSolar(id: widget.clientId.toString());
    return true; // Allow the pop action to happen
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Wrap the screen in WillPopScope
      child: BlocListener<AuthcubitCubit, AuthcubitState>(
        listener: (context, state) {
          if (state is AuthcubitUpdateSolarSystemInfo) {
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
                        BlocProvider.of<AuthcubitCubit>(context).fetchEquipment();
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is AuthcubitNoUpdateSolarSystemInfo) {
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
        child: BlocBuilder<AuthcubitCubit, AuthcubitState>(
          builder: (context, state) {
            if (state is AuthcubitEquipments) {
              panels = state.trips.allPanel!;
              batteries = state.trips.allBattery!;
              inverters = state.trips.allInverter!;

              return Scaffold(
                appBar: AppBar(
                  title: Text('Edit Solar System'),
                  centerTitle: true,
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        buildSectionTitle('Solar System Details'),
                        buildTextField('System Name', nameController),
                        buildTextField('Number of Panel Groups', numberOfPanelGroupController, keyboardType: TextInputType.number),
                        buildDropdownField('Panel Connection Type One', connectionTypes, panelConnectionTypeOne, (value) {
                          setState(() {
                            panelConnectionTypeOne = value;
                          });
                        }),
                        buildDropdownField('Panel Connection Type Two', connectionTypes, panelConnectionTypeTwo, (value) {
                          setState(() {
                            panelConnectionTypeTwo = value;
                          });
                        }),
                        buildDropdownField('Phase Type', phaseTypes, phaseType, (value) {
                          setState(() {
                            phaseType = value;
                          });
                        }),
                        Divider(),
                        buildSectionTitle('Equipment Details'),
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
                          },
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
                          },
                        ),
                        buildTextField('Number of Batteries', numberOfBatteryController, keyboardType: TextInputType.number),
                        buildDropdownField('Battery Conection Type', battery_conection_type, selected_battery_conection_type, (value) {
                          setState(() {
                            selected_battery_conection_type = value;
                          });
                        }),
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
                          },
                        ),
                        buildQRField(),
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
              );
            } else {
              return Center();
            }
          },
        ),
      ),
    );
  }

  Widget buildQRField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: qrCodeDataController,
        decoration: InputDecoration(
          labelText: 'QR Code Inverter',
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: scanQRCode,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please scan or enter the QR code Of Inverter';
          }
          return null;
        },
      ),
    );
  }

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

  Widget buildDropdownField(String label, List<String> items, String? value, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: items.map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        )).toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select $label' : null,
      ),
    );
  }

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
