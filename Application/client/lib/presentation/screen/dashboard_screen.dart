import 'dart:async'; // Add this import for Timer
import 'package:client/presentation/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../logic/cubit/authcubit_cubit.dart';
import '../../logic/model/expert.dart';
import '../../logic/model/model.dart';
import '../responsive.dart';
import '../widget/custom_card_widget.dart';
import '../widget/dashboard_widget.dart';
import '../widget/side_menu_widget.dart';
import '../widget/summary_widget.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<AllSolarSystemYouHave> solar = [];
  List<SolarSystemData> solarSystem = [];
  BroadcastData? broadcastData;
  int? selectedSolar_id;
  Timer? _timer; // Timer to periodically refresh data

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('clientId');
    await prefs.remove('token');
    await prefs.setBool('user', false);
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthcubitCubit>(context).fetchSolar();

    // Start a periodic refresh every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (selectedSolar_id != null) {
        BlocProvider.of<AuthcubitCubit>(context)
            .GetBroadcastData(solar_sys_info_id: selectedSolar_id.toString());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthcubitCubit, AuthcubitState>(
      builder: (context, state) {
        if (state is AuthcubitSolarSystem) {
          solar = state.solarSystem.allSolarSystemYouHave!;
          return Scaffold(
            appBar: AppBar(
              title: Text("Home Screen"),
            ),
            drawer: AppDrawer(),
            body: SafeArea(
              child: Column(
                children: [
                  buildDropdownFieldWithItems(
                      'Select Solar System',
                      solar
                          .map((solar) => DropdownMenuItem<int>(
                        value: solar.solarSysInfoId,
                        child: Text('${solar.name}'),
                      ))
                          .toList(),
                      selectedSolar_id, (value) {
                    setState(() {
                      selectedSolar_id = value;
                      // Trigger initial data load on selection
                      BlocProvider.of<AuthcubitCubit>(context).GetBroadcastData(
                          solar_sys_info_id: selectedSolar_id.toString());
                    });
                  }),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      children: <Widget>[
                        _buildMetricCard('Battery Voltage', 'null',
                            'assets/icons/flash.png'),
                        _buildMetricCard('"   Solar Power\nGeneration(W)"',
                            'null', 'assets/icons/solar-energy.png'),
                        _buildMetricCard("          Power\n Consumption(W)",
                            'null', 'assets/icons/charge.png'),
                        _buildMetricCard('Battery Percentage',
                            'null', 'assets/icons/battery.png'),
                        _buildMetricCard('Electric', 'null',
                            'assets/icons/eco-house.png'),
                        _buildMetricCard('Status', 'null',
                            'assets/icons/battery1.png'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        } else if (state is AuthcubitBroadcastData) {
          broadcastData = state.broadcastData.broadcastData;
          return Scaffold(
            appBar: AppBar(
              title: Text("Home Screen"),
            ),
            drawer: AppDrawer(),
            body: SafeArea(
              child: Column(
                children: [
                  buildDropdownFieldWithItems(
                      'Select Solar System',
                      solar
                          .map((solar) => DropdownMenuItem<int>(
                        value: solar.solarSysInfoId,
                        child: Text('${solar.name}'),
                      ))
                          .toList(),
                      selectedSolar_id, (value) {
                    setState(() {
                      selectedSolar_id = value;
                    });
                  }),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      children: <Widget>[
                        _buildMetricCard(
                            'Battery Voltage',
                            broadcastData!.batteryVoltage.toString(),
                            'assets/icons/flash.png'),
                        _buildMetricCard(
                            '"   Solar Power\nGeneration(W)"',
                            broadcastData!.solarPowerGenerationW.toString(),
                            'assets/icons/solar-energy.png'),
                        _buildMetricCard(
                            "          Power\n Consumption(W)",
                            broadcastData!.powerConsumptionW.toString(),
                            'assets/icons/charge.png'),
                        _buildMetricCard(
                            'Battery Percentage',
                            broadcastData!.batteryPercentage.toString(),
                            'assets/icons/battery.png'),
                        _buildMetricCard(
                            'Electric',
                            broadcastData!.electric == 1 ? 'Active' : 'Disabled',
                            'assets/icons/eco-house.png'),
                        _buildMetricCard(
                            'Status',
                            broadcastData!.status == 1 ? 'Active' : 'Disabled', // Conditional check
                            'assets/icons/battery1.png'
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text("Home Screen"),
            ),
            drawer: AppDrawer(),
            body: SafeArea(
              child: Column(
                children: [
                  buildDropdownFieldWithItems(
                      'Select Solar System',
                      solar
                          .map((solar) => DropdownMenuItem<int>(
                        value: solar.solarSysInfoId,
                        child: Text('${solar.name}'),
                      ))
                          .toList(),
                      selectedSolar_id, (value) {
                    setState(() {
                      selectedSolar_id = value;
                      // Trigger initial data load on selection
                      BlocProvider.of<AuthcubitCubit>(context).GetBroadcastData(
                          solar_sys_info_id: selectedSolar_id.toString());
                    });
                  }),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      children: <Widget>[
                        _buildMetricCard('Battery Voltage', 'null',
                            'assets/icons/flash.png'),
                        _buildMetricCard('"   Solar Power\nGeneration(W)"',
                            'null', 'assets/icons/solar-energy.png'),
                        _buildMetricCard("          Power\n Consumption(W)",
                            'null', 'assets/icons/charge.png'),
                        _buildMetricCard('Battery Percentage',
                            'null', 'assets/icons/battery.png'),
                        _buildMetricCard('Electric', 'null',
                            'assets/icons/eco-house.png'),
                        _buildMetricCard('Status', 'null',
                            'assets/icons/battery1.png'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
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

  Widget _buildMetricCard(String title, String value, String icon) {
    return CustomCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 40,
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 4),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 8,
              color: Colors.black54,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
