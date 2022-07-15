import 'dart:convert';
import 'dart:developer';
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

  Future<Uint8List> getFileContent(String path) async {
    final file = await sftp!.open('./www$path');
    return await file.readBytes();
  }

  Future<void> uploadFile(String path, String dest) async {
    final file = await sftp!.open('./www$dest',
        mode: SftpFileOpenMode.create |
            SftpFileOpenMode.truncate |
            SftpFileOpenMode.write);

    return file.write(File(path).openRead().cast());
  }

  Future<void> uploadFileContent(Uint8List data, String dest) async {
    final file = await sftp!.open('./www$dest',
        mode: SftpFileOpenMode.create |
            SftpFileOpenMode.truncate |
            SftpFileOpenMode.write);

    return file.writeBytes(data);
  }

  Future<List<String>> getFolderContent(String path) async {
    try {
      final sftpFiles = await sftp!.listdir("./www$path");

      return List.generate(
          sftpFiles.length, (index) => sftpFiles[index].filename);
    } on SftpStatusError {
      return [];
    }
  }
}
