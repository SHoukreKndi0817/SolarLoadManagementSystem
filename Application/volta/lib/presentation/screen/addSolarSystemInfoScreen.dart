import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';  // Import for QR scanning
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../logic/cubit/authcubit_cubit.dart';
import '../../logic/model/expert.dart';

class AddSolarSystemInfo extends StatefulWidget {
  final List<AllClientYourAdded> clients;

  AddSolarSystemInfo({required this.clients});

  @override
  _AddSolarSystemInfoState createState() => _AddSolarSystemInfoState();
}

class _AddSolarSystemInfoState extends State<AddSolarSystemInfo> {
  final _formKey = GlobalKey<FormState>();

  // Form Fields Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController numberOfPanelGroupController = TextEditingController();
  TextEditingController numberOfPanelController = TextEditingController();
  TextEditingController numberOfBatteryController = TextEditingController();
  TextEditingController numberOfInverterController = TextEditingController();
  TextEditingController qrCodeDataController = TextEditingController(); // Renamed for clarity

  // Dropdown Selections
  String? panelConnectionTypeOne;
  String? panelConnectionTypeTwo;
  String? phaseType;
  int? selectedPanelId;
  int? selectedBatteryId;
  int? selectedInverterId;
  int? selectedClientId;
  String? selected_battery_conection_type;

  // Sample Data
  List<AllPanel> panels = [];
  List<AllBattery> batteries = [];
  List<AllInverter> inverters = [];
  List<String> connectionTypes = ["serial", "branch"];
  List<String> battery_conection_type = ["12","24","36","48"];
  List<String> phaseTypes = ["one", "three"];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthcubitCubit>(context).fetchEquipment();
  }

  void sendRequest() {
    if (_formKey.currentState!.validate()) {
      // Implement your request submission logic
      BlocProvider.of<AuthcubitCubit>(context).AddSolarSystem(
        name: nameController.text,
        client_id: selectedClientId.toString(),
        inverters_id: selectedInverterId.toString(),
        number_of_battery: numberOfBatteryController.text,
        battery_conection_type: selected_battery_conection_type.toString(),
        battery_id: selectedBatteryId.toString(),
        number_of_panel: numberOfPanelController.text,
        panel_id: selectedPanelId.toString(),
        number_of_panel_group: numberOfPanelGroupController.text,
        panel_conection_typeone: panelConnectionTypeOne.toString(),
        panel_conection_typetwo: panelConnectionTypeTwo.toString(),
        phase_type: phaseType.toString(),
        qr_code_data: qrCodeDataController.text,
      );
    }
  }

  Future<void> scanQRCode() async {
    // Navigate to the QR scanner screen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRScannerScreen()),
    );
    if (result != null) {
      setState(() {
        qrCodeDataController.text = result; // Set the scanned QR code result
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthcubitCubit, AuthcubitState>(
      listener: (context, state) {
        if (state is AuthcubitEquipments) {
          panels = state.trips.allPanel!;
          batteries = state.trips.allBattery!;
          inverters = state.trips.allInverter!;
        }
        else if (state is AuthcubitAddSolarSystemInfo) {
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
        else if (state is AuthcubitNoAddSolarSystemInfo) {
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
          title: Text('Add Solar System'),
          centerTitle: true,
        ),
        body: BlocBuilder<AuthcubitCubit, AuthcubitState>(
          builder: (context, state) {
            if (state is AuthcubitEquipments) {
              return buildForm();
            } else if (state is AuthcubitWaiting) {
              return buildLoadingIndicator();
            } else {
              return Center();
            }
          },
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
            buildSectionTitle('Client Details'),
            buildClientDropdown(),
            Divider(),
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
                selectedPanelId, (value) {
              setState(() {
                selectedPanelId = value;
              });
            }),
            buildTextField('Number of Panels', numberOfPanelController, keyboardType: TextInputType.number),
            buildDropdownFieldWithItems(
                'Select Battery',
                batteries.map((battery) => DropdownMenuItem<int>(
                  value: battery.batteryId,
                  child: Text('${battery.batteryType}'),
                )).toList(),
                selectedBatteryId, (value) {
              setState(() {
                selectedBatteryId = value;
              });
            }),
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
                selectedInverterId, (value) {
              setState(() {
                selectedInverterId = value;
              });
            }),
            buildTextField('Number of Inverters', numberOfInverterController, keyboardType: TextInputType.number),
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
            onPressed: scanQRCode, // Open camera to scan QR code
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

  Widget buildClientDropdown() {
    return buildDropdownFieldWithItems(
      'Select Client',
      widget.clients.map((client) => DropdownMenuItem<int>(
        value: client.clientId,
        child: Text(client.name.toString()),
      )).toList(),
      selectedClientId,
          (value) {
        setState(() {
          selectedClientId = value;
        });
      },
    );
  }
}

// QR Scanner Screen using qr_code_scanner
class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan QR Code')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('QR Code Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      controller.dispose(); // Dispose the controller once scanned
      Navigator.pop(context, scanData.code); // Return the scanned result
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
