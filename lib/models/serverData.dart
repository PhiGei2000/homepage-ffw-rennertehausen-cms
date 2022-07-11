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

  final Map<String, Alarm> _alarms = <String, Alarm>{};
  bool _alarmsChanged = false;
  List<String> _changedAlarms = [];

  void addAlarm(Alarm alarm) {
    final id = alarm.id;

    if (_alarms.containsKey(id)) {
      final oldValue = _alarms[id]!;

      if (!alarm.hasChanges(oldValue)) {
        return;
      } else {
        _alarmsChanged = true;
        if (!_changedAlarms.contains(id)) {
          _changedAlarms.add(id);
        }
      }
    }

    _alarms[id] = alarm;

    notifyListeners();
  }

  UnmodifiableMapView<String, Alarm> get alarms => UnmodifiableMapView(_alarms);
  UnmodifiableListView<String> get changedAlarms =>
      UnmodifiableListView(_changedAlarms);

  void syncAlarms() async {
    await _client.uploadAlarms(List.from(_alarms.values));

    log("Alarms synced");

    _alarmsChanged = false;
    _changedAlarms.clear();

    notifyListeners();
  }

  Future<List<String>> getFolderContent(String path) =>
      _client.getFolderContent(path);
}
