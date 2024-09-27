
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubit/authcubit_cubit.dart';
import '../../logic/model/expert.dart';
import '../screen/status.dart';
import 'activity_details_card.dart';
import 'custom_card_widget.dart';

class DashboardWidget extends StatefulWidget {
  String solar;
   DashboardWidget({super.key,required this.solar});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {

   late List<AllSolarSystemYouHave> solar = [];

  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<AuthcubitCubit>(context).GetBroadcastData(solar_sys_info_id: widget.solar.toString());

    super.initState();
  }



   @override
  Widget build(BuildContext context) {
     List<String> listPriority = [];

     return BlocListener<AuthcubitCubit, AuthcubitState>(
       listener: (context, state) {
         print(state);
         print('//////////////////////////////////////////////////');
         if (state is AuthcubitBroadcastData) {

           print('adfsgddssssssssssssssssssssssssssssssssss');
           // broadcastData = state.broadcastData.broadcastData;
           listPriority[0]=state.broadcastData.broadcastData!.batteryVoltage!;
           print('listPriority[0]:${listPriority[0]}');
           listPriority[1]=state.broadcastData.broadcastData!.solarPowerGenerationW.toString()!;
           listPriority[2]=state.broadcastData.broadcastData!.powerConsumptionW.toString()!;
           listPriority[3]=state.broadcastData.broadcastData!.batteryPercentage!;
           listPriority[4]=state.broadcastData.broadcastData!.electric.toString()!;
           listPriority[5]=state.broadcastData.broadcastData!.status.toString()!;

         }

       },
       child:    Column(
       children: <Widget>[
         _buildMetricCard('Battery Voltage', 'listPriority[0]', 'assets/icons/flash.png'),
         _buildMetricCard('"   Solar Power\nGeneration(W)"', 'listPriority[0]', 'assets/icons/solar-energy.png'),
         _buildMetricCard("          Power\n Consumption(W)", 'listPriority[0]','assets/icons/charge.png'),
         _buildMetricCard('Battery Percentage','listPriority[0]', 'assets/icons/battery.png'),
         _buildMetricCard('Electric', 'listPriority[0]', 'assets/icons/eco-house.png'),
         _buildMetricCard('Status', 'listPriority[0]', 'assets/icons/battery1.png'),
       ],
     ),

     );  }
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
