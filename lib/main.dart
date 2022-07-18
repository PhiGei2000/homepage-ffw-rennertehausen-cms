import 'package:flutter/material.dart';
import 'package:homepage_ffw_rennertehausen_cms/models/album_identifier.dart';

import 'package:homepage_ffw_rennertehausen_cms/models/serverData.dart';
import 'package:homepage_ffw_rennertehausen_cms/screens/alarm_detail_screen.dart';
import 'package:homepage_ffw_rennertehausen_cms/screens/alarms_screen.dart';
import 'package:homepage_ffw_rennertehausen_cms/screens/image_screen.dart';
import 'package:homepage_ffw_rennertehausen_cms/screens/login_screen.dart';
import 'package:homepage_ffw_rennertehausen_cms/screens/overview_screen.dart';
import 'package:homepage_ffw_rennertehausen_cms/widgets/alarm_detail_widget.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ServerData(),
      child: const FFWRennertehausenCMSApp(),
    ),
  );
}

class FFWRennertehausenCMSApp extends StatelessWidget {
  const FFWRennertehausenCMSApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: "/login",
      routes: {
        "/": (context) => OverviewScreen(),
        "/login": (context) => LoginScreen(),
        "/alarms": (context) => AlarmsScreen("alarms_screen"),
        "/alarmDetail": (context) => const AlarmDetailScreen(),
        // "/images": (context) => ImageScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "/images") {
          final path = settings.arguments as String;
          final identifier = AlbumIdentifier.fromPath(path);

          return MaterialPageRoute(
              builder: (context) => ImageScreen(identifier));
        }

        return null;
      },
    );
  }
}
