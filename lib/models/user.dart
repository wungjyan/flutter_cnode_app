// ignore_for_file: non_constant_identifier_names

class UserDetail {
  String loginname;
  String avatar_url;
  String githubUsername;
  int score;
  DateTime create_at;
  List<Topic> recent_topics;
  List<Topic> recent_replies;

  UserDetail({
    required this.loginname,
    required this.avatar_url,
    required this.githubUsername,
    required this.score,
    required this.create_at,
    required this.recent_topics,
    required this.recent_replies,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      loginname: json['loginname']?.toString() ?? '',
      avatar_url: json['avatar_url']?.toString() ?? '',
      githubUsername: json['githubUsername']?.toString() ?? '',
      score: json['score']?.toInt() ?? 0,
      create_at: DateTime.parse(json['create_at']?.toString() ?? ''),
      recent_topics:
          (json['recent_topics'] as List<dynamic>?)
              ?.map((e) => Topic.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recent_replies:
          (json['recent_replies'] as List<dynamic>?)
              ?.map((e) => Topic.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Topic {
  String id;
  Author author;
  String title;
  DateTime last_reply_at;

  Topic({
    required this.id,
    required this.author,
    required this.title,
    required this.last_reply_at,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id']?.toString() ?? '',
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
      title: json['title']?.toString() ?? '',
      last_reply_at: DateTime.parse(json['last_reply_at']?.toString() ?? ''),
    );
  }
}

class Author {
  String loginname;
  String avatar_url;

  Author({required this.loginname, required this.avatar_url});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      loginname: json['loginname']?.toString() ?? '',
      avatar_url: json['avatar_url']?.toString() ?? '',
    );
  }
}
