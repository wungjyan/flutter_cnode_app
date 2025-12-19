import 'dart:convert';

import 'package:flutter_cnode_app/constants/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManage {
  static const String userInfoKey = GlobalConstants.userInfoKey;

  static Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(userInfoKey);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final data = jsonDecode(jsonStr);
      if (data is Map<String, dynamic>) {
        return data;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> setUserInfo(Map<String, dynamic> userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userInfoKey, jsonEncode(userInfo));
  }

  static Future<void> removeUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userInfoKey);
  }
}
