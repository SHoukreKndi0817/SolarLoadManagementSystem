import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:volta/logic/cubit/authcubit_cubit.dart';

import '../../logic/model/expert.dart';
import '../widget/equipmentItem.dart';
import 'equipment_detail_screen.dart';

class EquipmentRequestScreen extends StatefulWidget {
  @override
  State<EquipmentRequestScreen> createState() => _EquipmentRequestScreenState();
}

class _EquipmentRequestScreenState extends State<EquipmentRequestScreen> {
  late List<AllEquipmentRequestYourSend> allequipment;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthcubitCubit>(context).fetchEquipmentRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipment Requests'),
      ),
      body: BlocBuilder<AuthcubitCubit, AuthcubitState>(
        builder: (context, state) {
          if (state is AuthcubitWaiting) {
            return Center(
              child: SimpleCircularProgressBar(
                backStrokeWidth: 0,
                progressStrokeWidth: 8,
                size: 80,
                progressColors: [Colors.blue, Colors.blueAccent],
              ),
            );
          } else if (state is EquipmentError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is EquipmentLoaded) {
            allequipment = state.equipmentRequests;
            return GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75, // Adjust as per your needs
              ),
              itemCount: allequipment.length,
              itemBuilder: (context, index) {
                var requestData = allequipment[index];
                return EquipmentItem(
                  equipment: allequipment[index],
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
