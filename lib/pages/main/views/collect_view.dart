import 'package:flutter/material.dart';
import 'package:flutter_cnode_app/api/topic_collect.dart';
import 'package:flutter_cnode_app/components/simple_topic_item.dart';
import 'package:flutter_cnode_app/components/to_login_btn.dart';
import 'package:flutter_cnode_app/constants/index.dart';
import 'package:flutter_cnode_app/models/user.dart';
import 'package:flutter_cnode_app/store/token_manage.dart';
import 'package:flutter_cnode_app/store/user_manage.dart';
import 'package:flutter_cnode_app/utils/toast.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CollectView extends StatefulWidget {
  const CollectView({super.key});

  @override
  State<CollectView> createState() => _CollectViewState();
}

class _CollectViewState extends State<CollectView> {
  String? accesstoken;
  String loginname = '';
  List<Topic> collectTopics = [];

  _getUserCollectTopics() async {
    final cached = await UserManage.getUserInfo();
    loginname = cached?['loginname'] as String? ?? '';
    if (loginname.isEmpty) {
      return;
    }
    final res = await getUserCollectTopics(loginname);
    if (res is String) {
      ToastUtils.showError(context, res);
      return;
    }
    if (res is List) {
      final List<Topic> items = List<Map<String, dynamic>>.from(res)
          .map(
            (e) => Topic(
              id: e['id'] as String,
              title: e['title'] as String,
              author: Author.fromJson(e['author'] as Map<String, dynamic>),
              last_reply_at: DateTime.parse(e['last_reply_at'] as String),
            ),
          )
          .toList();
      setState(() {
        collectTopics = items;
      });
    }
  }

  _initAccessToken() async {
    accesstoken = await TokenManage.getToken();
  }

  _cancelCollectTopic(Topic topic) async {
    if (accesstoken == null) {
      ToastUtils.showWarning(context, '请先登录');
      return;
    }
    final res = await cancelCollectTopic(topic.id, accesstoken!);
    if (res is String) {
      ToastUtils.showError(context, res);
      return;
    }
    ToastUtils.showSuccess(context, '取消收藏成功');
    setState(() {
      collectTopics.remove(topic);
    });
  }

  @override
  void initState() {
    super.initState();
    _initAccessToken();
    _getUserCollectTopics();
  }

  @override
  Widget build(BuildContext context) {
    if (loginname.isEmpty) {
      return Center(child: ToLoginBtn(loginSuccess: _getUserCollectTopics));
    }
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: collectTopics.length,
      itemBuilder: (context, index) {
        // return SimpleTopicItem(info: collectTopics[index]);
        return Slidable(
          key: Key(collectTopics[index].id),
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) =>
                    _cancelCollectTopic(collectTopics[index]),
                backgroundColor: GlobalConstants.primaryColor,
                foregroundColor: Colors.white,
                icon: Icons.cancel,
                label: '取消收藏',
              ),
            ],
          ),
          child: SimpleTopicItem(info: collectTopics[index]),
        );
      },
    );
  }
}
