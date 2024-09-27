import 'package:client/logic/model/expert.dart';
import 'package:client/presentation/screen/solar_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../logic/cubit/authcubit_cubit.dart';

class AllSolarSystem extends StatefulWidget {
  const AllSolarSystem({super.key});

  @override
  State<AllSolarSystem> createState() => _AllSolarSystemState();
}

class _AllSolarSystemState extends State<AllSolarSystem> {
  late List<AllSolarSystemYouHave> solar = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<AuthcubitCubit>(context).fetchSolar();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthcubitCubit, AuthcubitState>(
      builder: (context, state) {
        if (state is AuthcubitSolarSystem) {
          solar = state.solarSystem.allSolarSystemYouHave ?? [];

          if (solar.isEmpty) {
            // Display no solar systems message
            return _buildNoSolarSystemsScreen(context, isLoading: false);
          } else {
            // Display the list of solar systems
            return _buildSolarSystemsScreen(context);
          }
        }
        else if (state is AuthcubitWaiting) {
          return _buildNoSolarSystemsScreen(context, isLoading: true);
        }
        else if (state is AuthcubitNoSolarSystem) {
          // Handle error state

          return _buildNoSolarSystemsScreen(context, isLoading: false);

        }
        else {
          return _buildNoSolarSystemsScreen(context, isLoading: false);
        }
      },
    );
  }

  Widget _buildSolarSystemsScreen(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClientInfo(context),
            SizedBox(height: 20),
            Text(
              'My Solar Systems',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                  MediaQuery.of(context).size.width > 600 ? 2 : 1,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: solar.length,
                itemBuilder: (context, index) {
                  final solarSystem = solar[index];
                  return GestureDetector(
                    onTap: () {
                      BlocProvider.of<AuthcubitCubit>(context).fetchSolarInfo(id:solarSystem.solarSysInfoId.toString() );
                      BlocProvider.of<AuthcubitCubit>(context).fetchMyHomedevice(solar_sys_info_id:solarSystem.solarSysInfoId.toString() );

                      Get.to(SolarSystemInfoScreen(id: solarSystem.solarSysInfoId.toString()));

                    },
                    child: Card(
                      color: Color(0xFF7CA4B6),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              solarSystem.name ?? 'No Name',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text('Solar SysInfo Id: ${solarSystem.solarSysInfoId}'),

                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSolarSystemsScreen(BuildContext context,
      {required bool isLoading}) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClientInfo(context),
            SizedBox(height: 20),
            Text(
              'My Solar Systems',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 100),
            Center(
              child: isLoading
                  ? CircularProgressIndicator() // Show CircularProgressIndicator when loading
                  : Text(
                'No solar systems associated with this client.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF7CA4B6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

      ],
    );
  }
}
