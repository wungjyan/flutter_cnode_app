import 'package:flutter/material.dart';
import 'package:flutter_cnode_app/api/topics.dart';
import 'package:flutter_cnode_app/constants/index.dart';
import 'package:flutter_cnode_app/models/topics.dart';
import 'package:flutter_cnode_app/utils/formatDate.dart';

class TopicsList extends StatefulWidget {
  final String tab;
  const TopicsList({super.key, required this.tab});

  @override
  State<TopicsList> createState() => _TopicsListState();
}

class _TopicsListState extends State<TopicsList> {
  List<TopicItem> topicsList = [];
  int _page = 1;
  final int _limit = 20;
  bool _hasMore = true;
  bool _isLoading = false;
  String? _error;

  Future<void> getList({bool refresh = false}) async {
    if (_isLoading) return;
    if (!refresh && !_hasMore) return;
    setState(() {
      _isLoading = true;
      if (refresh) {
        _page = 1;
        _hasMore = true;
        _error = null;
      }
    });
    final res = await getTopicsByTab({
      'tab': widget.tab,
      'page': _page,
      'limit': _limit,
    });
    if (!mounted) return;
    if (res is Map && res["data"] is List) {
      final List<TopicItem> newItems = List<Map<String, dynamic>>.from(
        res["data"],
      ).map((item) => TopicItem.fromJson(item)).toList();
      setState(() {
        if (_page == 1) {
          topicsList = newItems;
        } else {
          topicsList.addAll(newItems);
        }
        _hasMore = newItems.length >= _limit;
        _isLoading = false;
        _error = null;
      });
    } else {
      setState(() {
        _isLoading = false;
        _error = '加载失败';
      });
    }
  }

  Future<void> _onRefresh() async {
    topicsList.clear();
    await getList(refresh: true);
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (!_isLoading && _hasMore) {
          _page++;
          getList();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && topicsList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && topicsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 8),
            TextButton(onPressed: _onRefresh, child: const Text('重试')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: topicsList.length + 1,
        itemBuilder: (context, index) {
          if (index == topicsList.length) {
            if (_isLoading && topicsList.isNotEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(child: Text(_hasMore ? '' : '没有更多了')),
            );
          }
          final item = topicsList[index];
          final avatarUrl = item.author.avatarUrl;
          final tagLabel = item.top ? '置顶' : (item.good ? '精华' : null);
          final tagColor = item.top
              ? GlobalConstants.primaryColor
              : Colors.orange;
          final timeText = formatDateAgo(item.lastReplyAt);
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: avatarUrl.isNotEmpty
                          ? Image.network(
                              avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset('lib/assets/images/default_avatar.jpg', fit: BoxFit.cover),
                            )
                          : Image.asset('lib/assets/images/default_avatar.jpg', fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (tagLabel != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                margin: const EdgeInsets.only(right: 6, top: 2),
                                decoration: BoxDecoration(
                                  color: tagColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: tagColor.withOpacity(0.4),
                                  ),
                                ),
                                child: Text(
                                  tagLabel,
                                  style: TextStyle(
                                    color: tagColor,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                item.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              item.author.loginname,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const Text(
                              ' · ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '最后回复 $timeText',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.message_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${item.replyCount}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.remove_red_eye_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${item.visitCount}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
