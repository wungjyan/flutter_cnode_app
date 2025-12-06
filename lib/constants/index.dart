import 'package:flutter/material.dart';

class GlobalConstants {
  static const Color primaryColor = Color.fromRGBO(79, 57, 246, 1.0);
}

class HttpConstants {
  static const String baseUrl = 'https://cnodejs.org/api/v1';
}

class LabelInfo {
  final String text;
  final Color color;
  const LabelInfo({required this.text, required this.color});
}

class LabelConstants {
  static const Map<String, LabelInfo> labels = {
    'top': LabelInfo(text: '置顶', color: GlobalConstants.primaryColor),
    'good': LabelInfo(text: '精华', color: Colors.orange),
    'share': LabelInfo(text: '分享', color: Colors.blue),
    'ask': LabelInfo(text: '问答', color: Colors.teal),
  };

  static LabelInfo of(String code) {
    return labels[code] ?? const LabelInfo(text: '', color: Colors.grey);
  }
}
