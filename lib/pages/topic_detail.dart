import 'package:flutter/material.dart';
import 'package:flutter_cnode_app/api/topic_collect.dart';
import 'package:flutter_cnode_app/api/topics.dart';
import 'package:flutter_cnode_app/constants/index.dart';
import 'package:flutter_cnode_app/models/topics.dart';
import 'package:flutter_cnode_app/store/token_manage.dart';
import 'package:flutter_cnode_app/utils/format_date.dart';
import 'package:flutter_cnode_app/utils/toast.dart';
import 'package:flutter_html/flutter_html.dart';

class TopicDetailPage extends StatefulWidget {
  final String id;
  const TopicDetailPage({super.key, required this.id});

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  TopicDetail _detail = TopicDetail.empty();

  bool _isLoading = false;

  _getDetail() async {
    _isLoading = true;
    final token = await TokenManage.getToken();
    final res = await getTopicDetail(widget.id, token);
    if (res is TopicDetail) {
      setState(() {
        _detail = res;
        _isLoading = false;
      });
    }
  }

  changeTopicCollectStatus() async {
    final token = await TokenManage.getToken();
    if (token == null) {
      return;
    }
    Map<String, dynamic> res = {};
    if (_detail.isCollect) {
      res = await cancelCollectTopic(_detail.id, token);
    } else {
      res = await collectTopic(_detail.id, token);
    }
    if (res['success'] == true) {
      ToastUtils.showSuccess(context, _detail.isCollect ? '取消收藏成功' : '收藏成功');
      await _getDetail();
      setState(() {});
    } else {
      ToastUtils.showError(context, _detail.isCollect ? '取消收藏失败' : '收藏失败');
    }
  }

  @override
  void initState() {
    super.initState();
    _getDetail();
  }

  Widget _buildCustomText(String txt) {
    return Text(txt, style: TextStyle(fontSize: 12, color: Colors.grey));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(''),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () => {changeTopicCollectStatus()},
            child: Padding(
              padding: EdgeInsets.only(right: 12),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: GlobalConstants.primaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(
                      _detail.isCollect
                          ? Icons.star_rate_rounded
                          : Icons.star_border,
                      size: 16,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      _detail.isCollect ? "取消收藏" : "收藏",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _detail.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 4,
                      children: [
                        _buildCustomText(
                          "发布于 ${formatDateAgo(_detail.createAt)}",
                        ),
                        _buildCustomText('•'),
                        _buildCustomText("作者 ${_detail.author.loginname}"),
                        _buildCustomText('•'),
                        _buildCustomText("${_detail.visitCount} 次浏览"),
                      ],
                    ),
                    Divider(
                      height: 10,
                      thickness: 1,
                      color: Colors.grey.withValues(alpha: 0.5),
                    ),
                    Html(data: _detail.content),
                  ],
                ),
              ),
      ),
    );
  }
}
