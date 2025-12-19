import 'package:flutter/material.dart';
import 'package:flutter_cnode_app/constants/index.dart';
import 'package:flutter_cnode_app/models/topics.dart';
import 'package:flutter_cnode_app/utils/format_date.dart';

class TopicCard extends StatefulWidget {
  final TopicItem topic;
  final String tab;
  const TopicCard({super.key, required this.topic, required this.tab});

  @override
  State<TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard> {
  @override
  Widget build(BuildContext context) {
    final topic = widget.topic;
    final avatarUrl = topic.author.avatarUrl;
    final currentTab = widget.tab;
    LabelInfo? tagInfo;
    if (currentTab == 'all') {
      tagInfo = topic.top
          ? LabelConstants.of('top')
          : (topic.good
                ? LabelConstants.of('good')
                : (topic.tab != '' ? LabelConstants.of(topic.tab!) : null));
    } else if (currentTab == 'good') {
      tagInfo = topic.top
          ? LabelConstants.of('top')
          : (topic.good ? LabelConstants.of('good') : null);
    } else {
      tagInfo = null;
    }
    final timeText = formatDateAgo(topic.lastReplyAt);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/topic_detail', arguments: topic.id);
      },
      child: Card(
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
                              Image.asset(
                                'lib/assets/images/default_avatar.jpg',
                                fit: BoxFit.cover,
                              ),
                        )
                      : Image.asset(
                          'lib/assets/images/default_avatar.jpg',
                          fit: BoxFit.cover,
                        ),
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
                        if (tagInfo != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            margin: const EdgeInsets.only(right: 6, top: 2),
                            decoration: BoxDecoration(
                              color: tagInfo.color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: tagInfo.color.withOpacity(0.4),
                              ),
                            ),
                            child: Text(
                              tagInfo.text,
                              style: TextStyle(
                                color: tagInfo.color,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            topic.title,
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
                          topic.author.loginname,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const Text(
                          ' · ',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
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
                          '${topic.replyCount}',
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
                          '${topic.visitCount}',
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
      ),
    );
  }
}
