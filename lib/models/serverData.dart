import 'dart:collection';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:homepage_ffw_rennertehausen_cms/client.dart';
import 'package:homepage_ffw_rennertehausen_cms/models/alarm.dart';

class ServerData extends ChangeNotifier {
  final Client _client = Client();
  bool dataLoaded = false;
  bool get authenticated => _client.authenticated;

  Future<bool> login(String host, String username, String password) async {
    await _client.connectSSH(host, username, password);

    if (_client.authenticated) {
      onAuthenticated();
    }
    return _client.authenticated;
  }

  void onAuthenticated() async {
    await _client.downloadServerData(this);

    dataLoaded = true;
    notifyListeners();
  }

  final List<Alarm> _alarms = [];

  void addAlarm(Alarm alarm) {
    _alarms.add(alarm);

    notifyListeners();
  }

  UnmodifiableListView<Alarm> get alarms => UnmodifiableListView(_alarms);
}
