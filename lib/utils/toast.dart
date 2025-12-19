import 'package:flutter/material.dart';

enum MessageStatus {
  info(Color.fromRGBO(144, 147, 153, 1.0)),
  success(Color.fromRGBO(103, 194, 58, 1.0)),
  error(Color.fromRGBO(245, 108, 108, 1.0)),
  warning(Color.fromRGBO(230, 162, 60, 1.0));

  final Color color;

  const MessageStatus(this.color);
}

class ToastUtils {
  static void _toast(
    BuildContext context,
    MessageStatus status,
    String message, [
    int? duration,
  ]) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: status.color,
        duration: Duration(seconds: duration ?? 3),
      ),
    );
  }

  static void show(BuildContext context, String message, [int? duration]) {
    _toast(context, MessageStatus.info, message, duration);
  }

  static void showWarning(
    BuildContext context,
    String message, [
    int? duration,
  ]) {
    _toast(context, MessageStatus.warning, message, duration);
  }

  static void showError(BuildContext context, String message, [int? duration]) {
    _toast(context, MessageStatus.error, message, duration);
  }

  static void showSuccess(
    BuildContext context,
    String message, [
    int? duration,
  ]) {
    _toast(context, MessageStatus.success, message, duration);
  }
}
