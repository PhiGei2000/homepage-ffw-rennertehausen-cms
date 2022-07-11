import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static final String _host = "host";
  static final String _username = "username";

  static Future<String> _getString(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getString(key) ?? "";
  }

  static Future<bool> _setString(String key, String value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.setString(key, value);
  }

  static Future<String> getHost() => _getString(_host);
  static Future<bool> setHost(String host) => _setString(_host, host);

  static Future<String> getUsername() => _getString(_username);
  static Future<bool> setUsername(String username) =>
      _setString(_username, username);
}
