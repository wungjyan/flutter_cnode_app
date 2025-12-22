import 'package:flutter/material.dart';
import 'package:flutter_cnode_app/components/simple_topic_item.dart';
import 'package:flutter_cnode_app/models/user.dart';
import 'package:flutter_cnode_app/store/user_topics.dart';
import 'package:get/get.dart';

class UserTopicsList extends StatefulWidget {
  final String flag;
  const UserTopicsList({super.key, required this.flag});

  @override
  State<UserTopicsList> createState() => _UserTopicsListState();
}

class _UserTopicsListState extends State<UserTopicsList> {
  final userTopics = Get.find<UserTopics>();
  var pageTitle = '暂无用户话题';
  final topics = <Topic>[].obs;

  @override
  void initState() {
    super.initState();
    if (widget.flag == 'recent_topics') {
      pageTitle = '最近创建的话题';
      topics.value = userTopics.getRecentTopicsList();
    } else if (widget.flag == 'recent_replies') {
      pageTitle = '最近参与的话题';
      topics.value = userTopics.getRecentRepliesList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(pageTitle), backgroundColor: Colors.white),
      body: Obx(() {
        return widget.flag == ''
            ? Center(child: Text(pageTitle))
            : ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  final topic = topics[index];
                  return SimpleTopicItem(info: topic);
                },
              );
      }),
    );
  }
}
