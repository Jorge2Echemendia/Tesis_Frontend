import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  void save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(key);
    if (stringValue == null) return null;
    return json.decode(stringValue);
  }

  Future<bool> contains(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  void logout(BuildContext context, String? id) async {
    await remove('user');
    Navigator.pushAndRemoveUntil(
        context, 'home' as Route<Object?>, (route) => false);
  }

  void login(BuildContext context) async {
    await remove('user');
    Navigator.pushNamedAndRemoveUntil(context,'login',(route)=>false);
  }
}
