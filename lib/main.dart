import 'package:flutter/material.dart';

import 'package:homepage_ffw_rennertehausen_cms/models/serverData.dart';
import 'package:homepage_ffw_rennertehausen_cms/screens/alarm_detail_screen.dart';
import 'package:homepage_ffw_rennertehausen_cms/screens/alarms_screen.dart';
import 'package:homepage_ffw_rennertehausen_cms/screens/login_screen.dart';
import 'package:homepage_ffw_rennertehausen_cms/widgets/alarm_detail_widget.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ServerData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        // '/': (context) => Overview(),
        '/alarms': (context) => AlarmsScreen('alarms_screen'),
        '/alarmDetail': (context) => AlarmDetailScreen(),
      },
    );
  }
}
