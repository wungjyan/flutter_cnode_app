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
          if (response.statusCode! >= 200 && response.statusCode! < 300) {
            return handler.next(response);
          }
          final code = response.statusCode ?? 0;
          final statusMsg = response.statusMessage ?? '';
          final serverMsg = response.data?['error_msg'] ?? '';
          final msg = serverMsg.isNotEmpty
              ? serverMsg
              : 'HTTP $code $statusMsg';
          handler.next(
            DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.badResponse,
              message: msg,
            ) as Response<dynamic>,
          );
        },
        onError: (e, handler) {
          final serverMsg = e.response?.data?['error_msg'] ?? '';
          final friendlyMsg = _buildFriendlyMessage(e, serverMsg);
          handler.next(
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
      Response<dynamic> response = await _dio.get(
        url,
        queryParameters: queryParameters,
      );
      return response.data;
    } catch (e) {
      if (e is DioException) {
        return e.message ?? e.toString();
      }
      return e.toString();
    }
  }
}

final HttpUtils requestUtil = HttpUtils();
