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
