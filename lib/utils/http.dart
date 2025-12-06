import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_cnode_app/constants/index.dart';

class HttpUtils {
  final Dio _dio = Dio();

  HttpUtils() {
    _dio.options
      ..baseUrl = HttpConstants.baseUrl
      ..connectTimeout = Duration(seconds: 5)
      ..sendTimeout = Duration(seconds: 5)
      ..receiveTimeout = Duration(seconds: 5);

    _addInterceptor();
  }

  _addInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          final statusCode = response.statusCode ?? 0;
          if (statusCode >= 200 && statusCode < 300) {
            final data = response.data;
            final isOk = data is Map && (data['success'] == true);
            if (isOk) {
              return handler.next(response);
            }
            final serverMsg = _extractServerError(data);
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                type: DioExceptionType.badResponse,
                message: serverMsg.isNotEmpty ? serverMsg : '请求失败',
              ),
            );
          }
          final statusMsg = response.statusMessage ?? '';
          final serverMsg = _extractServerError(response.data);
          return handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.badResponse,
              message: serverMsg.isNotEmpty ? serverMsg : 'HTTP $statusCode $statusMsg',
            ),
          );
        },
        onError: (e, handler) {
          final serverMsg = _extractServerError(e.response?.data);
          final friendlyMsg = _buildFriendlyMessage(e, serverMsg);
          return handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              response: e.response,
              type: e.type,
              error: e.error,
              message: friendlyMsg,
            ),
          );
        },
      ),
    );
  }

  String _extractServerError(dynamic data) {
    if (data is Map) {
      final msg = data['error_msg'];
      if (msg is String && msg.isNotEmpty) return msg.trim();
      final generic = data['message'];
      if (generic is String && generic.isNotEmpty) return generic.trim();
    }
    return '';
  }

  String _buildFriendlyMessage(DioException e, String serverMsg) {
    if (serverMsg.isNotEmpty) return serverMsg;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return '连接超时';
      case DioExceptionType.sendTimeout:
        return '请求发送超时';
      case DioExceptionType.receiveTimeout:
        return '响应接收超时';
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        final statusMsg = e.response?.statusMessage ?? '';
        if (code == 404) return '资源不存在';
        if (code == 500) return '服务器错误';
        return 'HTTP ${code ?? ''} $statusMsg';
      case DioExceptionType.cancel:
        return '请求已取消';
      case DioExceptionType.unknown:
        if (e.error is SocketException) return '网络不可用';
        return '发生未知错误';
      default:
        return '请求失败';
    }
  }

  get(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      final data = response.data;
      if (data is Map && data['success'] == true) {
        return data['data'];
      }
      final msg = _extractServerError(data);
      return msg.isNotEmpty ? msg : '请求失败';
    } catch (e) {
      if (e is DioException) {
        return e.message ?? e.toString();
      }
      return e.toString();
    }
  }
}

final HttpUtils requestUtil = HttpUtils();
