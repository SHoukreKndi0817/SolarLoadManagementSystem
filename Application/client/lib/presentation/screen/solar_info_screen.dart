import 'package:client/logic/model/model.dart';
import 'package:client/presentation/screen/add_home_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:get/get.dart';
import '../../logic/cubit/authcubit_cubit.dart';
import '../responsive.dart';

class SolarSystemInfoScreen extends StatefulWidget {
  final String id;

  const SolarSystemInfoScreen({super.key, required this.id});

  @override
  State<SolarSystemInfoScreen> createState() => _SolarSystemInfoScreenState();
}

class _SolarSystemInfoScreenState extends State<SolarSystemInfoScreen> {
  SolarSystemInfo? solarSystemData;
  List<HomeDevices>? device;
  bool isLoading = true;
  bool hasError = false;
  String solar_sys_info_id='';

  Future<bool> _onWillPop() async {
    BlocProvider.of<AuthcubitCubit>(context).fetchSolar();
    return true;
  }

  // void toggleStatus(int index) {
  //   setState(() {
  //     device?[index].socketStatus =
  //     device?[index].socketStatus == 1 ? 0 : 1;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthcubitCubit>(context).fetchMyHomedevice( solar_sys_info_id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(solarSystemData?.solarSystemInformation?.name ?? 'Solar System Info'),
            actions: [IconButton(onPressed: () { Get.to(AddHomeDeviceScreen(id: solar_sys_info_id)); }, icon:Icon(Icons.add),iconSize: 30,)],
            bottom: TabBar(tabs: [
              Tab(child: Text('Detiles'),),
              Tab(child: Text('Home Device'),),
            ],),
            backgroundColor: Color(0xFF7CA4B6),
          ),
          body: TabBarView(
            children: [
              BlocListener<AuthcubitCubit, AuthcubitState>(
                listener: (context, state) {
                  if (state is AuthcubitSolarSystemInfo) {
                    setState(() {
                      solarSystemData = state.solarSystemInfo;
                      isLoading = false;
                      hasError = false;
                    });
                    solar_sys_info_id=state.solarSystemInfo.solarSystemInformation!.solarSysInfoId.toString();
                  } else if (state is AuthcubitWaiting) {
                    setState(() {
                      isLoading = true;
                      hasError = false;
                    });
                  } else if (state is AuthcubitNoSolarSystemInfo) {
                    setState(() {
                      hasError = true;
                      isLoading = false;
                    });
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No Solar System Information found!')),
                    );
                  }
                },
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : hasError
                    ? Center(child: Text('No data available'))
                    : buildSolarSystemInfoUI(),
              ),
              BlocBuilder<AuthcubitCubit, AuthcubitState>(
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
                    device = state.device;
                    return BlocListener<AuthcubitCubit, AuthcubitState>(
                      listener: (context, state) async {
                        if (state is AuthcubitWaiting) {
                          print('Waiting for login...');
                          SimpleCircularProgressBar(
                            size: 80,
                            progressStrokeWidth: 25,
                            backStrokeWidth: 25,
                          );
                        } else if (state is AuthcubitCheckPowerToSendAction) {
                          String? msg = state.solarSystemInfo.msg.toString();


                          showDialog(
                            context: context,
                            barrierDismissible: false, // Prevent closing by tapping outside
                            builder: (BuildContext context) {
                              Future.delayed(Duration(seconds: 2), () {
                                Navigator.of(context).pop(true); // Close the dialog
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
                                          msg,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (state is AuthcubitNoCheckPowerToSendAction) {
                          String? msg = state.solarSystem.msg.toString();

                          showDialog(
                            context: context,
                            barrierDismissible: false, // Prevent closing by tapping outside
                            builder: (BuildContext context) {
                              Future.delayed(Duration(seconds: 2), () {
                                Navigator.of(context).pop(true); // Close the dialog
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
                                          msg,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          Center(
                            child: CircularProgressIndicator(
                              color: Colors.yellow,
                            ),
                          );
                        }
                      },
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
                            crossAxisSpacing: Responsive.isMobile(context) ? 2 : 15,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 1.0
                        ),
                        itemCount: device?.length,
                        itemBuilder: (context, index) {
                          final devices = device?[index];
                          bool _isSwitched = devices?.socketStatus == 1;
                          void _onSwitchChanged(bool value) {
                            setState(() {
                              _isSwitched = value;
                              BlocProvider.of<AuthcubitCubit>(context).fetchMyHomedevice( solar_sys_info_id: widget.id);

                            });

                            BlocProvider.of<AuthcubitCubit>(context).changState(solar_sys_info_id: solar_sys_info_id, home_device_id: devices!.homeDeviceId.toString(), isOn: value);
                          }
                          return Card(
                            color: Color(0xFF88B2AC),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  devices!.deviceName.toString(),
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  devices!.socketName.toString(),
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(height: 8),
                                Switch(
                                  value: _isSwitched,
                                  onChanged: _onSwitchChanged,
                                ),
                                Text(
                                  devices.socketStatus == 1 ? 'ON' : 'OFF',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: devices.socketStatus == 1
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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
                            'Failed to fetch Home Device.',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSolarSystemInfoUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle("Technical Expert"),
          buildInfoRow("Name", solarSystemData!.solarSystemInformation!.name.toString()),
          buildInfoRow("Phone", solarSystemData!.solarSystemInformation!.technicalExpert!.phoneNumber.toString()),
          buildInfoRow("Address", solarSystemData!.solarSystemInformation!.technicalExpert!.homeAddress.toString()),
          Divider(),

          buildSectionTitle("Inverter Information"),
          buildInfoRow("Model", solarSystemData!.solarSystemInformation!.inverter!.modelName.toString()),
          buildInfoRow("Operating Temp", solarSystemData!.solarSystemInformation!.inverter!.operatingTemperature.toString()),
          buildInfoRow("Rated Power", solarSystemData!.solarSystemInformation!.inverter!.invertModeRatedPower.toString()),
          buildInfoRow("AC Output", solarSystemData!.solarSystemInformation!.inverter!.invertModeAcOutput.toString()),
          Divider(),

          buildSectionTitle("Battery Information"),
          buildInfoRow("Type", solarSystemData!.solarSystemInformation!.battery!.batteryType.toString()),
          buildInfoRow("Capacity", solarSystemData!.solarSystemInformation!.battery!.batteryCapacity.toString()),
          buildInfoRow("Max Watt", solarSystemData!.solarSystemInformation!.battery!.maximumWattBattery.toString()),
          buildInfoRow("Absorb Volts", solarSystemData!.solarSystemInformation!.battery!.absorbStageVolts.toString()),
          buildInfoRow("Float Volts", solarSystemData!.solarSystemInformation!.battery!.floatStageVolts.toString()),
          Divider(),

          buildSectionTitle("Panel Information"),
          buildInfoRow("Manufacturer", solarSystemData!.solarSystemInformation!.panel!.manufacturer.toString()),
          buildInfoRow("Model", solarSystemData!.solarSystemInformation!.panel!.model.toString()),
          buildInfoRow("Max Power Output", solarSystemData!.solarSystemInformation!.panel!.maxPowerOutputWatt.toString()),
          buildInfoRow("Efficiency", solarSystemData!.solarSystemInformation!.panel!.efficiency.toString()),
          buildInfoRow("Panel Type", solarSystemData!.solarSystemInformation!.panel!.panelType.toString()),
          Divider(),

          buildSectionTitle("Solar System Summary"),
          buildInfoRow("Number of Batteries", solarSystemData!.solarSystemInformation!.numberOfBattery.toString()),
          buildInfoRow("Battery Connection Type", solarSystemData!.solarSystemInformation!.batteryConectionType.toString()),
          buildInfoRow("Number of Panels", solarSystemData!.solarSystemInformation!.numberOfPanel.toString()),
          buildInfoRow("Number of Panel Groups", solarSystemData!.solarSystemInformation!.numberOfPanelGroup.toString()),
          buildInfoRow("Panel Connection Type 1", solarSystemData!.solarSystemInformation!.panelConectionTypeone.toString()),
          buildInfoRow("Panel Connection Type 2", solarSystemData!.solarSystemInformation!.panelConectionTypetwo.toString()),
          buildInfoRow("Phase Type", solarSystemData!.solarSystemInformation!.phaseType.toString()),
        ],
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
          color: Color(0xFF7CA4B6),
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
