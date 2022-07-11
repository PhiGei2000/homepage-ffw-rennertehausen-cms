import 'package:flutter/material.dart';
import 'package:homepage_ffw_rennertehausen_cms/widgets/alarm_detail_widget.dart';

class AlarmDetailScreen extends StatelessWidget {
  const AlarmDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var alarmIndex = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: const Text("Einsatz bearbeiten")),
      body: AlarmDetail("alarm_detail", alarmIndex),
    );
  }
}
