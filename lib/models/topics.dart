class TopicAuthor {
  final String loginname;
  final String avatarUrl;

  TopicAuthor({required this.loginname, required this.avatarUrl});

  factory TopicAuthor.fromJson(Map<String, dynamic> json) {
    return TopicAuthor(
      loginname: json['loginname']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString() ?? '',
    );
  }

  factory TopicAuthor.empty() => TopicAuthor(loginname: '', avatarUrl: '');
}

class TopicItem {
  final String id;
  final String authorId;
  final String? tab;
  final String content;
  final String title;
  final DateTime lastReplyAt;
  final bool good;
  final bool top;
  final int replyCount;
  final int visitCount;
  final DateTime createAt;
  final TopicAuthor author;

  TopicItem({
    required this.id,
    required this.authorId,
    this.tab,
    required this.content,
    required this.title,
    required this.lastReplyAt,
    required this.good,
    required this.top,
    required this.replyCount,
    required this.visitCount,
    required this.createAt,
    required this.author,
  });

  factory TopicItem.fromJson(Map<String, dynamic> json) {
    final lastReplyStr = json['last_reply_at']?.toString() ?? '';
    final createAtStr = json['create_at']?.toString() ?? '';
    final authorJson = json['author'] as Map<String, dynamic>?;
    return TopicItem(
      id: json['id']?.toString() ?? '',
      authorId: json['author_id']?.toString() ?? '',
      tab: json['tab']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      lastReplyAt:
          DateTime.tryParse(lastReplyStr) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      good: (json['good'] as bool?) ?? false,
      top: (json['top'] as bool?) ?? false,
      replyCount: (json['reply_count'] as num?)?.toInt() ?? 0,
      visitCount: (json['visit_count'] as num?)?.toInt() ?? 0,
      createAt:
          DateTime.tryParse(createAtStr) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      author: authorJson != null
          ? TopicAuthor.fromJson(authorJson)
          : TopicAuthor(loginname: '', avatarUrl: ''),
    );
  }
}

class TopicDetail extends TopicItem {
  final List<ReplyItem> replies;
  final bool isCollect;

  TopicDetail({
    required super.id,
    required super.authorId,
    required super.tab,
    required super.content,
    required super.title,
    required super.lastReplyAt,
    required super.good,
    required super.top,
    required super.replyCount,
    required super.visitCount,
    required super.createAt,
    required super.author,
    required this.replies,
    required this.isCollect,
  });

  factory TopicDetail.fromJson(Map<String, dynamic> json) {
    final repliesJson = json['replies'] as List<dynamic>?;
    return TopicDetail(
      id: json['id']?.toString() ?? '',
      authorId: json['author_id']?.toString() ?? '',
      tab: json['tab']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      lastReplyAt:
          DateTime.tryParse(json['last_reply_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      good: (json['good'] as bool?) ?? false,
      top: (json['top'] as bool?) ?? false,
      replyCount: (json['reply_count'] as num?)?.toInt() ?? 0,
      visitCount: (json['visit_count'] as num?)?.toInt() ?? 0,
      createAt:
          DateTime.tryParse(json['create_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      author: json['author'] != null
          ? TopicAuthor.fromJson(json['author'] as Map<String, dynamic>)
          : TopicAuthor(loginname: '', avatarUrl: ''),
      replies: repliesJson != null
          ? repliesJson
                .map((e) => ReplyItem.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      isCollect: (json['is_collect'] as bool?) ?? false,
    );
  }

  factory TopicDetail.empty() => TopicDetail(
    id: '',
    authorId: '',
    tab: '',
    content: '',
    title: '',
    lastReplyAt: DateTime.fromMillisecondsSinceEpoch(0),
    good: false,
    top: false,
    replyCount: 0,
    visitCount: 0,
    createAt: DateTime.fromMillisecondsSinceEpoch(0),
    author: TopicAuthor.empty(),
    replies: const [],
    isCollect: false,
  );
}

class ReplyItem {
  final String id;
  final TopicAuthor author;
  final String content;
  final List<String> ups;
  final DateTime createAt;
  String replyId;
  final bool isUped;

  ReplyItem({
    required this.id,
    required this.author,
    required this.content,
    required this.ups,
    required this.createAt,
    required this.replyId,
    required this.isUped,
  });

  factory ReplyItem.fromJson(Map<String, dynamic> json) {
    final createAtStr = json['create_at']?.toString() ?? '';
    final authorJson = json['author'] as Map<String, dynamic>?;
    return ReplyItem(
      id: json['id']?.toString() ?? '',
      author: authorJson != null
          ? TopicAuthor.fromJson(authorJson)
          : TopicAuthor(loginname: '', avatarUrl: ''),
      content: json['content']?.toString() ?? '',
      ups:
          (json['ups'] as List<dynamic>?)
              ?.map((e) => e?.toString() ?? '')
              .toList() ??
          [],
      createAt:
          DateTime.tryParse(createAtStr) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      replyId: json['reply_id']?.toString() ?? '',
      isUped: (json['is_uped'] as bool?) ?? false,
    );
  }
}
