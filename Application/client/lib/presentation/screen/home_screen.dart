import 'package:client/presentation/screen/profile_screen.dart';
import 'package:client/presentation/screen/status.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';


import '../../logic/cubit/authcubit_cubit.dart';
import 'all_solar_add.dart';
import 'dashboard_screen.dart';




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
    BlocProvider.of<AuthcubitCubit>(context).loadLoginData();
    // TODO: implement initState
  }
  static List<Widget> _widgetOptions = <Widget>[
    // Home(),
    DashboardScreen(),
    AllSolarSystem(),
    HomeDevicesGrid(),
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
          CurvedNavigationBarItem(child: Icon(Icons.solar_power,),label: 'My Solars'),
          CurvedNavigationBarItem(child: Icon(Icons.task_alt,),label: 'Tasks'),
          CurvedNavigationBarItem(child: Icon(Icons.person,),label: 'Profile'),
        ],
        // currentIndex: _selectedIndex,
        // selectedItemColor: Colors.blue,

        onTap: _onItemTapped,
      ),
    );
  }
}








