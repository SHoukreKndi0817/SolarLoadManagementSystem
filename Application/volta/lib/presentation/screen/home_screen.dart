import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:volta/presentation/screen/my_clients_screen.dart';
import 'package:volta/presentation/screen/profile_screen.dart';

import '../../logic/cubit/authcubit_cubit.dart';
import 'dashboard.dart';
import 'my_equipment.dart';



class HomeScreen extends StatefulWidget {
  final int selectedIndex;

  const HomeScreen({super.key,required this.selectedIndex});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _selectedIndex ;
  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    _onItemTapped(_selectedIndex);
    BlocProvider.of<AuthcubitCubit>(context).fetchMyClients();
  }
  static List<Widget> _widgetOptions = <Widget>[
    // Home(),
    MyHomePage(),
    MyClientsScreen(),
    MyEquipment(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.black,
      ),


      backgroundColor: Colors.white,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.blue,
        animationDuration: Duration(microseconds: 300),
        items: [
          CurvedNavigationBarItem(child: Icon(Icons.dashboard_customize_rounded,),label: 'Dashboard'),
          CurvedNavigationBarItem(child: Icon(Icons.people,),label: 'My Clients'),
          CurvedNavigationBarItem(child: Icon(LineAwesomeIcons.solar_panel_solid,size: 35,),label: 'Equipment'),
          CurvedNavigationBarItem(child: Icon(Icons.person,),label: 'Profile'),
        ],
        // currentIndex: _selectedIndex,
        // selectedItemColor: Colors.blue,

        onTap: _onItemTapped,
      ),
    );
  }
}








