import 'package:flutter_cnode_app/models/topics.dart';
import 'package:flutter_cnode_app/utils/http.dart';


getTopicsByTab(Map<String,dynamic> params) async {
  return await requestUtil.get(
    '/topics',
    queryParameters: {
      'tab': params['tab'] ?? '',
      'page': params['page'] ?? 1,
      'limit': params['limit'] ?? 20,
    },
  );
}

getTopicDetail(String id) async {
  final res = await requestUtil.get('/topic/$id');
  if (res is Map<String, dynamic>) {
    return TopicDetail.fromJson(res);
  }
  return res is String ? res : '请求失败';
}
