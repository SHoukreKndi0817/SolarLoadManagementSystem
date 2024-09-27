import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:volta/logic/model/expert.dart';

import '../../logic/cubit/authcubit_cubit.dart';

class MyEquipment extends StatefulWidget {
  @override
  State<MyEquipment> createState() => _MyEquipmentState();
}

class _MyEquipmentState extends State<MyEquipment> {

  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<AuthcubitCubit>(context).fetchEquipment();

    super.initState();
  }

  late  List<AllPanel> panels = [
  ];

  late List<AllBattery> batteries = [
  ];

  late List<AllInverter> inverters = [
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthcubitCubit, AuthcubitState>(
      builder: (context, state) {
        if (state is AuthcubitEquipments) {
          panels = (state).trips.allPanel!;
          batteries = (state).trips.allBattery!;
          inverters = (state).trips.allInverter!;
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text(
                'Equipment',
                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
              ),
              centerTitle: true,
              backgroundColor: Colors.blue,
            ),
            body: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                _buildSectionTitle('Panels', context),
                _buildHorizontalGridView(
                  panels.map((panel) => _buildPanelItem(context, panel)).toList(),
                  Colors.lightBlue.shade50,
                ),
                _buildSectionTitle('Batteries', context),
                _buildHorizontalGridView(
                  batteries.map((battery) => _buildBatteryItem(context, battery)).toList(),
                  Colors.lightBlue.shade50,
                ),
                _buildSectionTitle('Inverters', context),
                _buildHorizontalGridView(
                  inverters.map((inverter) => _buildInverterItem(context, inverter)).toList(),
                  Colors.lightBlue.shade50,
                ),
              ],
            ),
          );
        } else if(state is AuthcubitWaiting) {
          return Center(
            child: SimpleCircularProgressBar(
              backStrokeWidth: 0,
              progressStrokeWidth: 8,
              size: 80,
              progressColors: [Colors.blue, Colors.blueAccent],
            ),
          );        }
        else {
          return Text('sczdxfc');
        }
      },
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.teal.shade800,
        ),
      ),
    );
  }

  Widget _buildHorizontalGridView(List<Widget> items, Color backgroundColor) {
    return Container(
      color: backgroundColor,
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: items,
      ),
    );
  }

  Widget _buildPanelItem(BuildContext context, AllPanel panel) {
    return GestureDetector(
      onTap: () {
        _showPanelDetails(context, panel);
      },
      child: Card(
        color: Colors.deepPurple.shade100,
        elevation: 4.0,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(panel.manufacturer.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(panel.model.toString(), style: TextStyle(fontSize: 16)),
              SizedBox(height: 4),
              Text('${panel.maxPowerOutputWatt} W', style: TextStyle(fontSize: 14, color: Colors.teal.shade700)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBatteryItem(BuildContext context, AllBattery battery) {
    return GestureDetector(
      onTap: () {
        _showBatteryDetails(context, battery);
      },
      child: Card(
        color: Colors.green.shade100,
        elevation: 4.0,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(battery.batteryType.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Absorb: ${battery.absorbStageVolts} V', style: TextStyle(fontSize: 16)),
              SizedBox(height: 4),
              Text('Float: ${battery.floatStageVolts} V', style: TextStyle(fontSize: 14, color: Colors.teal.shade700)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInverterItem(BuildContext context, AllInverter inverter) {
    return GestureDetector(
      onTap: () {
        _showInverterDetails(context, inverter);
      },
      child: Card(
        color: Colors.lightBlue.shade100,
        elevation: 4.0,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(inverter.modelName.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Power: ${inverter.invertModeRatedPower}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 4),
              Text('DC Input: ${inverter.invertModeDcInput}', style: TextStyle(fontSize: 14, color: Colors.teal.shade700)),
            ],
          ),
        ),
      ),
    );
  }

  void _showPanelDetails(BuildContext context, AllPanel panel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${panel.manufacturer} - ${panel.model}', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Max Power Output: ${panel.maxPowerOutputWatt} W'),
              Text('Cell Type: ${panel.cellType}'),
              Text('Efficiency: ${panel.efficiency}'),
              Text('Panel Type: ${panel.panelType}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close', style: TextStyle(color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }

  void _showBatteryDetails(BuildContext context, AllBattery battery) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${battery.batteryType} Battery Details', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Absorb Stage Volts: ${battery.absorbStageVolts} V'),
              Text('Float Stage Volts: ${battery.floatStageVolts} V'),
              Text('Equalize Stage Volts: ${battery.equalizeStageVolts} V'),
              Text('Equalize Interval Days: ${battery.equalizeIntervalDays}'),
              Text('Setting Switches: ${battery.setingSwitches}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close', style: TextStyle(color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }

  void _showInverterDetails(BuildContext context, AllInverter inverter) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${inverter.modelName} Inverter Details', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Operating Temperature: ${inverter.operatingTemperature}'),
              Text('Invert Mode Rated Power: ${inverter.invertModeRatedPower}'),
              Text('Invert Mode DC Input: ${inverter.invertModeDcInput}'),
              Text('Invert Mode AC Output: ${inverter.invertModeAcOutput}'),
              Text('AC Charger Mode AC Input: ${inverter.acChargerModeAcInput}'),
              Text('AC Charger Mode AC Output: ${inverter.acChargerModeAcOutput}'),
              Text('AC Charger Mode DC Output: ${inverter.acChargerModeDcOutput}'),
              Text('AC Charger Mode Max Charger: ${inverter.acChargerModeMaxCharger}'),
              Text('Solar Charger Mode Rated Power: ${inverter.solarChargerModeRatedPower}'),
              Text('Solar Charger Mode System Voltage: ${inverter.solarChargerModeSystemVoltage}'),
              Text('Solar Charger Mode MPPT Voltage Range: ${inverter.solarChargerModeMpptVoltageRange}'),
              Text('Solar Charger Mode Max Solar Voltage: ${inverter.solarChargerModeMaxSolarVoltage}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close', style: TextStyle(color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }
}
