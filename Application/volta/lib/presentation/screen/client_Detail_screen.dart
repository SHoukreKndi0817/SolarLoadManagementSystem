import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:volta/presentation/screen/updateSolarSystemInfo_Screen.dart';
import '../../logic/cubit/authcubit_cubit.dart';
import '../../logic/model/expert.dart';

class ClientDetailScreen extends StatefulWidget {
  final AllClientYourAdded client;

  const ClientDetailScreen({required this.client});

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
  late List<SolarSystemData> solar = [];

  @override
  void initState() {
    super.initState();
    // Fetch solar systems when the screen initializes
    BlocProvider.of<AuthcubitCubit>(context)
        .fetchSolar(id: widget.client.clientId.toString());
  }

  Future<bool> _onWillPop() async {
    // Call the Bloc method when back is pressed
    BlocProvider.of<AuthcubitCubit>(context).fetchMyClients();
    return true; // Allow the pop action to happen
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Wrap the screen in WillPopScope
      child: BlocBuilder<AuthcubitCubit, AuthcubitState>(
        builder: (context, state) {
          if (state is AuthcubitSolarSystem) {
            solar = state.solarSystem.solarSystemData ?? [];

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
      ),
    );
  }

  Widget _buildSolarSystemsScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.client.name.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
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
                      Get.to(UpdateSolarSystemInfo(
                          clientId: widget.client.clientId.toString(),
                          name: widget.client.name.toString(),
                          solarId: solarSystem.solarSysInfoId.toString()));
                    },
                    child: Card(
                      color: Colors.blueGrey,
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
                            Text('Batteries: ${solarSystem.numberOfBattery}'),
                            Text('Panels: ${solarSystem.numberOfPanel}'),
                            Text('Panel Group: ${solarSystem.numberOfPanelGroup}'),
                            Text('battery conection type: ${solarSystem.battery_conection_type}'),
                            Text('Phase: ${solarSystem.phaseType}'),
                            Text('Panel Conection Type One: ${solarSystem.panelConectionTypeone}'),
                            Text('Panel Conection Type two: ${solarSystem.panelConectionTypetwo}'),
                            Spacer(),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                'Created: ${solarSystem.createdAt?.substring(0, 10)}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
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
      appBar: AppBar(
        title: Text(
          widget.client.name.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
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
                        color: Colors.grey,
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
        Text(
          'Client Name: ${widget.client.name}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Phone: ${widget.client.phoneNumber}',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          'Address: ${widget.client.homeAddress}',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
