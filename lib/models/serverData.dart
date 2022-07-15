import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:homepage_ffw_rennertehausen_cms/client.dart';
import 'package:homepage_ffw_rennertehausen_cms/models/alarm.dart';
import 'package:homepage_ffw_rennertehausen_cms/models/album_identifier.dart';
import 'package:homepage_ffw_rennertehausen_cms/models/image_source.dart';
import 'package:tuple/tuple.dart';

class ServerData extends ChangeNotifier {
  final Client _client = Client();
  bool dataLoaded = false;
  bool get authenticated => _client.authenticated;

  // login and authentication
  Future<bool> login(String host, String username, String password) async {
    await _client.connectSSH(host, username, password);

    if (_client.authenticated) {
      onAuthenticated();
    }
    return _client.authenticated;
  }

  // download server data
  void onAuthenticated() async {
    // await _client.downloadServerData(this);
    var alarmsData = await _client.getFileContent('/data/alarms.json');

    final alarms = List.from(jsonDecode(utf8.decode(alarmsData)));

    _alarms.clear();
    for (final item in alarms) {
      Alarm alarm = Alarm.fromJson(item);

      _alarms[alarm.id] = alarm;
    }

    dataLoaded = true;
    notifyListeners();
  }

  // alarms
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
    final json = jsonEncode(List.from(_alarms.values));
    final data = utf8.encode(json) as Uint8List;

    _client.uploadFileContent(data, '/data/alarms.json');

    log("Alarms synced");

    _alarmsChanged = false;
    _changedAlarms.clear();

    notifyListeners();
  }

  // images
  final Map<AlbumIdentifier, List<ImageSource>> _imagesToUpload = {};

  void addImage(ImageSource source, ImageType type, String id) {
    AlbumIdentifier identifier = AlbumIdentifier(id, type);

    if (!_imagesToUpload.containsKey(identifier)) {
      _imagesToUpload[identifier] = [];
    }

    _imagesToUpload[identifier]!.add(source);

    notifyListeners();
  }

  /// upload images by destination directory
  void uploadImages() async {
    while (_imagesToUpload.isNotEmpty) {
      final identifier = _imagesToUpload.keys.first;

      final imagesToUpload = _imagesToUpload.remove(identifier);

      final path = identifier.getImageFolderPath();
      final destFiles = await _client.getFolderContent(path);

      int idCounter = destFiles.length;

      for (var image in imagesToUpload!) {
        final destFilename = '$path/${identifier.id}_$idCounter.png';
        idCounter++;

        await _client.uploadFile(image.src, destFilename);
      }
    }
  }

  Future<List<String>> getFolderContent(String path) =>
      _client.getFolderContent(path);
}
