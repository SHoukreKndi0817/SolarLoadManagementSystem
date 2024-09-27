
import 'package:client/logic/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubit/authcubit_cubit.dart';
import '../../logic/model/health_details.dart';
import '../responsive.dart';
import 'custom_card_widget.dart';

class ActivityDetailsCard extends StatefulWidget {
  final String id;
  const ActivityDetailsCard({super.key,required this.id});

  @override
  State<ActivityDetailsCard> createState() => _ActivityDetailsCardState();
}

class _ActivityDetailsCardState extends State<ActivityDetailsCard> {
  BroadcastData? broadcastData;
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<AuthcubitCubit>(context).GetBroadcastData(solar_sys_info_id: widget.id);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List<String> listPriority = [];

    final healthDetails = HealthDetails();

    return BlocBuilder<AuthcubitCubit, AuthcubitState>(
      builder: (context, state) {
        print(state);
        print('//////////////////////////////////////////////////');
        if (state is AuthcubitBroadcastData) {
          broadcastData = state.broadcastData.broadcastData;
          listPriority[0]=state.broadcastData.broadcastData!.batteryVoltage!;
          print('listPriority[0]:${listPriority[0]}');
          listPriority[1]=state.broadcastData.broadcastData!.solarPowerGenerationW.toString()!;
          listPriority[2]=state.broadcastData.broadcastData!.powerConsumptionW.toString()!;
          listPriority[3]=state.broadcastData.broadcastData!.batteryPercentage!;
          listPriority[4]=state.broadcastData.broadcastData!.electric.toString()!;
          listPriority[5]=state.broadcastData.broadcastData!.status.toString()!;
          return GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            children: <Widget>[
              _buildMetricCard('Battery Voltage', listPriority[0], 'assets/icons/flash.png'),
              _buildMetricCard('"   Solar Power\nGeneration(W)"', listPriority[0], 'assets/icons/solar-energy.png'),
              _buildMetricCard("          Power\n Consumption(W)", listPriority[0],'assets/icons/charge.png'),
              _buildMetricCard('Battery Percentage', listPriority[0], 'assets/icons/battery.png'),
              _buildMetricCard('Electric', listPriority[0], 'assets/icons/eco-house.png'),
              _buildMetricCard('Status', listPriority[0], 'assets/icons/battery1.png'),
            ],
          );
        }
        else
          return CircularProgressIndicator();
      },

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
