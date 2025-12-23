import 'package:flutter_cnode_app/utils/http.dart';

collectTopic(String topicId, String token) async {
  return await requestUtil.post(
    '/topic_collect/collect',
    data: {'topic_id': topicId, 'accesstoken': token},
  );
}

cancelCollectTopic(String topicId, String token) async {
  return await requestUtil.post(
    '/topic_collect/de_collect',
    data: {'topic_id': topicId, 'accesstoken': token},
  );
}
