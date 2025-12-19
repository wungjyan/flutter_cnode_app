import 'package:flutter_cnode_app/models/user.dart';
import 'package:flutter_cnode_app/utils/http.dart';

handleLogin(String token) async {
  return await requestUtil.post('/accesstoken', data: {'accesstoken': token});
}

getUserDetail(String loginname) async {
  final res = await requestUtil.get('/user/$loginname');
  if (res is Map<String, dynamic>) {
    return UserDetail.fromJson(res);
  }
  return res is String ? res : '请求失败';
}
