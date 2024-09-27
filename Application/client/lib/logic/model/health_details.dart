
import 'health_model.dart';

class HealthDetails {
  final healthData = const [
    HealthModel(
        icon: 'assets/icons/flash.png', value: "12.50", title: "Battery Voltage"),
    HealthModel(
        icon: 'assets/icons/solar-energy.png', value: "0", title: "   Solar Power\nGeneration(W)"),
    HealthModel(
        icon: 'assets/icons/charge.png', value: "200W", title: "          Power\n Consumption(W)"),
    HealthModel(icon: 'assets/icons/battery.png', value: "80%", title: "Battery Percentage"),
    HealthModel(icon: 'assets/icons/eco-house.png', value: "Active", title: "Electric"),
    HealthModel(icon: 'assets/icons/battery1.png', value: "Active", title: "Status"),
  ];
}
