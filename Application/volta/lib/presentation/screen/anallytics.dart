import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../logic/cubit/authcubit_cubit.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  String clientCount = '';
  String totalSolarSystems = '';
  String requestEquipmentCount = '';
  String daysWorked = '';
  late int rate  ;

  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<AuthcubitCubit>(context).GetDashboard();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthcubitCubit, AuthcubitState>(
      listener: (context, state) {
        if (state is AuthcubitDashboard) {
          setState(() {
            clientCount = state.dashboard.clientCount.toString() ?? '';
            totalSolarSystems = state.dashboard.totalSolarSystems.toString() ?? '';
            requestEquipmentCount = state.dashboard.requestEquipmentCount.toString() ?? '';
            daysWorked = state.dashboard.daysWorked.toString() ?? '';
            rate = state.dashboard.theRate!;
          });
        }
      },
      builder: (context, state) {
        // Show CircularProgressIndicator if any field is empty
        if (clientCount.isEmpty || totalSolarSystems.isEmpty || requestEquipmentCount.isEmpty || daysWorked.isEmpty) {
          return Container(
            color: Colors.white,
            child: Center(
              child: SimpleCircularProgressBar(
                backStrokeWidth: 0,
                progressStrokeWidth: 8,
                size: 80,
                progressColors: [Colors.blue, Colors.blueAccent],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Dashboard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.blue,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Success message

                // Metrics Cards
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: <Widget>[
                      _buildMetricCard('Client Count', '$clientCount', Colors.blue),
                      _buildMetricCard('Total Solar Systems', '$totalSolarSystems', Colors.orange),
                      _buildMetricCard('Request Equipment Count', '$requestEquipmentCount', Colors.red),
                      _buildMetricCard('Days Worked', '$daysWorked', Colors.purple),
                    ],
                  ),
                ),
                Container(
                  height: 250,
                  width: 250,
                  child: DashedCircularProgressBar.aspectRatio(
                    aspectRatio: 1, // width ÷ height
                    valueNotifier: _valueNotifier,
                    progress: (rate)*20,
                    startAngle: 225,
                    sweepAngle: 270,
                    foregroundColor: Colors.green,
                    backgroundColor: const Color(0xffeeeeee),
                    foregroundStrokeWidth: 15,
                    backgroundStrokeWidth: 15,
                    animation: true,
                    seekSize: 6,
                    seekColor: const Color(0xffeeeeee),
                    child: Center(
                      child: ValueListenableBuilder(
                          valueListenable: _valueNotifier,
                          builder: (_, double value, __) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${value.toInt()}%',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 60
                                ),
                              ),
                              Text(
                                'Rate',
                                style: const TextStyle(
                                    color: Color(0xff074d4d),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                  ),
                ),

                // Rating Bar
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'My Rate',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade800,
                          ),
                        ),
                        SizedBox(height: 8),
                        RatingBar(
                          initialRating: rate.toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          ratingWidget: RatingWidget(
                            full: Icon(Icons.star, color: Colors.amber),
                            empty: Icon(Icons.star_border, color: Colors.grey),
                            half: Icon(Icons.star_half, color: Colors.amber),
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricCard(String title, String value, MaterialColor color) {
    return Card(
      color: color.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color.shade900,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
