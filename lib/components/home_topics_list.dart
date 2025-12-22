import 'package:flutter/material.dart';
import 'package:flutter_cnode_app/api/topics.dart';
import 'package:flutter_cnode_app/components/home_topic_card.dart';
import 'package:flutter_cnode_app/models/topics.dart';

class TopicsList extends StatefulWidget {
  final String tab;
  const TopicsList({super.key, required this.tab});

  @override
  State<TopicsList> createState() => _TopicsListState();
}

class _TopicsListState extends State<TopicsList>
    with AutomaticKeepAliveClientMixin<TopicsList> {
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
    topicsList.clear();
    if (!mounted) return;
    if (res is List) {
      final List<TopicItem> newItems = List<Map<String, dynamic>>.from(
        res,
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
        _error = res is String ? res : '加载失败';
      });
    }
  }

  Future<void> _onRefresh() async {
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
    super.build(context);
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
        key: PageStorageKey('topics_${widget.tab}'),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
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
          return TopicCard(topic: item, tab: widget.tab);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
