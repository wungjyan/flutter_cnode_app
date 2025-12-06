import 'package:flutter/material.dart';
import 'package:flutter_cnode_app/api/topics.dart';
import 'package:flutter_cnode_app/models/topics.dart';
import 'package:flutter_cnode_app/utils/formatDate.dart';
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
    final res = await getTopicDetail(widget.id);
    if (res is TopicDetail) {
      setState(() {
        _detail = res;
        _isLoading = false;
      });
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
      appBar: AppBar(title: Text(''),surfaceTintColor: Colors.transparent,),
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
                  _buildCustomText("发布于 ${formatDateAgo(_detail.createAt)}"),
                  _buildCustomText('•'),
                  _buildCustomText("作者 ${_detail.author.loginname}"),
                  _buildCustomText('•'),
                  _buildCustomText("${_detail.visitCount} 次浏览"),
                ],
              ),
              Divider(height: 10,thickness: 1,color: Colors.grey.withValues(alpha: 0.5),),
              Html(data: _detail.content),
            ],
          ),
        ),
      ),
    );
  }
}
