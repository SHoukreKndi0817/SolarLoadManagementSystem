import 'package:flutter/material.dart';

import '../../logic/model/expert.dart';
import '../screen/equipment_detail_screen.dart';

class EquipmentItem extends StatelessWidget {
  final AllEquipmentRequestYourSend equipment;

  const EquipmentItem({Key? key, required this.equipment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
      padding: EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder:(context) => EquipmentDetailScreen(equipment: equipment,)));
        },
        child: ListTile(
          title: Text(
              'Name: ${equipment.name}'
          ),
          subtitle: Text('Status: ${equipment.status}'),
          trailing: _getStatusIcon(equipment.status.toString()),
        ),
      ),
    );
  }
  Widget _getStatusIcon(String status) {
    switch (status) {
      case 'rejected':
        return Icon(Icons.cancel, color: Colors.red); // Icon for rejected status
      case 'pending':
        return Icon(Icons.hourglass_empty, color: Colors.orange); // Icon for pending status
      default:
        return Icon(Icons.check_circle, color: Colors.green); // Icon for accepted status
    }
  }
}
