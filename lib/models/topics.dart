
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
}

class TopicItem {
  final String id;
  final String authorId;
  final String tab;
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
    required this.tab,
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
      lastReplyAt: DateTime.tryParse(lastReplyStr) ?? DateTime.fromMillisecondsSinceEpoch(0),
      good: (json['good'] as bool?) ?? false,
      top: (json['top'] as bool?) ?? false,
      replyCount: (json['reply_count'] as num?)?.toInt() ?? 0,
      visitCount: (json['visit_count'] as num?)?.toInt() ?? 0,
      createAt: DateTime.tryParse(createAtStr) ?? DateTime.fromMillisecondsSinceEpoch(0),
      author: authorJson != null
          ? TopicAuthor.fromJson(authorJson)
          : TopicAuthor(loginname: '', avatarUrl: ''),
    );
  }
}
// {
//       "id": "61f69e4aa08b39f75309c2a8",
//       "author_id": "4efc278525fa69ac6900000f",
//       "tab": "share",
//       "content": "\u003Cdiv class=\"markdown-text\"\u003E\u003Cp\u003E\u003Ca href=\"https://registry.npmmirror.com\"\u003Ehttps://registry.npmmirror.com\u003C/a\u003E npmmirror 镜像站在2013年12月开始就使用基于 koa 的 \u003Ca href=\"https://github.com/cnpm/cnpmjs.org\"\u003Ehttps://github.com/cnpm/cnpmjs.org\u003C/a\u003E 私有 npm 应用搭建，这些年 node 应用框架在快速换代升级，连我们自己造的 egg 都要升级到 TypeScript 了，所以在 2021 年我们启动了 \u003Ca href=\"http://cnpmjs.org\"\u003Ecnpmjs.org\u003C/a\u003E 的技术升级重构，基于 egg 的 TypeScript 模式重新实现 \u003Ca href=\"https://github.com/cnpm/cnpmcore\"\u003Ehttps://github.com/cnpm/cnpmcore\u003C/a\u003E 。\u003C/p\u003E\n\u003Cp\u003Enpm registry 的接口是 100% 实现迁移，然后在数据同步上通过数据库实现足够简单的任务系统，已经在 2022年1月30日完全老数据迁移。\n非常感谢阿里云这么多年来的对中国 npm 镜像云服务器的开源赞助，只能靠仅有的广告位和每年的感谢帖子来回报这份天价的云资源账单。这一次重构之后，我们验证下来至少可以节省一半的云服务器资源，也算是让阿里云的开源赞助可以减轻一些成本负担。\u003C/p\u003E\n\u003Cp\u003E当然 cnpmcore 不仅仅是为了技术升级，我们的核心新能力会跟随 npmfs 黑科技在 2022 年发布出来，到时候 npm install 的安装速度会在 cli 侧和 registry 侧同时发力，让 npm 模块安装速度在可预见的未来达到秒级。\u003C/p\u003E\n\u003Cp\u003EPS：预估你在此期间遇到包数据同步和丢失问题，请先手动同步一次，如果还是没有，请回帖反馈给我们。\u003C/p\u003E\n\u003C/div\u003E",
//       "title": "npmmirror 镜像站升级公告",
//       "last_reply_at": "2025-12-05T05:52:38.836Z",
//       "good": false,
//       "top": true,
//       "reply_count": 117,
//       "visit_count": 221003,
//       "create_at": "2022-01-30T14:18:50.170Z",
//       "author": {
//         "loginname": "fengmk2",
//         "avatar_url": "https://avatars.githubusercontent.com/u/156269?v=4&s=120"
//       }
//     }
