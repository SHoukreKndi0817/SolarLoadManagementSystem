import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../logic/model/expert.dart';
import 'add_client_screen.dart';
import 'anallytics.dart';
import 'send_equipment_request_screen.dart';
import '../../logic/cubit/authcubit_cubit.dart';
import 'addSolarSystemInfoScreen.dart';
import 'equipment_Request.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AutomaticKeepAliveClientMixin {
  List<AllClientYourAdded> clients = [];
  void initState() {
    super.initState();
    BlocProvider.of<AuthcubitCubit>(context).fetchMyClients();
  }

  
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthcubitCubit, AuthcubitState>(
        listener: (context, state) {
          if (state is AuthGetMyClients) {
            clients = (state).clients;
          }
        },
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                      title: Text('Hello Expert!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white
                      )),
                      subtitle: Text('welcome to VoltA', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white54
                      )),
                      trailing: const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/2.jfif'),
                      ),
                    ),

                    const SizedBox(height: 30)
                  ],
                ),
              ),
              Container(
                color: Colors.blue,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(200)
                      )
                  ),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 40,
                    mainAxisSpacing: 30,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(AddClientScreen());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 5),
                                    color: Theme.of(context).primaryColor.withOpacity(.2),
                                    spreadRadius: 2,
                                    blurRadius: 5
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(CupertinoIcons.add_circled, color: Colors.white)
                              ),
                              const SizedBox(height: 8),
                              Text('add client'.toUpperCase(), style: Theme.of(context).textTheme.titleMedium)
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(SendEquipmentRequestScreen());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 5),
                                    color: Theme.of(context).primaryColor.withOpacity(.2),
                                    spreadRadius: 2,
                                    blurRadius: 5
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.send, color: Colors.white)
                              ),
                              const SizedBox(height: 8),
                              Text('Add Equipment'.toUpperCase(), style: Theme.of(context).textTheme.titleMedium)
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(DashboardScreen());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 5),
                                    color: Theme.of(context).primaryColor.withOpacity(.2),
                                    spreadRadius: 2,
                                    blurRadius: 5
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(CupertinoIcons.graph_circle, color: Colors.white)
                              ),
                              const SizedBox(height: 8),
                              Text('Analytics'.toUpperCase(), style: Theme.of(context).textTheme.titleMedium)
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(AddSolarSystemInfo(clients: clients));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 5),
                                    color: Theme.of(context).primaryColor.withOpacity(.2),
                                    spreadRadius: 2,
                                    blurRadius: 5
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.solar_power_outlined, color: Colors.white)
                              ),
                              const SizedBox(height: 8),
                              Text('Add Solar\n System'.toUpperCase(), style: Theme.of(context).textTheme.titleMedium)
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(EquipmentRequestScreen());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 5),
                                    color: Theme.of(context).primaryColor.withOpacity(.2),
                                    spreadRadius: 2,
                                    blurRadius: 5
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.brown,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.add_task, color: Colors.white)
                              ),
                              const SizedBox(height: 8),
                              Text('Equipment\n  Request'.toUpperCase(), style: Theme.of(context).textTheme.titleMedium)
                            ],
                          ),
                        ),
                      ),
                      // itemDashboard('Analytics', CupertinoIcons.graph_circle, Colors.green),
                      // itemDashboard('Audience', CupertinoIcons.person_2, Colors.purple),
                      // itemDashboard('Comments', CupertinoIcons.chat_bubble_2, Colors.brown),
                      // itemDashboard('Revenue', CupertinoIcons.money_dollar_circle, Colors.indigo),
                      // itemDashboard('Upload', CupertinoIcons.add_circled, Colors.teal),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20)
            ],
          );

        },
      ),
    );
  }

  itemDashboard(String title, IconData iconData, Color background) => Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 5),
              color: Theme.of(context).primaryColor.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 5
          )
        ]
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: Colors.white)
        ),
        const SizedBox(height: 8),
        Text(title.toUpperCase(), style: Theme.of(context).textTheme.titleMedium)
      ],
    ),
  );
}
