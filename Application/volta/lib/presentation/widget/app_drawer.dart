import 'package:flutter/material.dart';
import 'package:volta/presentation/screen/add_client_screen.dart';
import 'package:volta/presentation/screen/send_equipment_request_screen.dart';


class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add New Client'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddClientScreen()),
              );            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.send_and_archive),
            title: Text('Send Equipment Request'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SendEquipmentRequestScreen()),
              );

            },
          ),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.edit),
          //   title: Text('Manage Products'),
          //   onTap: () {
          //
          //   },
          // ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {

            },
          ),
        ],
      ),
    );
  }
}