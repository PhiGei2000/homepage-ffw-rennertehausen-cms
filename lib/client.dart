import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:homepage_ffw_rennertehausen_cms/models/alarm.dart';
import 'package:json_annotation/json_annotation.dart';

import 'models/serverData.dart';

class Client {
  SSHClient? client;
  bool authenticated = false;
  SftpClient? sftp;

  Client();

  Future<void> connectSSH(String host, String username, String password) async {
    Duration timeout = Duration(seconds: 5);

    final socket = await SSHSocket.connect(host, 22, timeout: timeout);

    client = SSHClient(socket,
        username: username,
        onPasswordRequest: () => password,
        onAuthenticated: () {
          authenticated = true;
        });

    try {
      await client!.authenticated;
      sftp = await client!.sftp();
    } catch (error) {}
  }

  Future<List<SftpName>> listFiles(String path) => sftp!.listdir('./www/$path');

  Future<Uint8List> getFileContent(String path) async {
    final file = await sftp!.open('./www/$path');
    return await file.readBytes();
  }

  Future<void> downloadServerData(ServerData data) async {
    var alarmsData = await getFileContent('data/alarms.json');

    final alarms = List.from(jsonDecode(utf8.decode(alarmsData)));

    for (final alarm in alarms) {
      data.addAlarm(Alarm.fromJson(alarm));
    }
  }
}
