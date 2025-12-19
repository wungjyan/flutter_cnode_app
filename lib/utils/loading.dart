import 'package:flutter/material.dart';

class LoadingUtils {
  static bool _isShowing = false;

  static Future<void> show(BuildContext context, {String? message}) async {
    if (_isShowing) return;
    _isShowing = true;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  if (message != null && message.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      message,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
    _isShowing = false;
  }

  static void hide(BuildContext context) {
    if (!_isShowing) return;
    Navigator.of(context, rootNavigator: true).pop();
    _isShowing = false;
  }

  static Future<T> runWithLoading<T>(
    BuildContext context,
    Future<T> Function() task, {
    String? message,
  }) async {
    show(context, message: message);
    try {
      final result = await task();
      return result;
    } finally {
      if (context.mounted) {
        hide(context);
      }
    }
  }
}
