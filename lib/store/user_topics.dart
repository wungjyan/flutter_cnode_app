// 当前用户信息中的相关主题 最近创建的话题和最近参与的话题

import 'package:flutter_cnode_app/models/user.dart';
import 'package:get/get.dart';

class UserTopics {
  final recentTopics = <Topic>[].obs;
  final recentReplies = <Topic>[].obs;

  void setList(List<Topic> topics, List<Topic> replies) {
    recentTopics.value = topics;
    recentReplies.value = replies;
  }

  List<Topic> getRecentTopicsList() {
    return List.unmodifiable(recentTopics);
  }

  List<Topic> getRecentRepliesList() {
    return List.unmodifiable(recentReplies);
  }
}
