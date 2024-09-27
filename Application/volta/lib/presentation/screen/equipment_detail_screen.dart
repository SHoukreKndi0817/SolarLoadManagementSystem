import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:volta/logic/model/expert.dart';
import 'package:volta/presentation/screen/edit_equiment_screen.dart';

import '../../logic/cubit/authcubit_cubit.dart';

class EquipmentDetailScreen extends StatefulWidget {
  final AllEquipmentRequestYourSend equipment;

  const EquipmentDetailScreen({super.key, required this.equipment});

  @override
  State<EquipmentDetailScreen> createState() => _EquipmentDetailScreenState();
}

class _EquipmentDetailScreenState extends State<EquipmentDetailScreen> {
  Future<bool> _onWillPop() async {
    // Call the Bloc method when back is pressed
    BlocProvider.of<AuthcubitCubit>(context).fetchEquipmentRequests();
    return true; // Allow the pop action to happen
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipment Details'),
        actions: [
          IconButton(
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => EditEquipmentRequestScreen(
                //             name: widget.equipment.name.toString(),
                //             numberOfBroadcastDevice: widget.equipment.numberOfBroadcastDevice.toString(),
                //             numberOfPort: widget.equipment.numberOfPort.toString(),
                //             numberOfSocket: widget.equipment.numberOfSocket.toString(),
                //             numberOfPanel: widget.equipment.numberOfPanel.toString(),
                //             numberOfBattery: widget.equipment.numberOfBattery.toString(),
                //             numberOfInverter: widget.equipment.numberOfInverter.toString(),
                //             additionalEquipment: widget.equipment.additionalEquipment.toString(),
                //             requestEquipmentId: widget.equipment.requestEquipmentId.toString(),)));
                Get.to(EditEquipmentRequestScreen(
                  name: widget.equipment.name.toString(),
                  numberOfBroadcastDevice: widget.equipment.numberOfBroadcastDevice.toString(),
                  numberOfPort: widget.equipment.numberOfPort.toString(),
                  numberOfSocket: widget.equipment.numberOfSocket.toString(),
                  numberOfPanel: widget.equipment.numberOfPanel.toString(),
                  numberOfBattery: widget.equipment.numberOfBattery.toString(),
                  numberOfInverter: widget.equipment.numberOfInverter.toString(),
                  additionalEquipment: widget.equipment.additionalEquipment.toString(),
                  requestEquipmentId: widget.equipment.requestEquipmentId.toString(),));
              },
              icon: Icon(Icons.edit))
        ],
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              buildSectionTitle(context, 'General Information'),
              buildInfoCard('Name', widget.equipment.name.toString()),
              buildInfoCard('Status', widget.equipment.status.toString()),
              buildInfoCard('Comment', widget.equipment.commet.toString()),
              buildInfoCard('Created At', widget.equipment.createdAt.toString()),
              buildInfoCard('Updated At', widget.equipment.updatedAt.toString()),
              buildSectionTitle(context, 'Panel Information'),
              buildInfoCard('Manufacturer',
                  widget.equipment.panel!.manufacturer.toString()),
              buildInfoCard('Model', widget.equipment.panel!.model.toString()),
              buildInfoCard('Max Power Output',
                  widget.equipment.panel!.maxPowerOutputWatt.toString()),
              buildInfoCard(
                  'Cell Type', widget.equipment.panel!.cellType.toString()),
              buildInfoCard(
                  'Efficiency', widget.equipment.panel!.efficiency.toString()),
              buildInfoCard(
                  'Panel Type', widget.equipment.panel!.panelType.toString()),
              buildSectionTitle(context, 'Battery Information'),
              buildInfoCard('Battery Type',
                  widget.equipment.battery!.batteryType.toString()),
              buildInfoCard('Absorb Stage Volts',
                  widget.equipment.battery!.absorbStageVolts.toString()),
              buildInfoCard('Float Stage Volts',
                  widget.equipment.battery!.floatStageVolts.toString()),
              buildInfoCard('Equalize Stage Volts',
                  widget.equipment.battery!.equalizeStageVolts.toString()),
              buildInfoCard('Setting Switches',
                  widget.equipment.battery!.setingSwitches.toString()),
              buildSectionTitle(context, 'Inverter Information'),
              buildInfoCard(
                  'Model Name', widget.equipment.inverter!.modelName.toString()),
              buildInfoCard('Rated Power',
                  widget.equipment.inverter!.invertModeRatedPower.toString()),
              buildInfoCard('DC Input',
                  widget.equipment.inverter!.invertModeDcInput.toString()),
              buildInfoCard('AC Output',
                  widget.equipment.inverter!.acChargerModeAcOutput.toString()),
              buildInfoCard(
                  'Max Solar Voltage',
                  widget.equipment.inverter!.solarChargerModeMaxSolarVoltage
                      .toString()),
              buildInfoCard(
                  'MPPT Voltage Range',
                  widget.equipment.inverter!.solarChargerModeMpptVoltageRange
                      .toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildInfoCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }
}
